# Gmail MCP Server Setup

The `gmail-mcp-server` allows Claude to interact with your Gmail and Google Calendar.

## Prerequisites

1.  **Google Cloud Project**: You need a Google Cloud Project with Gmail API and Google Calendar API enabled.
2.  **OAuth Credentials**: You need a Client ID and Client Secret.

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
      - `https://www.googleapis.com/auth/calendar`
      - `https://www.googleapis.com/auth/calendar.events`
    - Add Test Users: Add your own email address.

3.  **Create Credentials**
    - Create OAuth Client ID (Web Application).
    - Add Authorized Redirect URI: `https://developers.google.com/oauthplayground` (for easy token generation).
    - Copy **Client ID** and **Client Secret**.

4.  **Get Refresh Token**
    - Go to [Google OAuth Playground](https://developers.google.com/oauthplayground).
    - Click the gear icon:
      - Check "Use your own OAuth credentials".
      - Paste your Client ID and Client Secret.
    - On the left, input the scopes listed above.
    - Click **Authorize APIs**.
    - Exchange authorization code for tokens.
    - Copy the **Refresh Token**.

5.  **Create Environment File**
    Create a file (e.g., `gmail.env`):

    ```env
    GOOGLE_CLIENT_ID=your_client_id
    GOOGLE_CLIENT_SECRET=your_client_secret
    GOOGLE_REFRESH_TOKEN=your_refresh_token
    # REDIRECT_URI is not strictly checked for background tasks but good to match
    REDIRECT_URI=https://developers.google.com/oauthplayground
    ```

6.  **Configure Nix Module**
    ```nix
    programs.gmail-mcp-server = {
      enable = true;
      envFile = "/path/to/gmail.env";
    };
    ```

## Antigravity / Generic MCP Client Configuration

If you are manually configuring an MCP client (like Antigravity) via a JSON config file, you can run the server directly using `nix run`.

Add the following to your `mcpServers` configuration:

```json
{
  "gmail-mcp-server": {
    "command": "nix",
    "args": [
      "run",
      "github:Aurelian-Shuttleworth/mcp-servers-nix/feature/gmail-mcp-server#gmail-mcp-server"
    ],
    "env": {
      "GOOGLE_CLIENT_ID": "your_client_id",
      "GOOGLE_CLIENT_SECRET": "your_client_secret",
      "GOOGLE_REFRESH_TOKEN": "your_refresh_token"
    }
  }
}
```
