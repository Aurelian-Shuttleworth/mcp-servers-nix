{
  pkgs ? import <nixpkgs> { },
}:
let
  mcp-servers = import ../. { inherit pkgs; };
in
mcp-servers.lib.mkConfig pkgs {
  programs.obsidian-mcp-server = {
    enable = true;
    # Optional: Defaults to http://127.0.0.1:27123
    baseUrl = "http://127.0.0.1:27123";

    # Option 1: Env file (Recommended)
    envFile = "/path/to/.obsidian-env";

    # Option 2: Direct API Key (Warning: stores key in world-readable store)
    # apiKey = "your-api-key";
  };
}
