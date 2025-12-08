{
  pkgs ? import <nixpkgs> { },
}:
let
  mcp-servers = import ../. { inherit pkgs; };
in
mcp-servers.lib.mkConfig pkgs {
  programs.google-calendar = {
    enable = true;
    env = {
      GOOGLE_OAUTH_CREDENTIALS = "/path/to/client_secret.json";
    };
  };
}
