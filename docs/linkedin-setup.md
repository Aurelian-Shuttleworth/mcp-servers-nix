# LinkedIn MCP Server Setup

The `linkedin-mcp-server` allows AI assistants to interact with LinkedIn (scrape profiles, companies, jobs). It requires a LinkedIn session cookie (`li_at`) to authenticate.

## Prerequisites

### 1. Get your LinkedIn Cookie

1.  Open [LinkedIn](https://www.linkedin.com) in your browser (e.g., Chrome) and log in.
2.  Open **Developer Tools** (F12 or Right-click > Inspect).
3.  Go to the **Application** tab.
4.  In the left sidebar, expand **Cookies** and select `https://www.linkedin.com`.
5.  Find the cookie named `li_at`.
6.  Copy its **Value**.

**Note**: Cookies expire typically after 30 days or if you log out. You will need to update this value periodically.

## Configuration in Nix

You can configure the server in your Nix flake using the `mcp-servers-nix` library.

### Secure Usage (Recommended)

Store the cookie in an environment file or 1Password to avoid committing it to Git or the Nix Store.

**Using an .env file:**
Create `~/.linkedin-env`:

```bash
LINKEDIN_COOKIE=li_at=YOUR_COPIED_VALUE
```

_(Note: Ensure the format includes `li_at=` prefix if the tool requires it, or just the value. Upstream example shows `li_at=VALUE`)_

Configure Nix:

```nix
programs.linkedin-mcp-server = {
  enable = true;
  envFile = "/path/to/.linkedin-env";
};
```

## Antigravity / Generic MCP Client Configuration

```json
{
  "linkedin": {
    "command": "nix",
    "args": [
      "run",
      "github:Aurelian-Shuttleworth/mcp-servers-nix/feature/linkedin-mcp-server#linkedin-mcp-server"
    ],
    "env": {
      "LINKEDIN_COOKIE": "li_at=YOUR_COPIED_VALUE"
    }
  }
}
```
