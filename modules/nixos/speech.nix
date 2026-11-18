{ config, lib, pkgs, ... }:

let
  # Piper neural TTS, without the voice-training extras (torch etc.) that the
  # package pulls in by default.
  piper = pkgs.piper-tts.override {
    withAlignment = false;
    withHTTP = false;
    withJapanese = false;
    withTrain = false;
  };

  # Voices aren't packaged in nixpkgs; fetch one from the official repo.
  # Browse others at https://huggingface.co/rhasspy/piper-voices
  voiceName = "en_GB-cori-high";
  voiceUrl = "https://huggingface.co/rhasspy/piper-voices/resolve/v1.0.0/en/en_GB/cori/high/${voiceName}";
  # piper expects the .onnx.json config next to the model
  voice = pkgs.linkFarm "piper-voice-${voiceName}" {
    "${voiceName}.onnx" = pkgs.fetchurl {
      url = "${voiceUrl}.onnx";
      hash = "sha256-RwtN1jTJj4pIUNdib/w9/JB3Riju72YFpt2PiPMKWQM=";
    };
    "${voiceName}.onnx.json" = pkgs.fetchurl {
      url = "${voiceUrl}.onnx.json";
      hash = "sha256-nn+1tWcWEsIvPIHL5Gwa6HsDGkYyvLUJ5Jna1vHirew=";
    };
  };
  sampleRate = 22050; # all medium/high piper voices
in
{
  # Firefox's Narrate (and anything else using speech-dispatcher) reads
  # aloud with Piper instead of eSpeak.
  services.speechd = {
    enable = true;
    config = ''
      AddModule "piper" "sd_generic" "piper.conf"
      DefaultModule piper
      DefaultLanguage "en"
    '';
    # piper synthesises each input line separately, so join lines first.
    modules.piper = ''
      GenericExecuteSynth "printf %s \'$DATA\' | ${pkgs.coreutils}/bin/tr \'\\n\' \' \' | ${lib.getExe piper} -m ${voice}/${voiceName}.onnx --output-raw | ${pkgs.alsa-utils}/bin/aplay -q -r ${toString sampleRate} -f S16_LE -c 1 -t raw -"
      AddVoice "en" "FEMALE1" "${voiceName}"
    '';
  };

  environment.systemPackages = [ piper ];
}
