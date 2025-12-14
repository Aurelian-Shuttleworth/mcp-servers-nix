{
  pkgs ? import <nixpkgs> { },
}:
let
  mcp-servers = import ../. { inherit pkgs; };
in
mcp-servers.lib.mkConfig pkgs {
  programs.gitlab-mcp = {
    enable = true;
    # Option 1: Env file (Recommended for secrets)
    # The file should contain:
    # GITLAB_PERSONAL_ACCESS_TOKEN=your_token_here
    envFile = "/path/to/.gitlab-env";

    settings = {
      GITLAB_API_URL = "https://gitlab.com/api/v4"; # Optional, default is https://gitlab.com/api/v4
      # GITLAB_PROJECT_ID = "12345678"; # Optional default project
      # GITLAB_ALLOWED_PROJECT_IDS = [ "12345678" "87654321" ]; # Optional project whitelist
    };
  };
}
