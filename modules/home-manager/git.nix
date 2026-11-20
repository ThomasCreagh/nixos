{ ... }:

{
  programs.git = {
    enable = true;
    ignores = [
      "**/.claude/"
      "**/.claude/.cc-writes/"
      "**/.claude/settings.local.json"
      "**/CLAUDE.local.md"
      "**/.mcp.json"
      "**/.env"
      "**/.env.*"
      "**/*.env"
      "!**/*.example"
    ];
    settings.user = {
      name = "Thomas Creagh";
      email = "github@thomascreagh.com";
    };
  };
}
