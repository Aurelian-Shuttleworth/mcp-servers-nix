# Obsidian MCP Server Setup

The `obsidian-mcp-server` allows AI assistants to interact with your Obsidian vault via the Model Context Protocol. It communicates with your vault using the [Obsidian Local REST API](https://github.com/coddingtonbear/obsidian-local-rest-api) plugin.

## Prerequisites

1.  **Install Obsidian Local REST API Plugin**:
    - Open Obsidian Settings > Community Plugins.
    - Click "Browse" and search for "Local REST API".
    - Install and Enable the plugin.

2.  **Configure the Plugin**:
    - Go to Settings > Community Plugins > Local REST API.
    - Ensure the server is enabled.
    - Copy the **API Key**. You will need this for configuration.
    - Note the port (default is `27123`).

## Configuration in Nix

You can configure the server in your Nix flake using the `mcp-servers-nix` library.

### Basic Usage (API Key in Store)

> **Warning**: This method stores your API key in the world-readable Nix store. Use only for testing or single-user machines where this risk is acceptable.

```nix
programs.obsidian-mcp-server = {
  enable = true;
  baseUrl = "http://127.0.0.1:27123"; # Default
  apiKey = "your-generated-api-key";
};
```

### Secure Usage (Recommended)

To keep your API key secure, use `envFile` or `passwordCommand`.

#### Using an Environment File

Create a file (e.g., `~/.obsidian-env`) containing:

```bash
OBSIDIAN_API_KEY=your-generated-api-key
```

Then configure Nix:

```nix
programs.obsidian-mcp-server = {
  enable = true;
  envFile = "/Users/youruser/.obsidian-env";
  # baseUrl defaults to http://127.0.0.1:27123
};
```

#### Using 1Password CLI (Example)

```nix
programs.obsidian-mcp-server = {
  enable = true;
  passwordCommand = "op read op://Private/Obsidian/api-key";
};
```

## Antigravity / Generic MCP Client Configuration

If you are manually configuring an MCP client (like Antigravity) via a JSON config file, you can run the server directly using `nix run`.

Add the following to your `mcpServers` configuration:

```json
{
  "obsidian-mcp-server": {
    "command": "nix",
    "args": [
      "run",
      "github:Aurelian-Shuttleworth/mcp-servers-nix/feat/obsidian-mcp-server#obsidian-mcp-server"
    ],
    "env": {
      "OBSIDIAN_API_KEY": "your-generated-api-key",
      "OBSIDIAN_BASE_URL": "http://127.0.0.1:27123"
    }
  }
}
```
