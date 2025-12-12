# These tests verify that the wrapper functionality correctly handles environment variables
# from both passwordCommand and envFile without leaking sensitive information to the Nix store.
{ pkgs }:
let
  mcp-servers = import ../. { inherit pkgs; };
  printenv = pkgs.writeScriptBin "printenv" ''
    ${pkgs.coreutils}/bin/printenv
  '';
in
{
  test-wrapper-password-command-attrs =
    let
      passCmd = pkgs.writeScript "passcmd" ''
        echo dummy-token
      '';
      evaluated-module = mcp-servers.lib.evalModule pkgs {
        programs = {
          github = {
            enable = true;
            package = printenv;
            passwordCommand = {
              TEST = [ "${passCmd}" ];
            };
          };
        };
      };
    in
    pkgs.runCommand "test-wrapper-password-command-attrs"
      { nativeBuildInputs = with pkgs; [ gnugrep ]; }
      ''
        touch $out
        # Verify that the environment variable is correctly exported when the command is run
        ${evaluated-module.config.settings.servers.github.command} | grep -q TEST=dummy-token
        # Verify that the sensitive token is NOT stored in the generated config file
        ! grep -q dummy-token ${evaluated-module.config.configFile}
      '';
  test-wrapper-password-command-str =
    let
      passCmd = pkgs.writeScript "passcmd" ''
        echo TEST=dummy-token
      '';
      evaluated-module = mcp-servers.lib.evalModule pkgs {
        programs = {
          github = {
            enable = true;
            package = printenv;
            passwordCommand = "${passCmd}";
          };
        };
      };
    in
    pkgs.runCommand "test-wrapper-password-command-str" { nativeBuildInputs = with pkgs; [ gnugrep ]; }
      ''
        touch $out
        # Verify that the environment variable is correctly exported when the command is run
        ${evaluated-module.config.settings.servers.github.command} | grep -q TEST=dummy-token
        # Verify that the sensitive token is NOT stored in the generated config file
        ! grep -q dummy-token ${evaluated-module.config.configFile}
      '';
  test-wrapper-env-file =
    let
      env = pkgs.writeText ".env" ''
        TEST=dummy-token
      '';
      evaluated-module = mcp-servers.lib.evalModule pkgs {
        programs = {
          github = {
            enable = true;
            package = printenv;
            envFile = env;
          };
        };
      };
    in
    pkgs.runCommand "test-wrapper-env-file" { nativeBuildInputs = with pkgs; [ gnugrep ]; } ''
      touch $out
      # Verify that the environment variable is correctly exported when the command is run
      ${evaluated-module.config.settings.servers.github.command} | grep -q TEST=dummy-token
      # Verify that the sensitive token is NOT stored in the generated config file
      ! grep -q dummy-token ${evaluated-module.config.configFile}
    '';
}
