-- ============================================================================
-- FILE: writing-tools.lua
-- PURPOSE: Technical writing enhancements for markdown and text files
-- Features: spell check, word count, reading time, grammar hints
-- ============================================================================

local M = {}

function M.setup()
    -- ========================================================================
    -- SPELL CHECKING
    -- ========================================================================
    -- Enable spell checking for writing-focused filetypes
    vim.api.nvim_create_autocmd("FileType", {
        pattern = { "markdown", "text", "gitcommit" },
        callback = function()
            vim.opt_local.spell = true
            vim.opt_local.spelllang = "en_us"

            -- Keymaps for spell checking (using 'z' prefix - vim native)
            -- Note: <leader>s is taken by REPL plugin (iron.nvim)
            local opts = { buffer = true, silent = true }

            -- Toggle spell check
            vim.keymap.set("n", "<leader>z", ":set spell!<CR>",
                { buffer = true, desc = "Toggle spell check" })

            -- Navigation (vim defaults work, but adding explicit mappings)
            vim.keymap.set("n", "]s", "]s", { buffer = true, desc = "Next misspelled word" })
            vim.keymap.set("n", "[s", "[s", { buffer = true, desc = "Previous misspelled word" })

            -- Dictionary management
            vim.keymap.set("n", "zg", "zg", { buffer = true, desc = "Add word to dictionary (good)" })
            vim.keymap.set("n", "zw", "zw", { buffer = true, desc = "Mark word as wrong" })
            vim.keymap.set("n", "zug", "zug", { buffer = true, desc = "Remove word from dictionary" })

            -- Suggestions
            vim.keymap.set("n", "z=", "z=", { buffer = true, desc = "Spelling suggestions" })
        end,
    })

    -- ========================================================================
    -- WORD COUNT & READING TIME
    -- ========================================================================
    -- Create user command to show document statistics
    vim.api.nvim_create_user_command('WordCount', function()
        local line_count = vim.api.nvim_buf_line_count(0)
        local word_count = vim.fn.wordcount()

        local msg = string.format(
            [[Document Statistics:

Lines:          %d
Words:          %d
Characters:     %d
Reading Time:   ~%d min (250 wpm)

Visual Selection Stats:
Words:          %d
Characters:     %d]],
            line_count,
            word_count.words,
            word_count.chars,
            math.ceil(word_count.words / 250),
            word_count.visual_words or 0,
            word_count.visual_chars or 0
        )

        vim.notify(msg, vim.log.levels.INFO)
    end, { desc = 'Show word count and reading time' })

    -- Quick word count in statusline
    _G.wordcount_statusline = function()
        if vim.bo.filetype == "markdown" or vim.bo.filetype == "text" then
            local wc = vim.fn.wordcount()
            return string.format("W:%d", wc.words)
        end
        return ""
    end

    -- ========================================================================
    -- WRITING MODE (Distraction-free)
    -- ========================================================================
    vim.api.nvim_create_user_command('WritingMode', function()
        -- Toggle writing mode
        if vim.g.writing_mode then
            -- Disable writing mode
            vim.opt.number = true
            vim.opt.relativenumber = true
            vim.opt.signcolumn = "yes"
            vim.opt.colorcolumn = "80"
            vim.g.writing_mode = false
            vim.notify("Writing mode disabled", vim.log.levels.INFO)
        else
            -- Enable writing mode
            vim.opt.number = false
            vim.opt.relativenumber = false
            vim.opt.signcolumn = "no"
            vim.opt.colorcolumn = ""
            vim.g.writing_mode = true
            vim.notify("Writing mode enabled - distraction-free!", vim.log.levels.INFO)
        end
    end, { desc = 'Toggle distraction-free writing mode' })

    -- ========================================================================
    -- TEXT OBJECT FOR SENTENCES (for better navigation)
    -- ========================================================================
    -- Navigate by sentences easily in markdown
    vim.keymap.set({"o", "x"}, "as", ":<C-U>normal! v)o<CR>",
        { desc = "Around sentence" })
    vim.keymap.set({"o", "x"}, "is", ":<C-U>normal! v(o<CR>",
        { desc = "Inside sentence" })

    -- ========================================================================
    -- PASTE AND FORMAT (remove extra whitespace/newlines)
    -- ========================================================================
    vim.api.nvim_create_user_command('CleanPaste', function()
        -- Get clipboard content
        local lines = vim.fn.getreg('+')

        -- Remove extra whitespace and normalize line breaks
        lines = lines:gsub("\r\n", "\n")  -- Windows line endings
        lines = lines:gsub("\r", "\n")    -- Old Mac line endings
        lines = lines:gsub("\n\n\n+", "\n\n")  -- Triple+ newlines → double
        lines = lines:gsub("^%s+", "")    -- Leading whitespace
        lines = lines:gsub("%s+$", "")    -- Trailing whitespace

        -- Paste at cursor
        vim.api.nvim_put(vim.split(lines, "\n"), "l", true, true)

        vim.notify("Pasted and cleaned text", vim.log.levels.INFO)
    end, { desc = 'Paste clipboard with whitespace cleanup' })

    -- ========================================================================
    -- DUPLICATE LINE/PARAGRAPH (useful for templates)
    -- ========================================================================
    vim.keymap.set("n", "<leader>dd", "yyp", { desc = "Duplicate line" })
    vim.keymap.set("v", "<leader>dd", "y`]p", { desc = "Duplicate selection" })

    -- ========================================================================
    -- READING RULER (highlight current line/paragraph for focus)
    -- ========================================================================
    vim.api.nvim_create_user_command('ReadingRuler', function()
        if vim.wo.cursorline then
            vim.wo.cursorline = false
            vim.notify("Reading ruler disabled", vim.log.levels.INFO)
        else
            vim.wo.cursorline = true
            vim.notify("Reading ruler enabled", vim.log.levels.INFO)
        end
    end, { desc = 'Toggle reading ruler (highlight current line)' })
end

-- ============================================================================
-- OPTIONAL: Grammar/Style Checking with LanguageTool
-- ============================================================================
-- If you want grammar checking, install LanguageTool:
-- - Download: https://languagetool.org/download/
-- - Then add this plugin to lazy-plugins.lua:
--
--   {
--       'rhysd/vim-grammarous',
--       ft = { 'markdown', 'text' },
--       cmd = { 'GrammarousCheck' },
--   }
--
-- Or use ltex-ls LSP server (install via Mason):
-- - :Mason → search "ltex" → install
-- - Provides grammar/spell checking through LSP
-- ============================================================================

return M
