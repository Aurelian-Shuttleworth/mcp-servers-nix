# Google Calendar MCP Server Setup

The `google-calendar-mcp` server allows AI assistants to manage your Google Calendar events. It requires a Google Cloud Project with the Calendar API enabled and OAuth 2.0 desktop credentials.

## Prerequisites

### 1. Google Cloud Setup

1.  Go to the [Google Cloud Console](https://console.cloud.google.com).
2.  Create a new project or select an existing one.
3.  Enable the **[Google Calendar API](https://console.cloud.google.com/apis/library/calendar-json.googleapis.com)** for your project.
4.  Configure the **OAuth Consent Screen**:
    - Select **External** (unless you are in a Google Workspace organization).
    - Add your email as a **Test User**. _Important: Without this, you cannot authenticate._
5.  Create **OAuth 2.0 Credentials**:
    - Go to **Credentials** > **Create Credentials** > **OAuth client ID**.
    - Application Type: **Desktop app**.
    - Name: `Claude Desktop` (or similar).
    - Click **Create** and **Download JSON**.
    - Save this file to a secure location (e.g., `~/secrets/google-calendar-oauth.json`).

### 2. Authentication Note

By default, your app is in "Testing" mode, meaning refresh tokens expire after **7 days**. You will need to re-authenticate weekly unless you publish the app in the Google Cloud Console.

## Configuration in Nix

You can configure the server in your Nix flake using the `mcp-servers-nix` library.

### Nix Module Configuration

```nix
programs.google-calendar = {
  enable = true;
  env = {
    # Path to the downloaded OAuth JSON file
    GOOGLE_OAUTH_CREDENTIALS = "/path/to/your/google-calendar-oauth.json";
  };
};
```

## Antigravity / Generic MCP Client Configuration

If you are manually configuring an MCP client (like Antigravity) via a JSON config file:

```json
{
  "google-calendar": {
    "command": "nix",
    "args": [
      "run",
      "github:Aurelian-Shuttleworth/mcp-servers-nix/feature/google-calendar#google-calendar-mcp"
    ],
    "env": {
      "GOOGLE_OAUTH_CREDENTIALS": "/path/to/your/google-calendar-oauth.json"
    }
  }
}
```
