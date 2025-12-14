{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "gitlab-mcp";
  version = "2.0.13";

  src = fetchFromGitHub {
    owner = "zereight";
    repo = "gitlab-mcp";
    rev = "v${version}";
    hash = "sha256-01frv5n662lg2a5c0d4f9hsircrb2xp530x7z8xw2y8zmnfpkx4p";
  };

  npmDepsHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";

  meta = {
    description = "MCP server for using the GitLab API";
    homepage = "https://github.com/zereight/gitlab-mcp";
    license = lib.licenses.mit;
    mainProgram = "gitlab-mcp";
    maintainers = with lib.maintainers; [ ];
  };
}
