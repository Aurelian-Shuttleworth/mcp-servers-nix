{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  runCommand,
}:
let
  version = "1.1.11";
  remoteSrc = fetchFromGitHub {
    owner = "GongRzhe";
    repo = "Gmail-MCP-Server";
    rev = "a890d19189bbc1325b8728fab830fc278cfd8804";
    hash = "sha256-cmnnRwQUOro7idWQySzhUfkKcnnLcpVYsi8JwwHeypg=";
  };
in
buildNpmPackage {
  pname = "gmail-mcp-server";
  inherit version;

  src = runCommand "gmail-mcp-server-src" { } ''
    cp -r ${remoteSrc} $out
    chmod -R +w $out
    cp ${./package-lock.json} $out/package-lock.json
  '';

  npmDepsHash = "sha256-8bIfDL/NaeJy6SQA24Pw+Awkhw3ofYNDIAGfkWbmD6c=";

  makeCacheWritable = true;
  npmFlags = [ "--legacy-peer-deps" ];

  meta = {
    description = "Gmail MCP server with auto authentication support";
    homepage = "https://github.com/GongRzhe/Gmail-MCP-Server";
    license = lib.licenses.isc;
    maintainers = [ ];
    mainProgram = "gmail-mcp";
  };
}
