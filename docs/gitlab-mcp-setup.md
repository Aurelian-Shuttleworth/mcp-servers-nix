# GitLab MCP Server Setup

This server integrates GitLab with MCP, allowing you to search repositories, manage issues, and view merge requests.

## Prerequisites

- **GitLab Personal Access Token (PAT)**:
  1. Go to GitLab > Preferences > Access Tokens.
  2. Create a new token with `read_api` (and `api` if write access is needed) scope.

## Configuration

### 1. Create an Environment File

Create a file (e.g., `~/.gitlab-mcp-env`) with your token:

```bash
GITLAB_PERSONAL_ACCESS_TOKEN=glpat-xxxxxxxxxxxxxxxxxxxx
```

> [!WARNING]
> Do NOT store this file in your Nix store/Git repo.

### 2. Configure Nix Module

Use the `gitlab-mcp` module in your configuration:

```nix
programs.gitlab-mcp = {
  enable = true;
  envFile = "/home/youruser/.gitlab-mcp-env";

  settings = {
    GITLAB_API_URL = "https://gitlab.com/api/v4";
    # GITLAB_PROJECT_ID = "12345678"; # Optional default project
  };
};
```

## Antigravity / Generic MCP Client Configuration

```json
{
  "gitlab": {
    "command": "nix",
    "args": [
      "run",
      "github:Aurelian-Shuttleworth/mcp-servers-nix/feature/gitlab-mcp-server#gitlab-mcp"
    ],
    "env": {
      "GITLAB_PERSONAL_ACCESS_TOKEN": "glpat-xxxxxxxxxxxxxxxxxxxx",
      "GITLAB_API_URL": "https://gitlab.com/api/v4"
    }
  }
}
```
