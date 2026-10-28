{ pkgs, ... }:

{
  programs.opencode = {
    enable = true;

    settings = {
      model = "ollama/qwen3:8b";

      provider.ollama = {
        npm = "@ai-sdk/openai-compatible";
        name = "Gaming PC RTX 3060";

        options.baseURL = "http://127.0.0.1:11434/v1";

        models."qwen3:8b" = {
          name = "Qwen3 8B";
        };
      };

      permission = {
        bash = "ask";
        edit = "ask";
        external_directory = "ask";
      };
    };
  };
}
