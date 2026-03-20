-- Helper function to verify Ollama is up AND has the specific model downloaded
local function has_ollama_model(target_model)
	-- 1. Ping the local Ollama API tags endpoint with a strict timeout (100ms)
	local command = "curl --silent --fail --connect-timeout 0.1 http://localhost:11434/api/tags"
	local response = vim.fn.system(command)

	-- If the command failed or returned nothing, the service is likely down
	if vim.v.shell_error ~= 0 or response == "" then
		return false
	end

	-- 2. Parse the JSON response to check for the model name
	local ok, decoded = pcall(vim.json.decode, response)
	if not ok or not decoded or not decoded.models then
		return false
	end

	-- Loop through available models to find a match
	for _, model in ipairs(decoded.models) do
		if model.name == target_model then
			return true
		end
	end

	return false
end

-- Define the model once to keep the config DRY
local target_model_name = "starcoder:3b"

return {
	"huggingface/llm.nvim",
	-- This ensures the plugin only activates if the model is ready to use locally
	cond = function()
		return has_ollama_model(target_model_name)
	end,

	opts = {
		api_token = nil, -- Replace with actual token if using HF backend fallbacks
		model = target_model_name,
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
		accept_keymap = "<C-y>",
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
