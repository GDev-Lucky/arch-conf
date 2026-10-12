---@diagnostic disable undefined-global
local g = vim.g
local opt = vim.opt
local setkey = vim.keymap.set
local pack = vim.pack
local diagnostic = vim.diagnostic

--// CONFIGS //--
local theme = "onedark"
local themeconfig = { style = "deep", transparent = false, term_colors = true }

local servers = {
    "bashls", -- AUTO-LSP pkg:bash-language-server
    "lua_ls", -- AUTO-LSP pkg:lua-language-server
	--AUTO-LSP		
}

--/ GLOBALS /--
g.mapleader = " "
g.loaded_perl_provider = 0
g.loaded_python3_provider = 0
g.loaded_ruby_provider = 0
g.loaded_node_provider = 0

--/ OPTIONS /--
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true

opt.ignorecase = true
opt.smartcase = true

opt.number = true
opt.scrolloff = 6

opt.termguicolors = true

--// INSTALL PLUGINS //--
pack.add({
	{ src = "https://github.com/navarasu/onedark.nvim" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/saghen/blink.lib" },
	{ src = "https://github.com/saghen/blink.cmp" },
	{ src = "https://github.com/ibhagwan/fzf-lua" },
},
{
    confirm = false
})

--// CMP //--
local cmp = require "blink.cmp"

if cmp.library_available() then
    cmp.setup {
    	keymap = { preset = 'default' },
    	completion = { documentation = { auto_show = false }},
    	sources = { default = { 'lsp', 'path', 'snippets', 'buffer', 'omni', 'cmdline' }},
    	fuzzy = { implementation = "rust" },
    }
end

diagnostic.config {
    virtual_text = true,
    signs = true,
    underline = true
}

--// LSP //--
local lsp = vim.lsp
lsp.config("*", { capabilities = cmp.get_lsp_capabilities() })

for _, server in ipairs(servers) do
    lsp.enable(server)
end


--// FZF //--
local fzf = require "fzf-lua"
fzf.setup {
	"max-perf"
}


--// KEYBINS //--
setkey("n", "<leader>w", "<cmd>write<cr>", { desc = "write to file:" })
setkey("n", "<leader>q", "<cmd>quit<cr>", { desc = "write to file:" })
setkey({ "n", "v" }, "<leader>y", '"+y', { desc = "Copy to clipboard" })
setkey({ "n", "v" }, "<leader>p", '"+p', { desc = "Paste from clipboard" })
setkey("n", "<leader>Y", '"+yy', { desc = "Copy line to clipboard" })

setkey("n", "<leader>f", fzf.files, { desc = "fuzzy find files" })
setkey("n", "<leader>g", fzf.live_grep, { desc = "seach text across files" })
setkey("n", "<leader>b", fzf.buffers, { desc = "fuzzy find buffers" })
setkey("n", "<leader>r", fzf.resume, { desc = "resume last fuzzy find" })
setkey("n", "<leader>G", fzf.global, { desc = "buffer + file + symbol search" })
setkey("n", "<leader>l", fzf.lines, { desc = "seach lines in all open buffer" })
setkey("n", "<leader>s", fzf.lsp_document_symbols, { desc = "symbol search in current buffer" })
setkey("n", "<leader>S", fzf.lsp_workspace_symbols, { desc = "symbol search in current workspace" })
setkey("n", "<leader>K", fzf.diagnostics_workspace, { desc = "find all diagnostics in the current workspace" })
setkey("n", "<leader>d", fzf.lsp_references, { desc = "fuzzy find lsp_references" })
-- setkey("n", "<leader>e", fzf.new_file, { desc = "Create/open file in directory" })

setkey("n", "gd", lsp.buf.definition, { desc = "go to definition" })
setkey("n", "gD", lsp.buf.declaration, { desc = "go to declaration" })
setkey("n", "K", lsp.buf.hover, { desc = "hover symbol" })
setkey("n", "<leader>R", lsp.buf.rename, { desc = "rename" })
setkey("n", "<leader>F", lsp.buf.format, { desc = "rename" })
setkey("n", "<leader>a", lsp.buf.code_action, { desc = "hover symbol" })

--// LOAD THEME //--
theme = require(theme)
theme.setup(themeconfig)
theme.load()

