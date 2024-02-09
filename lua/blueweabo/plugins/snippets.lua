return {
    "L3MON4D3/LuaSnip",
    dependencies = {
        "saadparwaiz1/cmp_luasnip",
        "rafamadriz/friendly-snippets",
    },
    build = "make install_jsregexp",
    config = function()
        local ls = require("luasnip")
        vim.keymap.set({ "i" }, "<C-K>", function() ls.expand() end, { silent = true })
        vim.keymap.set({ "i", "s" }, "<leader>;", function() ls.jump(1) end, { silent = true })
        vim.keymap.set({ "i", "s" }, "<leader>,", function() ls.jump(-1) end, { silent = true })
        vim.keymap.set({ "i", "s" }, "<C-E>", function()
            if ls.choice_active() then
                ls.change_choice(1)
            end
        end, { silent = true })
        require("luasnip.loaders.from_lua").lazy_load()
    end
}
