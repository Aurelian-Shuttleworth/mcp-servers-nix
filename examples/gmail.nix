{
  pkgs ? import <nixpkgs> { },
}:
let
  mcp-servers = import ../. { inherit pkgs; };
in
mcp-servers.lib.mkConfig pkgs {
  programs.gmail-mcp-server = {
    enable = true;
    envFile = "/path/to/gmail-env-file";
  };
}
