# Tests for OpenCode flavor configuration format
{ pkgs }:
let
  mcp-servers = import ../. { inherit pkgs; };
in
{
  test-opencode =
    let
      evaluated-module = mcp-servers.lib.evalModule pkgs {
        flavor = "opencode";
        programs = {
          # Local server with args and env
          filesystem = {
            enable = true;
            args = [ "/tmp" ];
            env = {
              TEST_VAR = "value";
            };
          };
          # Remote server with headers
          fetch = {
            enable = true;
            type = "sse";
            url = "https://example.com";
            headers = {
              Authorization = "Bearer token";
            };
          };
        };
      };
    in
    pkgs.runCommand "test-opencode"
      {
        nativeBuildInputs = with pkgs; [ jq ];
      }
      ''
        # Verify top-level mcp key
        jq -e '.mcp' ${evaluated-module.config.configFile} > /dev/null
        
        # Local server transformations
        test "$(jq -r '.mcp.filesystem.type' ${evaluated-module.config.configFile})" = "local"
        test "$(jq -r '.mcp.filesystem.command | type' ${evaluated-module.config.configFile})" = "array"
        test "$(jq -r '.mcp.filesystem.command | length' ${evaluated-module.config.configFile})" = "2"
        jq -e '.mcp.filesystem.environment.TEST_VAR' ${evaluated-module.config.configFile} > /dev/null
        
        # Remote server transformations
        test "$(jq -r '.mcp.fetch.type' ${evaluated-module.config.configFile})" = "remote"
        test "$(jq -r '.mcp.fetch.url' ${evaluated-module.config.configFile})" = "https://example.com"
        jq -e '.mcp.fetch.headers.Authorization' ${evaluated-module.config.configFile} > /dev/null
        test "$(jq -r '.mcp.fetch.command' ${evaluated-module.config.configFile})" = "null"
        
        touch $out
      '';
}
