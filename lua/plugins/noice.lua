-- @file: $ONVIM/lua/plugins/noice.lua
-- @mission: Cmdline flutuante e ajuste de transparência do nvim-notify

local M = {}

function M.setup()
    vim.pack.add({
        "https://github.com/MunifTanjim/nui.nvim",
        "https://github.com/rcarriga/nvim-notify",
        "https://github.com/folke/noice.nvim",
    })

    vim.cmd("packadd nui.nvim")
    vim.cmd("packadd nvim-notify")
    vim.cmd("packadd noice.nvim")

    local notify_ok, notify = pcall(require, "notify")
    if notify_ok then
        notify.setup({
            background_colour = "#000000",
        })
    end

    local noice_ok, noice = pcall(require, "noice")
    if noice_ok then
        noice.setup({
            notify = {
                enabled = false,
            },
            messages = {
                enabled = true,
            },
            lsp = {
                progress = {
                    enabled = false,
                },
            },
            presets = {
                bottom_search = true,
                command_palette = true,
                long_message_to_split = true,
            },
        })

        vim.keymap.set("n", "<leader>nh", "<cmd>Noice history<cr>", { desc = "Ver historico de mensagens" })
    end
end

return M

-- ==============================================================================
-- @README_FILE
--
-- @IMPORTANTE_PROFILE:
-- Corrigido background_colour="#000000" para evitar erros de renderização no Notify.
-- ==============================================================================
