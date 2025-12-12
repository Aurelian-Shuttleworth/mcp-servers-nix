# RxNorm MCP Server Setup

This MCP server provides tools to lookup drug RxCUIs using the National Library of Medicine (NLM) RxNorm APIs.

## Features

- **`find_drug_rxcui(drug_name)`**: Resolves a drug name (e.g., "Ibuprofen") to its standardized RxNorm ID (RxCUI).

> **Note**: The NLM Drug Interaction API was discontinued in 2024, so this server does NOT support interaction checking at this time.

## Configuration

Since the NLM APIs are public and free for this usage, no API keys or complex configuration is required.

### `examples/rxnorm.nix`

```nix
{
  pkgs ? import <nixpkgs> {
    system = "aarch64-darwin";
  },
}:
let
  mcp-servers = import ../. { inherit pkgs; };
in
mcp-servers.lib.mkMcpConfig {
  rxnorm-mcp-server = {
    enable = true;
  };
}
```
