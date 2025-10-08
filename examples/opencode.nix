{
  pkgs ? import <nixpkgs> { },
}:
let
  mcp-servers = import ../. { inherit pkgs; };
in
mcp-servers.lib.mkConfig pkgs {
  format = "json";
  flavor = "opencode";
  fileName = "opencode.json";

  programs = {
    # Local server with args
    filesystem = {
      enable = true;
      args = [ "/path/to/allowed/directory" ];
    };

    # Local server with environment variables
    github = {
      enable = true;
      env = {
        GITHUB_PERSONAL_ACCESS_TOKEN = "dummy-token";
      };
    };

    # Example of remote server (commented out as it needs a real URL)
    # remote-example = {
    #   enable = true;
    #   type = "sse";
    #   url = "https://example.com/mcp";
    # };
  };
}
