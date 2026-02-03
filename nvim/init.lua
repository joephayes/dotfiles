-- Neovim config - Solarized Light, LSP for Python/JS/Clojure/Bash

vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Options
local o = vim.opt
o.number, o.relativenumber = true, true
o.tabstop, o.shiftwidth, o.expandtab = 4, 4, true
o.smartindent, o.autoindent = true, true
o.ignorecase, o.smartcase = true, true
o.hlsearch, o.incsearch = true, true
o.termguicolors, o.background = true, "light"
o.signcolumn, o.cursorline = "yes", true
o.scrolloff, o.sidescrolloff = 8, 8
o.wrap = false
o.colorcolumn = "88,120"
o.hidden, o.swapfile, o.backup = true, false, false
o.undofile = true
o.undodir = vim.fn.stdpath("data") .. "/undo"
o.updatetime, o.timeoutlen = 250, 300
o.completeopt = { "menu", "menuone", "noselect" }
o.splitright, o.splitbelow = true, true
o.mouse, o.clipboard = "a", "unnamedplus"
vim.g.loaded_netrw, vim.g.loaded_netrwPlugin = 1, 1

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable",
        "https://github.com/folke/lazy.nvim.git", lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- Plugins
require("lazy").setup({
    -- Colorscheme
    {
        "maxmx03/solarized.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require("solarized").setup({ styles = { comments = { italic = true } } })
            vim.cmd.colorscheme("solarized")
        end,
    },

    -- Status line
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            options = { theme = "solarized_light" },
            sections = { lualine_c = { { "filename", path = 1 } } },
        },
    },

    -- File explorer
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = { view = { width = 35 } },
    },

    -- Fuzzy finder
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = { "nvim-lua/plenary.nvim", { "nvim-telescope/telescope-fzf-native.nvim", build = "make" } },
        config = function()
            require("telescope").setup({ defaults = { file_ignore_patterns = { "node_modules", ".git/", "__pycache__", ".venv" } } })
            pcall(require("telescope").load_extension, "fzf")
        end,
    },

    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = { "python", "javascript", "typescript", "json", "clojure", "bash", "lua", "vim", "vimdoc", "html", "css", "yaml", "markdown", "sql" },
                highlight = { enable = true },
                indent = { enable = true },
            })
        end,
    },

    -- LSP
    {
        "neovim/nvim-lspconfig",
        dependencies = { "williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim", "hrsh7th/cmp-nvim-lsp" },
        config = function()
            require("mason").setup()
            require("mason-lspconfig").setup({
                ensure_installed = { "pyright", "ts_ls", "clojure_lsp", "bashls", "lua_ls" },
                automatic_installation = true,
            })

            local lspconfig = require("lspconfig")
            local caps = require("cmp_nvim_lsp").default_capabilities()
            local on_attach = function(_, bufnr)
                local map = function(keys, fn, desc) vim.keymap.set("n", keys, fn, { buffer = bufnr, desc = desc }) end
                map("gd", vim.lsp.buf.definition, "Definition")
                map("gr", vim.lsp.buf.references, "References")
                map("K", vim.lsp.buf.hover, "Hover")
                map("<leader>rn", vim.lsp.buf.rename, "Rename")
                map("<leader>ca", vim.lsp.buf.code_action, "Code action")
                map("[d", vim.diagnostic.goto_prev, "Prev diagnostic")
                map("]d", vim.diagnostic.goto_next, "Next diagnostic")
            end

            for _, server in ipairs({ "pyright", "ts_ls", "clojure_lsp", "bashls" }) do
                lspconfig[server].setup({ capabilities = caps, on_attach = on_attach })
            end
            lspconfig.lua_ls.setup({
                capabilities = caps, on_attach = on_attach,
                settings = { Lua = { diagnostics = { globals = { "vim" } }, workspace = { checkThirdParty = false } } },
            })
        end,
    },

    -- Completion
    {
        "hrsh7th/nvim-cmp",
        dependencies = { "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer", "hrsh7th/cmp-path", "L3MON4D3/LuaSnip", "saadparwaiz1/cmp_luasnip" },
        config = function()
            local cmp, luasnip = require("cmp"), require("luasnip")
            cmp.setup({
                snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
                mapping = cmp.mapping.preset.insert({
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
                        else fallback() end
                    end, { "i", "s" }),
                }),
                sources = cmp.config.sources({ { name = "nvim_lsp" }, { name = "luasnip" }, { name = "buffer" }, { name = "path" } }),
            })
        end,
    },

    -- Git signs
    { "lewis6991/gitsigns.nvim", opts = {} },

    -- Editing helpers
    { "windwp/nvim-autopairs", event = "InsertEnter", opts = {} },
    { "numToStr/Comment.nvim", opts = {} },
    { "kylechui/nvim-surround", event = "VeryLazy", opts = {} },

    -- Clojure REPL
    { "Olical/conjure", ft = { "clojure" } },

    -- Tmux integration
    { "christoomey/vim-tmux-navigator", lazy = false },

    -- Terminal
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        opts = {
            open_mapping = [[<C-\>]],
            direction = "float",
            float_opts = { border = "curved", width = function() return math.floor(vim.o.columns * 0.85) end, height = function() return math.floor(vim.o.lines * 0.85) end },
        },
    },
}, { checker = { enabled = false }, change_detection = { notify = false } })

-- Keymaps
local map = vim.keymap.set
map("n", "<Esc>", ":noh<CR>", { silent = true })
map("n", "<leader>w", ":w<CR>")
map("n", "<leader>q", ":q<CR>")
map("n", "<leader>e", ":NvimTreeToggle<CR>")
map("n", "<leader>ff", ":Telescope find_files<CR>")
map("n", "<leader>fg", ":Telescope live_grep<CR>")
map("n", "<leader>fb", ":Telescope buffers<CR>")
map("n", "<leader>fr", ":Telescope oldfiles<CR>")
map("n", "<S-l>", ":bnext<CR>", { silent = true })
map("n", "<S-h>", ":bprevious<CR>", { silent = true })
map("n", "<leader>bd", ":bdelete<CR>")
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")
map({ "n", "v" }, "<leader>y", '"+y')
map("t", "<Esc><Esc>", "<C-\\><C-n>")

-- Filetype settings
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "javascript", "typescript", "json", "yaml", "html", "css", "clojure" },
    callback = function() vim.opt_local.tabstop, vim.opt_local.shiftwidth = 2, 2 end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function() vim.highlight.on_yank({ timeout = 150 }) end,
})

-- Clipboard (OSC 52 for SSH, native otherwise)
local function is_ssh() return os.getenv("SSH_TTY") ~= nil end
if is_ssh() and vim.fn.has("nvim-0.10") == 1 then
    vim.g.clipboard = {
        name = "OSC 52",
        copy = { ["+"] = require("vim.ui.clipboard.osc52").copy("+"), ["*"] = require("vim.ui.clipboard.osc52").copy("*") },
        paste = { ["+"] = function() return vim.split(vim.fn.getreg('"'), "\n") end, ["*"] = function() return vim.split(vim.fn.getreg('"'), "\n") end },
    }
end
