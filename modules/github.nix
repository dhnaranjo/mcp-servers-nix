{
  config,
  lib,
  servers,
  mkServerModule,
  ...
}:
let
  cfg = config.programs.github;
in
{
  imports = [
    (mkServerModule {
      name = "github";
      packageName = "github-mcp-server";
    })
  ];

  config.settings.servers = lib.mkIf cfg.enable {
    github = lib.mkIf (config.flavor != "opencode") {
      args = lib.optional (cfg.package == servers.github-mcp-server) "stdio";
    };
  };
  
  # For OpenCode, add stdio to the args list instead
  config.programs.github.args = lib.mkIf (config.flavor == "opencode" && cfg.enable && cfg.package == servers.github-mcp-server) 
    (lib.mkDefault [ "stdio" ]);
}
