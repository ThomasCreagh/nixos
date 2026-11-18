{ ... }:

{
  programs.git = {
    enable = true;
    ignores = [
      "**/.claude/"
      "**/.claude/.cc-writes/"
      "**/.claude/settings.local.json"
      "**/.mcp.json"
    ];
    settings.user = {
      name = "Thomas Creagh";
      email = "github@thomascreagh.com";
    };
  };
}
