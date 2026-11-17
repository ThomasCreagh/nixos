{ config, lib, ... }:

{
  programs.claude-code = {
    enable = true;
    # Installed system-wide in modules/nixos/packages.nix (needs allowUnfree).
    package = null;

    context = ../../extra-config/claude/CLAUDE.md;
  };

  # Copied rather than symlinked so Claude Code can still write to it.
  home.activation.claudeSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run install -Dm644 ${../../extra-config/claude/settings.json} ${config.home.homeDirectory}/.claude/settings.json
  '';
}
