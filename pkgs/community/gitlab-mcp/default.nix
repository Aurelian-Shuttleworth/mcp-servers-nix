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
    hash = "sha256-l/R5na0fecE7+qeDUW4XK7McNUyONMCKEo8KY2zZ2QU=";
  };

  npmDepsHash = "sha256-eSKWr+dWrMf19Xb+5eKI4ZkBLTH09qysj+4rxpjWrSE=";

  meta = {
    description = "MCP server for using the GitLab API";
    homepage = "https://github.com/zereight/gitlab-mcp";
    license = lib.licenses.mit;
    mainProgram = "gitlab-mcp";
    maintainers = [ ];
  };
}
