{ ... }:

{
  programs.git = {
    enable = true;
    ignores = [
      "/.claude/"
      "/.mcp.json"
      "**/.claude/.cc-writes/"
    ];
    settings.user = {
      name = "Thomas Creagh";
      email = "github@thomascreagh.com";
    };
  };
}
