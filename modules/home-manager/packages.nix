{ config, pkgs, inputs, ... }:

{
  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    wbg
    brightnessctl
    swaylock
    swayidle

    # rebuild command
    (writeShellScriptBin "rebuild" ''
      if [ $# -lt 1 ]; then
        echo "Usage: rebuild <hostname>"
        exit 1
      fi

      HOST="$1"
      bash ~/.dotfiles/rebuild $HOST
    '')

    # run local ai
    (writeShellScriptBin "ai" ''
      echo "ai starting..."
      (ollama serve >> /dev/null 2>&1)&
      (DATA_DIR=~/.open-webui uvx --python 3.11 open-webui@latest serve >> /dev/null 2>&1)&
      echo "ai started."
    '')

    # save system to github
    (writeShellScriptBin "save" ''
      bash ~/.dotfiles/save
    '')

    # trash
    (writeShellScriptBin "trash" ''
      if [ $# -lt 1 ]; then
        echo "Usage: trash <file or dir>"
        exit 1
      fi
      TIMESTAMP=$(date +%Y%m%d_%H%M%S)
      for f in "$@"; do
        BASENAME=$(basename "$f")
        mv "$f" ~/.trash/"''${BASENAME}_''${TIMESTAMP}"
      done
    '')

    # save an shutdown/reboot commands
    (writeShellScriptBin "shutsave" ''
      bash ~/.dotfiles/save
      echo "shutting down now."
      shutdown now
    '')

    (writeShellScriptBin "rebsave" ''
      bash ~/.dotfiles/save
      echo "rebooting now."
      sudo reboot 0
    '')
  ];

}
