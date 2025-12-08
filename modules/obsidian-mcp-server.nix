{
  config,
  lib,
  mkServerModule,
  ...
}:
let
  cfg = config.programs.obsidian-mcp-server;
in
{
  imports = [
    (mkServerModule {
      name = "obsidian-mcp-server";
      packageName = "obsidian-mcp-server";
    })
  ];

  options.programs.obsidian-mcp-server = {
    baseUrl = lib.mkOption {
      type = lib.types.str;
      default = "http://127.0.0.1:27123";
      description = "Base URL for the Obsidian Local REST API.";
      example = "http://127.0.0.1:27123";
    };
    apiKey = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = ''
        API Key for the Obsidian Local REST API.
        WARNING: Setting this here will store the key in the Nix store (world-readable).
        For better security, use `programs.obsidian-mcp-server.envFile` or `programs.obsidian-mcp-server.passwordCommand`.
      '';
      example = "your-api-key";
    };
  };

  config.settings.servers = lib.mkIf cfg.enable {
    obsidian-mcp-server = {
      env = {
        OBSIDIAN_BASE_URL = cfg.baseUrl;
      }
      // lib.optionalAttrs (cfg.apiKey != null) {
        OBSIDIAN_API_KEY = cfg.apiKey;
      };
    };
  };
}
