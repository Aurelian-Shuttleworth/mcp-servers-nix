# Gmail MCP Server Setup

The `gmail-mcp-server` allows Claude to interact with your Gmail and Google Calendar.
This server uses **file-based authentication** (providing `gcp-oauth.keys.json` and generating `credentials.json`).

## Prerequisites

1.  **Google Cloud Project**: You need a Google Cloud Project with Gmail API and Google Calendar API enabled.
2.  **OAuth Credentials**: You need to download the Desktop/Web client credentials as a JSON file.

## Configuration Steps

1.  **Create Google Cloud Project**
    - Go to [Google Cloud Console](https://console.cloud.google.com/).
    - Create a new project.
    - Enable **Gmail API** and **Google Calendar API**.

2.  **Configure OAuth Consent Screen**
    - Set User Type to **External** (or Internal if you have a Workspace).
    - Add Scopes:
      - `https://www.googleapis.com/auth/gmail.readonly`
      - `https://www.googleapis.com/auth/gmail.modify`
      - `https://www.googleapis.com/auth/gmail.compose`
      - `https://www.googleapis.com/auth/calendar`
      - `https://www.googleapis.com/auth/calendar.events`
    - Add Test Users: Add your own email address.

3.  **Create Credentials**
    - Go to **APIs & Services > Credentials**.
    - Click **Create Credentials > OAuth client ID**.
    - Choose **Desktop app**. (Web application is also supported but Desktop is easier for local auth).
    - Download the JSON file.
    - Rename it to `gcp-oauth.keys.json`.

4.  **Run Authentication**
    You need to run the server in `auth` mode to generate the `credentials.json` token file.

    Run the following command in the directory where you saved `gcp-oauth.keys.json`:

    ```bash
    nix run github:Aurelian-Shuttleworth/mcp-servers-nix/feature/gmail-mcp-server#gmail-mcp-server -- auth
    ```

    - This will open your browser to log in.
    - Upon success, it will generate a `credentials.json` file in your default global location (`~/.gmail-mcp/`) or current directory, depending on how the tool behaves (usually `~/.gmail-mcp/`).
    - **Note**: The server looks for keys in `~/.gmail-mcp/` or the current directory.

5.  **Persist Credentials**
    Ensure both `gcp-oauth.keys.json` and `credentials.json` are stored in formatted location, e.g., `~/.gmail-mcp/` or a secure folder.

6.  **Configure Nix Module**
    Point the server to these files using environment variables.

    ```nix
    programs.gmail-mcp-server = {
      enable = true;
      env = {
        GMAIL_OAUTH_PATH = "/Users/username/.gmail-mcp/gcp-oauth.keys.json";
        GMAIL_CREDENTIALS_PATH = "/Users/username/.gmail-mcp/credentials.json";
      };
    };
    ```

## Antigravity / Generic MCP Client Configuration

If you are manually configuring an MCP client (like Antigravity) via a JSON config file:

```json
{
  "gmail": {
    "command": "nix",
    "args": [
      "run",
      "github:Aurelian-Shuttleworth/mcp-servers-nix/feature/gmail-mcp-server#gmail-mcp-server"
    ],
    "env": {
      "GMAIL_OAUTH_PATH": "/Users/aurelianshuttleworth/.gmail-mcp/gcp-oauth.keys.json",
      "GMAIL_CREDENTIALS_PATH": "/Users/aurelianshuttleworth/.gmail-mcp/credentials.json"
    }
  }
}
```
