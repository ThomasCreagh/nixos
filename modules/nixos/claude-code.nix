{ ... }:

{
  # Managed settings: highest precedence, can't be overridden by user or project settings.
  environment.etc."claude-code/managed-settings.json".text = builtins.toJSON {
    permissions.deny = [
      "Read(~/.ssh/**)"
      "Read(~/.claude/.credentials.json)"
      "Read(~/.claude.json)"
      "Read(**/.env)"
      "Read(**/.env.*)"
      "Bash(rm -rf /:*)"
      "Bash(rm -rf ~:*)"
    ];
  };
}
