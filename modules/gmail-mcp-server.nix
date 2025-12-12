{ mkServerModule, ... }:
{
  imports = [
    (mkServerModule {
      name = "gmail-mcp-server";
      packageName = "gmail-mcp-server";
    })
  ];
}
