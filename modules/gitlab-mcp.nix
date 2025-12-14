{
  config,
  lib,
  mkServerModule,
  ...
}:
let
  cfg = config.programs.gitlab-mcp;
in
{
  imports = [
    (mkServerModule {
      name = "gitlab-mcp";
      packageName = "gitlab-mcp";
    })
  ];

  options.programs.gitlab-mcp = {
    settings = {
      GITLAB_API_URL = lib.mkOption {
        type = lib.types.str;
        default = "https://gitlab.com/api/v4";
        description = "GitLab API URL";
      };
      GITLAB_PROJECT_ID = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Default project ID";
      };
      GITLAB_ALLOWED_PROJECT_IDS = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = "Allowed project IDs";
      };
    };
  };

  config.settings.servers = lib.mkIf cfg.enable {
    gitlab-mcp = {
      env = {
        GITLAB_API_URL = cfg.settings.GITLAB_API_URL;
      }
      // lib.optionalAttrs (cfg.settings.GITLAB_PROJECT_ID != null) {
        GITLAB_PROJECT_ID = cfg.settings.GITLAB_PROJECT_ID;
      }
      // lib.optionalAttrs (cfg.settings.GITLAB_ALLOWED_PROJECT_IDS != [ ]) {
        GITLAB_ALLOWED_PROJECT_IDS = lib.concatStringsSep "," cfg.settings.GITLAB_ALLOWED_PROJECT_IDS;
      };
    };
  };
}
