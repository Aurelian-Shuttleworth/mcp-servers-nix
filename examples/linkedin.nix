{
  pkgs ? import <nixpkgs> { },
}:
let
  mcp-servers = import ../. { inherit pkgs; };
in
mcp-servers.lib.mkConfig pkgs {
  programs.linkedin-mcp-server = {
    enable = true;
    # Option 1: Env file (Recommended)
    envFile = "/path/to/.linkedin-env";

    # Option 2: Direct Cookie (Warning: stores in world-readable store)
    # cookie = "li_at=...";
  };
}
