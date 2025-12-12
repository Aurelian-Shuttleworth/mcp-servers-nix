{
  lib,
  python3,
}:

python3.pkgs.buildPythonApplication {
  pname = "rxnorm-mcp-server";
  version = "0.1.0";
  pyproject = true;

  src = ./src;

  build-system = [
    python3.pkgs.hatchling
  ];

  dependencies = with python3.pkgs; [
    mcp
    httpx
  ];

  meta = {
    description = "MCP server for RxNorm drug interactions and lookup";
    homepage = "https://github.com/natsukium/mcp-servers-nix"; # Internal
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "rxnorm-mcp-server";
  };
}
