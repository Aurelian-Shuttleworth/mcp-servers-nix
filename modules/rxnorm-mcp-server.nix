{ mkServerModule, ... }:
{
  imports = [
    (mkServerModule {
      name = "rxnorm-mcp-server";
      packageName = "rxnorm-mcp-server";
    })
  ];
}
