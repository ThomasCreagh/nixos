{ pkgs, ... }:

{
  programs.opencode = {
    enable = true;
    settings = {
      model = "ollama/qwen3.5:9b-q4_K_M";

      provider.ollama = {
        npm = "@ai-sdk/openai-compatible";
        name = "Gaming PC RTX 3060";

        options.baseURL = "http://127.0.0.1:11434/v1";

        models."qwen3.5:9b-q4_K_M" = {
          name = "Qwen3.5 9B";
          limit = {
            context = 16384;
            output = 4096;
          };
        };
      };

      permission = {
        bash = "ask";
        edit = "ask";
        external_directory = "ask";
        task = "deny";
      };
    };
  };
}
#    settings = {
#      model = "ollama/qwen3:8b";
#
#      provider.ollama = {
#        npm = "@ai-sdk/openai-compatible";
#        name = "Gaming PC RTX 3060";
#
#        options.baseURL = "http://127.0.0.1:11434/v1";
#
#        models."qwen3:8b" = {
#          name = "Qwen3 8B";
#        };
#      };
#
#      permission = {
#        bash = "ask";
#        edit = "ask";
#        external_directory = "ask";
#      };
#    };
