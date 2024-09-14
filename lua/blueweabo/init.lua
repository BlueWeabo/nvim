require('blueweabo.set')
require('blueweabo.remap')
require('blueweabo.lazy')

local augroup = vim.api.nvim_create_augroup
local BlueWeaboGroup = augroup("BlueWeabo", {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup("HighLightYank", {})

ColorMyPencils("tokyonight")

function R(name)
    require("plenary.reload").reload_module(name)
end

function Dap()
    vim.keymap.set("n", "<leader>SI", function() require("dap").step_into() end)
    vim.keymap.set("n", "<leader>SO", function() require("dap").step_over() end)
    vim.keymap.set("n", "<leader>BR", function() require("dap").toggle_breakpoint() end)
end

require("dap").configurations.java = {
    {
        type = 'java';
        request = 'attach';
        name = "Debug (Attach) - Remote";
        hostName = "127.0.0.1";
        port = 5005;
    },
}

vim.filetype.add({
    extensiob = {
        templ = "templ",
    }
})

autocmd("TextYankPost", {
    group = yank_group,
    pattern = "*",
    callback = function()
        vim.highlight.on_yank({
            higroup = "IncSearch",
            timeout = 40,
        })
    end,
})

autocmd({ "BufWritePre" }, {
    group = BlueWeaboGroup,
    pattern = "*",
    command = [[%s/\s\+$//e]],
})

autocmd("LspAttach", {
    group = BlueWeaboGroup,
    callback = function(e)
        local opts = { buffer = e.buf }
        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
        vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
        vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
        vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
        vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
        vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
        vim.keymap.set("n", "<leader>vri", function() vim.lsp.buf.implementation() end, opts)
        vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
    end
})

autocmd({ "FileType" }, {
    group = BlueWeaboGroup,
    pattern = "java",
    callback = function()
        local config = {
            cmd = { vim.fn.stdpath("data") .. "/mason/bin/jdtls" },
            settings = {
                java = {
                    signature_help = {enabled = true},
                    implementationsCodeLens =  {enabled = true},
                    referenceCodeLens = {enabled = true},
                    sources = {
                        organizeImports = {
                            starThreshold = 9999,
                            staticStarThreshold = 9999,
                        }
                    },
                    configuration = {
                        runtimes = {
                            {
                                name = "JavaSE-1.8",
                                path = "/lib/jvm/jre-1.8.0-openjdk",
                            },
                            {
                                name = "JavaSE-17",
                                path = "/lib/jvm/jre-17-openjdk",
                                default = true,
                            },
                            {
                                name = "JavaSE-22",
                                path = "/lib/jvm/jre-22-openjdk",
                            },
                        }
                    }
                },
            },
            root_dir = vim.fs.dirname(vim.fs.find({ "gradlew", ".git", "mvnw" }, { upward = true })[1]),
            init_options = {
                bundles = {
                    vim.fn.glob("/home/blueweabo/Projects/Personal/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar", 1)
                }
            }
        }
        require("jdtls").start_or_attach(config)
    end
})

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
