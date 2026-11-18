{ config, lib, pkgs, ... }:

let
  # Piper neural TTS, without the voice-training extras (torch etc.) that the
  # package pulls in by default. HTTP is kept for the server below.
  piper = pkgs.piper-tts.override {
    withAlignment = false;
    withHTTP = true;
    withJapanese = false;
    withTrain = false;
  };
  piperPython = pkgs.python3.withPackages (ps: [ (ps.toPythonModule piper) ]);

  # Voices aren't packaged in nixpkgs; fetch one from the official repo.
  # Browse others at https://huggingface.co/rhasspy/piper-voices
  # Lower quality means less of a pause before each sentence: "low" (16 kHz)
  # is ~25-30% faster than "medium", which is 2-6x faster than "high".
  # en_GB-southern_english_female-low is faster, but sounds more muffled:
  #   .../en/en_GB/southern_english_female/low/en_GB-southern_english_female-low
  #   onnx: sha256-8vN67Rs6CTR29xnRN5ugwLGxz28e+ZKI4uv1ApcaB8M=
  #   json: sha256-oa9DMQ+HVhYVBuhJooY9NCqYsIU6+eJDdYHTnpki0OU=
  voiceName = "en_GB-cori-medium";
  voiceUrl = "https://huggingface.co/rhasspy/piper-voices/resolve/v1.0.0/en/en_GB/cori/medium/${voiceName}";
  # piper expects the .onnx.json config next to the model
  voice = pkgs.linkFarm "piper-voice-${voiceName}" {
    "${voiceName}.onnx" = pkgs.fetchurl {
      url = "${voiceUrl}.onnx";
      hash = "sha256-GJn5jl+4MQFU88KXP0uKkpunJF5yKz06hWgLgz2V8Q0=";
    };
    "${voiceName}.onnx.json" = pkgs.fetchurl {
      url = "${voiceUrl}.onnx.json";
      hash = "sha256-4mLBbX8ZL2nU7da074pZFTeeZ0lfzEAvGrFe6zPaPTY=";
    };
  };

  port = 5005;

  # Speaks the text on stdin through the piper server.
  piperSay = pkgs.writeShellApplication {
    name = "piper-say";
    runtimeInputs = with pkgs; [ coreutils jq curl alsa-utils ];
    text = ''
      # piper treats each line as a separate utterance, so join lines
      text=$(tr '\n' ' ')

      # Skip text with nothing pronounceable (e.g. "}" lines in code blocks):
      # piper produces no audio and the server returns an error instead.
      case "$text" in
        *[[:alnum:]]*) ;;
        *) exit 0 ;;
      esac

      printf '%s' "$text" \
        | jq -Rs '{text: .}' \
        | curl -sf -H 'Content-Type: application/json' --data-binary @- \
            http://127.0.0.1:${toString port}/synthesize \
        | aplay -q -
    '';
  };
in
{
  # Loading the voice takes ~2s, so keep one piper running with it loaded
  # rather than starting piper for every sentence. Localhost only: piper
  # listens on all interfaces by default.
  systemd.user.services.piper-tts = {
    description = "Piper text-to-speech server";
    wantedBy = [ "default.target" ];
    serviceConfig = {
      ExecStart = "${piperPython}/bin/python -m piper.http_server --host 127.0.0.1 --port ${toString port} -m ${voice}/${voiceName}.onnx --data-dir ${voice}";
      Restart = "on-failure";
    };
  };

  # Firefox's Narrate (and anything else using speech-dispatcher) reads
  # aloud with Piper instead of eSpeak.
  services.speechd = {
    enable = true;
    config = ''
      AddModule "piper" "sd_generic" "piper.conf"
      DefaultModule piper
      DefaultLanguage "en"
    '';
    modules.piper = ''
      GenericExecuteSynth "printf %s \'$DATA\' | ${lib.getExe piperSay}"
      AddVoice "en" "FEMALE1" "${voiceName}"
    '';
  };

  environment.systemPackages = [ piper ];
}
