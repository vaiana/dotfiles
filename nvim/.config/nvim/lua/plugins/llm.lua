return {
    'huggingface/llm.nvim',
    -- 💡 The configuration from llm.setup() goes directly into `opts = {}`
    opts = {
      api_token = nil, -- You should replace 'nil' with your actual Hugging Face API token
      model = "starcoder:3b",
      backend = "ollama",
      url = "http://localhost:11434",
      tokens_to_clear = { "<|endoftext|>" },
      request_body = {
        parameters = {
          temperature = 0.2,
          top_p = 0.95,
        },
      },
      fim = {
        enabled = true,
        prefix = "<fim_prefix>",
        middle = "<fim_middle>",
        suffix = "<fim_suffix>",
      },
      debounce_ms = 150,
      accept_keymap = "<Tab>",
      dismiss_keymap = "<S-Tab>",
      tls_skip_verify_insecure = false,
      lsp = {
        bin_path = nil,
        host = nil,
        port = nil,
        cmd_env = nil,
        version = "0.5.3",
      },
      tokenizer = nil,
      context_window = 1024,
      enable_suggestions_on_startup = true,
      enable_suggestions_on_files = "*",
      disable_url_path_completion = false,
    },
  }
