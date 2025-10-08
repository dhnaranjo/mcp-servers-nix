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

    # Local server with envFile
    github = {
      enable = true;
      envFile = ./dummy-gh-token;
    };

    # Local server that can be disabled
    fetch = {
      enable = true;
      enabled = false; # Disabled in OpenCode config
    };

    # Example of remote server (commented out as it needs a real URL)
    # remote-example = {
    #   enable = true;
    #   type = "sse";
    #   url = "https://example.com/mcp";
    #   headers = {
    #     Authorization = "Bearer token123";
    #   };
    # };
  };

  # Additional OpenCode-specific settings
  settings = {
    model = "anthropic/claude-sonnet-4-20250514";
    theme = "opencode";
  };
}
