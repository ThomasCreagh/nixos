{ config, pkgs, inputs, ... }:

{
  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    wbg
    brightnessctl
    swaylock
    swayidle

    # install fonts
    (stdenv.mkDerivation {
      name = "custom-fonts";
      src = ../../fonts;
      installPhase = ''
        mkdir -p $out/share/fonts/truetype
        cp $src/*.ttf $out/share/fonts/truetype/
      '';
    })

    # fuck command
    (writeShellScriptBin "fuck" ''
      shutdown now
    '')

    # update command
    (writeShellScriptBin "update" ''
      if [ $# -lt 1 ]; then
        echo "Usage: rebuild <hostname>"
        exit 1
      fi

      HOST="$1"
      bash ~/.dotfiles/update $HOST
    '')

    # rebuild command
    (writeShellScriptBin "rebuild" ''
      if [ $# -lt 1 ]; then
        echo "Usage: rebuild <hostname>"
        exit 1
      fi

      HOST="$1"
      bash ~/.dotfiles/rebuild $HOST
    '')

    # clean command
    (writeShellScriptBin "clean" ''
      bash ~/.dotfiles/clean
    '')

    # Start AI services at desktop login
    (writeShellApplication {
      name = "ai";

      runtimeInputs = with pkgs; [
        openssh
        curl
        iproute2
        gnugrep
        coreutils
        uv
      ];

      text = ''
        mkdir -p "$HOME/.local/state" "$HOME/.open-webui"

        # Log startup errors
        exec >> "$HOME/.local/state/ai.log" 2>&1

        echo "Starting AI services..."

        # Wake gaming PC through h-server
        ssh -o BatchMode=yes -o ConnectTimeout=10 h-server-remote \
          'wakeonlan -i 192.168.1.32 f0:b6:1e:7f:ce:a7'

        # Start SSH tunnel unless port is already in use
        if ! ss -H -lnt 'sport = :11434' | grep -q .; then
          ssh -fNT \
            -o BatchMode=yes \
            -o ExitOnForwardFailure=yes \
            -o ServerAliveInterval=30 \
            -o ServerAliveCountMax=3 \
            -L 127.0.0.1:11434:192.168.1.32:11434 \
            h-server-remote
        fi

        # Start Open WebUI unless already running
        if ! ss -H -lnt 'sport = :8080' | grep -q .; then
          (
            cd "$HOME/.open-webui"

            nohup env \
              DATA_DIR="$HOME/.open-webui" \
              OLLAMA_BASE_URL="http://127.0.0.1:11434" \
              uvx --python 3.11 open-webui@latest serve \
                --host 127.0.0.1 --port 8080 \
              >> "$HOME/.local/state/open-webui.log" 2>&1 \
              < /dev/null &
          )
        fi

        echo "AI services launched."
      '';
    })

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
