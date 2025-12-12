{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:
buildNpmPackage {
  pname = "gmail-mcp-server";
  version = "unstable-2024-05-22";

  src = fetchFromGitHub {
    owner = "zacco16";
    repo = "gmail-mcp-server";
    rev = "810812f2483f63e200c93ed49738a5186d0f092e";
    hash = "sha256-VcKAl1BD5FRW3NYR7MPJHACZAiU5myBnt4PB5oxkQ5g=";
  };

  npmDepsHash = "sha256-yC+gEmQj6VtN2ZBUg0nHfVKRHevBIwxvb8YbDItDqzw=";

  makeCacheWritable = true;
  npmFlags = [ "--legacy-peer-deps" ];

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
    npm pkg set bin.gmail-mcp-server="./dist/index.js"
    # Create empty .npmignore to prevent npm from ignoring dist/ based on .gitignore
    touch .npmignore
  '';

  preFixup = ''
    chmod +x $out/lib/node_modules/gmail-mcp-server/dist/index.js
  '';

  dontBuild = false;

  # The package.json has a build script "npm run clean && tsc"
  # buildNpmPackage runs `npm run build` by default if it exists.

  meta = {
    description = "MCP server for Gmail API integration";
    homepage = "https://github.com/zacco16/gmail-mcp-server";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "gmail-mcp-server";
  };
}
