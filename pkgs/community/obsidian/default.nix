{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
}:

buildNpmPackage rec {
  pname = "obsidian-mcp-server";
  version = "2.0.7";

  src = fetchFromGitHub {
    owner = "cyanheads";
    repo = "obsidian-mcp-server";
    tag = "v${version}";
    hash = "sha256-uis9pk9OnXIja8aSEaOdXhTnVzi1i+rlr6BrdOiJSDE=";
  };

  npmDepsHash = "sha256-hnzl1jV6GnAEAO2Px3Xdnx30upa3hdJYdrncNen12yU=";

  postPatch = ''
    substituteInPlace src/config/index.ts \
      --replace-fail 'path.join(projectRoot, "logs")' '"/tmp/obsidian-mcp-server/logs"' \
      --replace-fail '!resolvedDirPath.startsWith(rootDir + path.sep)' 'false'
  '';

  meta = {
    description = "MCP server for Obsidian";
    homepage = "https://github.com/cyanheads/obsidian-mcp-server";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "obsidian-mcp-server";
  };
}
