-- Neovim config - Solarized Light
-- LSP: Python (pyright), Node.js/JS/TS (ts_ls), Clojure (clojure_lsp), SQL (sqls), Bash, Go (gopls)
-- Requires nvim 0.11+

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
o.autoread = true
o.undofile = true
o.undodir = vim.fn.stdpath("data") .. "/undo"
o.updatetime, o.timeoutlen = 250, 300
o.completeopt = { "menu", "menuone", "noselect" }
o.splitright, o.splitbelow = true, true
o.mouse, o.clipboard = "a", "unnamedplus"
vim.g.loaded_netrw, vim.g.loaded_netrwPlugin = 1, 1

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
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

    -- Treesitter (syntax highlighting) - just for installing parsers
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        opts = {
            ensure_installed = { "python", "javascript", "typescript", "json", "clojure", "bash", "lua", "vim", "vimdoc", "html", "css", "yaml", "markdown", "sql", "go" },
        },
        config = function()
            vim.treesitter.language.register("bash", "sh")
        end,
    },

    -- Mason (LSP/tool installer)
    { "williamboman/mason.nvim", opts = {} },
    {
        "williamboman/mason-lspconfig.nvim",
        opts = {
            ensure_installed = { "pyright", "ruff", "ts_ls", "clojure_lsp", "bashls", "sqls", "lua_ls", "gopls" },
        },
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
                sources = cmp.config.sources({ { name = "copilot" }, { name = "nvim_lsp" }, { name = "luasnip" }, { name = "buffer" }, { name = "path" } }),
            })
        end,
    },

    -- Git
    { "lewis6991/gitsigns.nvim", opts = {} },
    {
        "NeogitOrg/neogit",
        dependencies = { "sindrets/diffview.nvim" },
        opts = {},
    },

    -- Key discovery
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        config = function()
            require("which-key").add({
                { "<leader>f", group = "find" },
                { "<leader>b", group = "buffer" },
                { "<leader>l", group = "lsp" },
                { "<leader>c", group = "claude" },
                { "<leader>r", group = "refactor" },
                { "<leader>g", group = "git" },
                { "<leader>o", group = "go" },
                { "<leader>t", group = "test" },
                { "<leader>d", group = "debug" },
            })
        end,
    },

    -- Editing helpers
    { "windwp/nvim-autopairs", event = "InsertEnter", opts = {} },
    { "numToStr/Comment.nvim", opts = {} },
    { "kylechui/nvim-surround", event = "VeryLazy", opts = {} },

    -- AI Code Completion (via nvim-cmp only — inline suggestions disabled)
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        config = function()
            require("copilot").setup({
                suggestion = { enabled = false },
                panel = { enabled = false },
                filetypes = {
                    yaml = false,
                    markdown = false,
                    help = false,
                    gitcommit = false,
                    gitrebase = false,
                    ["."] = false,
                },
            })
        end,
    },

    -- Copilot integration with nvim-cmp
    {
        "zbirenbaum/copilot-cmp",
        dependencies = { "copilot.lua" },
        config = function()
            require("copilot_cmp").setup()
        end,
    },

    -- Clojure REPL
    { "Olical/conjure", ft = { "clojure" } },

    -- Tmux integration
    { "christoomey/vim-tmux-navigator", lazy = false },

    -- Terminal
    {
        "akinsho/toggleterm.nvim",
        lazy = false,
        opts = {
            open_mapping = [[<C-\>]],
            direction = "float",
            float_opts = { border = "curved", width = function() return math.floor(vim.o.columns * 0.85) end, height = function() return math.floor(vim.o.lines * 0.85) end },
        },
    },

    -- Comprehensive Go support
    {
        "ray-x/go.nvim",
        dependencies = {
            "ray-x/guihua.lua",
            "neovim/nvim-lspconfig",
            "nvim-treesitter/nvim-treesitter",
        },
        event = {"CmdlineEnter"},
        ft = {"go", 'gomod'},
        build = ':lua require("go.install").update_all_sync()',
        config = function()
            require("go").setup({
                -- Disable LSP (use your existing gopls config)
                lsp_cfg = false,
                lsp_gofumpt = true,
                lsp_on_attach = false,

                -- Test settings
                test_runner = "go",
                test_template = "",
                test_template_dir = "",

                -- DAP settings
                dap_debug = true,
                dap_debug_gui = true,
                dap_debug_keymap = true,

                -- Other features
                trouble = false, -- disable trouble integration for now
                luasnip = true,
            })
        end,
    },

    -- Testing framework
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-treesitter/nvim-treesitter",
            "nvim-neotest/neotest-go",
        },
        keys = { "<leader>tn", "<leader>tf", "<leader>td", "<leader>tl" },
        ft = { "go" },
        config = function()
            require("neotest").setup({
                adapters = {
                    require("neotest-go")({
                        experimental = {
                            test_table = true,
                        },
                        args = { "-count=1", "-timeout=60s", "-race" }
                    })
                }
            })
        end,
    },

    -- Debug Adapter Protocol for Go
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "nvim-neotest/nvim-nio",
            "theHamsta/nvim-dap-virtual-text",
            "leoluz/nvim-dap-go",
        },
        keys = { "<F5>", "<F10>", "<F11>", "<F12>", "<leader>db" },
        ft = { "go" },
        config = function()
            require("dap-go").setup({
                delve = {
                    path = "dlv",
                    initialize_timeout_sec = 20,
                    port = "${port}",
                    build_flags = {},
                    detached = vim.fn.has("win32") == 0,
                },
                tests = {
                    verbose = false,
                },
            })

            require("dapui").setup()
            require("nvim-dap-virtual-text").setup()

            local dap, dapui = require("dap"), require("dapui")
            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end
        end,
    },
}, { checker = { enabled = false }, change_detection = { notify = false } })

-- LSP Setup (native nvim 0.11+ API)
local caps = vim.lsp.protocol.make_client_capabilities()
local cmp_caps = pcall(require, "cmp_nvim_lsp") and require("cmp_nvim_lsp").default_capabilities() or {}
caps = vim.tbl_deep_extend("force", caps, cmp_caps)

-- LSP keymaps on attach
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local map = function(keys, fn, desc)
            vim.keymap.set("n", keys, fn, { buffer = args.buf, desc = desc })
        end
        map("gd", vim.lsp.buf.definition, "Definition")
        map("gr", vim.lsp.buf.references, "References")
        map("K", vim.lsp.buf.hover, "Hover")
        map("<leader>rn", vim.lsp.buf.rename, "Rename")
        map("<leader>la", vim.lsp.buf.code_action, "Code action")
        map("[d", vim.diagnostic.goto_prev, "Prev diagnostic")
        map("]d", vim.diagnostic.goto_next, "Next diagnostic")
    end,
})

-- Configure LSP servers using native vim.lsp.config (nvim 0.11+)
if vim.lsp.config then
    vim.lsp.config("pyright", { capabilities = caps })
    vim.lsp.config("ruff", { capabilities = caps })
    vim.lsp.config("ts_ls", { capabilities = caps })
    vim.lsp.config("clojure_lsp", { capabilities = caps })
    vim.lsp.config("bashls", { capabilities = caps })
    vim.lsp.config("sqls", { capabilities = caps })
    vim.lsp.config("lua_ls", {
        capabilities = caps,
        settings = { Lua = { diagnostics = { globals = { "vim" } }, workspace = { checkThirdParty = false } } },
    })
    vim.lsp.config("gopls", {
        capabilities = caps,
        settings = {
            gopls = {
                -- Import management
                gofumpt = true,

                -- Code lenses (enables clickable actions)
                codelenses = {
                    generate = true,
                    regenerate_cgo = true,
                    run_govulncheck = true,
                    tidy = true,
                    upgrade_dependency = true,
                    vendor = true,
                },

                -- Enhanced analysis
                staticcheck = true,
                vulncheck = "Imports",
                analysisProgressReporting = true,

                -- Completion enhancements
                completeFunctionCalls = true,
                usePlaceholders = true,
                experimentalPostfixCompletions = true,

                -- Documentation
                hoverKind = "FullDocumentation",
                linkTarget = "pkg.go.dev",
                linksInHover = true,

                -- Performance
                directoryFilters = {"-**/node_modules", "-**/vendor"},

                -- Experimental features
                semanticTokens = true,
                hints = {
                    assignVariableTypes = true,
                    compositeLiteralFields = true,
                    compositeLiteralTypes = true,
                    constantValues = true,
                    functionTypeParameters = true,
                    parameterNames = true,
                    rangeVariableTypes = true,
                },
            },
        },
    })
    vim.lsp.enable({ "pyright", "ruff", "ts_ls", "clojure_lsp", "bashls", "sqls", "lua_ls", "gopls" })
end

-- Keymaps
local map = vim.keymap.set
map("n", "<Esc>", ":noh<CR>", { silent = true })
map("n", "<leader>w", ":w<CR>", { desc = "Save" })
map("n", "<leader>q", ":q<CR>", { desc = "Quit" })
map("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "File tree" })
map("n", "<leader>g", ":Neogit<CR>", { desc = "Neogit" })
-- Claude Code (tmux split — navigate back with C-h)
map("n", "<leader>cc", function()
    local cwd = vim.fn.getcwd()
    vim.fn.system("pane=$(tmux list-panes -F '#{pane_id} #{pane_current_command}' | awk '/claude/{print $1; exit}'); if [ -n \"$pane\" ]; then tmux select-pane -t \"$pane\"; else tmux split-window -h -l 90 -c '" .. cwd .. "' 'bash -li -c claude'; fi")
end, { desc = "Claude Code" })
map("n", "<leader>cx", function()
    local file = vim.fn.expand('%:p')
    local cwd = vim.fn.getcwd()
    vim.fn.system(string.format("tmux split-window -h -l 90 -c '%s' 'bash -li -c \"claude \\\"@%s\\\"\"'", cwd, file))
end, { desc = "Claude with file" })
map("v", "<leader>cs", function()
    local lines = vim.fn.getline(vim.fn.line("'<"), vim.fn.line("'>"))
    local ext = vim.fn.expand('%:e')
    local tmp = vim.fn.tempname() .. (ext ~= '' and '.' .. ext or '.txt')
    vim.fn.writefile(lines, tmp)
    local cwd = vim.fn.getcwd()
    vim.fn.system(string.format("tmux split-window -h -l 90 -c '%s' 'bash -li -c \"claude \\\"@%s\\\"\"'", cwd, tmp))
end, { desc = "Claude with selection" })
map("n", "<leader>ff", ":Telescope find_files<CR>", { desc = "Find files" })
map("n", "<leader>fg", ":Telescope live_grep<CR>", { desc = "Grep" })
map("n", "<leader>fb", ":Telescope buffers<CR>", { desc = "Buffers" })
map("n", "<leader>fr", ":Telescope oldfiles<CR>", { desc = "Recent files" })
map("n", "<S-l>", ":bnext<CR>", { silent = true })
map("n", "<S-h>", ":bprevious<CR>", { silent = true })
map("n", "<leader>bd", ":bdelete<CR>", { desc = "Delete buffer" })

map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")
map({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to clipboard" })
map("t", "<Esc><Esc>", "<C-\\><C-n>")
vim.api.nvim_create_autocmd("TermEnter", {
    callback = function() vim.cmd("startinsert!") end,
})

-- Go-specific keybindings
vim.api.nvim_create_autocmd("FileType", {
    pattern = "go",
    callback = function()
        local opts = { buffer = true, silent = true }

        -- go.nvim keybindings
        map("n", "<leader>oj", ":GoTagAdd json<CR>", vim.tbl_extend("force", opts, { desc = "Add json tags" }))
        map("n", "<leader>oy", ":GoTagAdd yaml<CR>", vim.tbl_extend("force", opts, { desc = "Add yaml tags" }))
        map("n", "<leader>od", ":GoTagRm<CR>", vim.tbl_extend("force", opts, { desc = "Remove tags" }))
        map("n", "<leader>ot", ":GoTest<CR>", vim.tbl_extend("force", opts, { desc = "Run tests" }))
        map("n", "<leader>oT", ":GoTestFunc<CR>", vim.tbl_extend("force", opts, { desc = "Test function" }))
        map("n", "<leader>oc", ":GoCoverage<CR>", vim.tbl_extend("force", opts, { desc = "Coverage" }))
        map("n", "<leader>oi", ":GoImport ", vim.tbl_extend("force", opts, { desc = "Add import" }))
        map("n", "<leader>of", ":GoFillStruct<CR>", vim.tbl_extend("force", opts, { desc = "Fill struct" }))
        map("n", "<leader>oe", ":GoIfErr<CR>", vim.tbl_extend("force", opts, { desc = "Add if err" }))

        -- Testing with neotest
        map("n", "<leader>tn", function() require("neotest").run.run() end, vim.tbl_extend("force", opts, { desc = "Run nearest test" }))
        map("n", "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, vim.tbl_extend("force", opts, { desc = "Run file tests" }))
        map("n", "<leader>td", function() require("dap-go").debug_test() end, vim.tbl_extend("force", opts, { desc = "Debug test" }))
        map("n", "<leader>tl", function() require("dap-go").debug_last_test() end, vim.tbl_extend("force", opts, { desc = "Debug last test" }))

        -- Debugging
        map("n", "<F5>", function() require("dap").continue() end, vim.tbl_extend("force", opts, { desc = "Continue" }))
        map("n", "<F10>", function() require("dap").step_over() end, vim.tbl_extend("force", opts, { desc = "Step over" }))
        map("n", "<F11>", function() require("dap").step_into() end, vim.tbl_extend("force", opts, { desc = "Step into" }))
        map("n", "<F12>", function() require("dap").step_out() end, vim.tbl_extend("force", opts, { desc = "Step out" }))
        map("n", "<leader>db", function() require("dap").toggle_breakpoint() end, vim.tbl_extend("force", opts, { desc = "Toggle breakpoint" }))
    end,
})

-- Filetype settings
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "javascript", "typescript", "json", "yaml", "html", "css", "clojure" },
    callback = function() vim.opt_local.tabstop, vim.opt_local.shiftwidth = 2, 2 end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "sh", "bash" },
    callback = function()
        vim.opt_local.tabstop = 4
        vim.opt_local.shiftwidth = 4
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "go" },
    callback = function()
        vim.opt_local.tabstop = 4
        vim.opt_local.shiftwidth = 4
        vim.opt_local.expandtab = false -- Go uses actual tabs
    end,
})

-- Format on <leader>lf
map("n", "<leader>lf", function() vim.lsp.buf.format({ async = true }) end, { desc = "Format buffer" })

vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function() vim.highlight.on_yank({ timeout = 150 }) end,
})

-- Clipboard (OSC 52 for SSH)
if os.getenv("SSH_TTY") and vim.fn.has("nvim-0.10") == 1 then
    vim.g.clipboard = {
        name = "OSC 52",
        copy = { ["+"] = require("vim.ui.clipboard.osc52").copy("+"), ["*"] = require("vim.ui.clipboard.osc52").copy("*") },
        paste = { ["+"] = function() return vim.split(vim.fn.getreg('"'), "\n") end, ["*"] = function() return vim.split(vim.fn.getreg('"'), "\n") end },
    }
end
