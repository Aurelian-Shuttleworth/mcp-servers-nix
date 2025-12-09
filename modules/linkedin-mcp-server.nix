{
  config,
  lib,
  mkServerModule,
  ...
}:
let
  cfg = config.programs.linkedin-mcp-server;
in
{
  imports = [
    (mkServerModule {
      name = "linkedin-mcp-server";
      packageName = "linkedin-mcp-server";
    })
  ];

  options.programs.linkedin-mcp-server = {
    cookie = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = ''
        LinkedIn authentication cookie (li_at).
        WARNING: Setting this here will store the key in the Nix store (world-readable).
        For better security, use `programs.linkedin-mcp-server.envFile`.
      '';
      example = "li_at=...";
    };
  };

  config.settings.servers = lib.mkIf cfg.enable {
    linkedin-mcp-server = {
      env = lib.optionalAttrs (cfg.cookie != null) {
        LINKEDIN_COOKIE = cfg.cookie;
      };
    };
  };
}
