{
  pkgs ? import <nixpkgs> {
    system = "aarch64-darwin";
  },
}:
let
  mcp-servers = import ../. { inherit pkgs; };
in
mcp-servers.lib.mkConfig pkgs {
  programs.rxnorm-mcp-server = {
    enable = true;
  };
}
