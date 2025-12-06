-- ============================================================================
-- Enhanced Markdown configuration with autocompletion and snippets
-- ============================================================================
--
-- Features:
-- 1. Provides LuaSnip snippets for common markdown patterns (code blocks, links, etc.)
-- 2. Creates YAML frontmatter snippets (Obsidian/Logseq/any PKM compatible)
-- 3. Sets up markdown-specific autocompletion (including spell check)
-- 4. Adds markdown-specific keybindings for formatting
-- 5. Provides validation commands for YAML frontmatter
--
-- NOTE: This provides quick snippets and markdown utilities
-- Customize the frontmatter templates for your own knowledge base system
--
-- DEPENDENCIES:
-- - LuaSnip (snippet engine)
-- - nvim-cmp (completion)
-- - Optional: glow (terminal markdown preview)
-- - Optional: markdown-preview.nvim
--
-- ============================================================================

local M = {}

-- ============================================================================
-- SNIPPET SETUP
-- ============================================================================
-- Creates snippets for common markdown patterns and YAML frontmatter

function M.setup()
    -- Import LuaSnip
    local ls = require("luasnip")
    local s = ls.snippet
    local t = ls.text_node
    local i = ls.insert_node
    local f = ls.function_node

    -- Register all markdown snippets
    ls.add_snippets("markdown", {

        -- ====================================================================
        -- BASIC MARKDOWN SNIPPETS
        -- ====================================================================
        -- These are for quick markdown formatting

        -- Code block with syntax highlighting
        s("code", {
            t("```"),
            i(1, "language"),
            t({"", ""}),
            i(2, "code"),
            t({"", "```"}),
        }),

        -- Markdown link
        s("link", {
            t("["),
            i(1, "text"),
            t("]("),
            i(2, "url"),
            t(")"),
        }),

        -- Clipboard link (paste URL from clipboard, cursor in text)
        s("linkc", {
            t("["),
            i(1, "text"),
            t("]("),
            f(function()
                -- Get clipboard content and strip whitespace/newlines
                local clipboard = vim.fn.getreg("+")
                if clipboard and clipboard ~= "" then
                    -- Remove all whitespace and newlines
                    local cleaned = string.gsub(clipboard, "%s+", "")
                    return cleaned
                end
                return "url"
            end, {}),
            t(")"),
        }),

        -- Image embed
        s("img", {
            t("!["),
            i(1, "alt text"),
            t("]("),
            i(2, "image url"),
            t(")"),
        }),

        -- Bold text
        s("bold", {
            t("**"),
            i(1, "text"),
            t("**"),
        }),

        -- Italic text
        s("italic", {
            t("*"),
            i(1, "text"),
            t("*"),
        }),

        -- Headers (h1-h3)
        s("h1", {
            t("# "),
            i(1, "Title"),
        }),
        s("h2", {
            t("## "),
            i(1, "Section"),
        }),
        s("h3", {
            t("### "),
            i(1, "Subsection"),
        }),

        -- Task checkbox
        s("task", {
            t("- [ ] "),
            i(1, "Task"),
        }),

        -- Markdown table
        s("table", {
            t({"| Column 1 | Column 2 | Column 3 |",
               "|----------|----------|----------|",
               "| "}),
            i(1, "data"),
            t(" | "),
            i(2, "data"),
            t(" | "),
            i(3, "data"),
            t(" |"),
        }),

        -- ====================================================================
        -- UNIVERSAL FRONTMATTER SNIPPET
        -- ====================================================================
        -- Trigger: Type "yaml-universal" and press Tab
        -- Creates comprehensive YAML frontmatter for knowledge base documents
        -- Compatible with Obsidian, Logseq, and other PKM tools with DataView
        --
        -- COVERS: Documents, Tasks, Projects, Operations, Research, etc.
        -- SPECIALIZED: Use "yaml-command" for command documentation
        --
        -- CRITICAL: Notice NO COMMAS after closing quotes!
        -- YAML uses newlines to separate fields, NOT commas
        -- ====================================================================
        s("yaml-universal", {
            t({"---",
               "document_uuid: \""}),
            -- Generate UUID v4
            f(function()
                math.randomseed(os.time() + os.clock() * 1000000)
                local template = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
                return template:gsub('[xy]', function(c)
                    local v = (c == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
                    return string.format('%x', v)
                end)
            end),
            t({"\"",           -- NO COMMA HERE!
               "id: \""}),
            f(function() return os.date("%Y") end),
            t("-"),
            i(1, "DOC"),       -- Type: DOC, TSK, PRJ, OPS, RUN, etc.
            t("-"),
            i(2, "001"),       -- Sequential number
            t({"\"",           -- NO COMMA!
               "title: \""}),
            i(3, "Document Title"),
            t({"\"",           -- NO COMMA!
               "description: \""}),
            i(4, "Brief description of purpose"),
            t({"\"",           -- NO COMMA!
               "category: \""}),
            i(5, "documentation"),  -- documentation, operational, project, personal, learning
            t({"\"",           -- NO COMMA!
               "subcategory: \""}),
            i(6, "general"),   -- More specific categorization
            t({"\"",           -- NO COMMA!
               "type: \""}),
            i(7, "document"),  -- document, task, project, command, runbook, etc.
            t({"\"",           -- NO COMMA!
               "status: \""}),
            i(8, "active"),    -- active, planning, in-progress, completed, on-hold, blocked
            t({"\"",           -- NO COMMA!
               "priority: \""}),
            i(9, "P2-Medium"), -- P0-Critical, P1-High, P2-Medium, P3-Low
            t({"\"",           -- NO COMMA!
               "version: \"1.0.0\"",    -- NO COMMA!
               "# Optional Fields (uncomment as needed)",
               "# progress: "}),
            i(10, "0"),        -- 0-100 percentage
            t({"",
               "# owner: \""}),
            i(11, "unassigned"),
            t({"\"",
               "# estimated_hours: "}),
            i(12, "0"),
            t({"",
               "# due_date: \"YYYY-MM-DD\"",
               "# parent_project: \"PROJECT-ID\"",
               "# assets_path: \"path/to/assets\"",
               "tags:",         -- Array starts
               "  - \""}),
            i(13, "tag1"),
            t({"\"",           -- NO COMMA after array item!
               "  - \""}),
            i(14, "tag2"),
            t({"\"",           -- NO COMMA!
               "date_created: \""}),
            f(function() return os.date("%Y-%m-%d") end),
            t({"\"",           -- NO COMMA!
               "date_modified: \""}),
            f(function() return os.date("%Y-%m-%d") end),
            t({"\"",           -- NO COMMA!
               "---",
               ""}),
        }),

        -- ====================================================================
        -- COMMAND ARSENAL FRONTMATTER
        -- ====================================================================
        -- Trigger: Type "yaml-command" and press Tab
        -- Creates detailed command documentation frontmatter
        -- Compatible with DataView queries in PKM tools
        -- Includes: favorite, rating, success_rate, complexity, etc.
        -- ====================================================================
        s("yaml-command", {
            t({"---",
               "document_uuid: \""}),
            f(function()
                math.randomseed(os.time() + os.clock() * 1000000)
                local template = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
                return template:gsub('[xy]', function(c)
                    local v = (c == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
                    return string.format('%x', v)
                end)
            end),
            t({"\"",
               "id: \""}),
            f(function() return os.date("%Y") end),
            t("-CMD-"),
            i(1, "001"),
            t({"\"",
               "title: \""}),
            i(2, "Command Title"),
            t({"\"",
               "description: \""}),
            i(3, "Brief description of what this command does"),
            t({"\"",
               "category: \""}),
            i(4, "system-admin"),
            t({"\"",
               "subcategory: \""}),
            i(5, "file-management"),
            t({"\"",
               "type: \"command\"",
               "# DataViewJS Critical Fields",
               "favorite: "}),
            i(6, "false"),                 -- Boolean, no quotes
            t({"",
               "personal_rating: "}),
            i(7, "3"),                      -- Number, no quotes
            t({"",
               "success_rate: "}),
            i(8, "0.95"),                   -- Number, no quotes
            t({"",
               "time_saved: \""}),
            i(9, "5-10 minutes"),
            t({"\"",
               "efficiency_gain: "}),
            i(10, "1.5"),                   -- Number, no quotes
            t({"",
               "times_used: 0",             -- Number, no quotes, no comma
               "complexity: \""}),
            i(11, "intermediate"),
            t({"\"",
               "platforms:",                -- Array starts
               "  - \""}),
            i(12, "linux"),
            t({"\"",
               "risk_level: \""}),
            i(13, "low"),
            t({"\"",
               "tested: true",              -- Boolean, no quotes, no comma
               "last_used: \""}),
            f(function() return os.date("%Y-%m-%d") end),
            t({"\"",
               "tags:",
               "  - \"command\"",           -- Array item, no comma after quote
               "  - \""}),
            i(14, "category-tag"),
            t({"\"",
               "date_created: \""}),
            f(function() return os.date("%Y-%m-%d") end),
            t({"\"",
               "date_modified: \""}),
            f(function() return os.date("%Y-%m-%d") end),
            t({"\"",
               "---",
               ""}),
        }),

        -- ====================================================================
        -- EMOJI SHORTCUTS
        -- ====================================================================
        -- Quick emoji insertion for documentation

        s("check", t("✅")),
        s("cross", t("❌")),
        s("warning", t("⚠️")),
        s("info", t("ℹ️")),
        s("fire", t("🔥")),
        s("rocket", t("🚀")),
        s("star", t("⭐")),
        s("bug", t("🐛")),
        s("boom", t("💥")),
        s("sparkles", t("✨")),
    })

    -- ========================================================================
    -- COMPLETION SETUP
    -- ========================================================================
    -- Note: Completion is now handled by blink.cmp (has built-in spell support)
    -- This section is preserved but disabled for nvim-cmp compatibility

    -- Optional: If you're using nvim-cmp instead of blink.cmp, uncomment below
    --[[
    local cmp_ok, cmp = pcall(require, 'cmp')
    if cmp_ok then
        vim.api.nvim_create_autocmd("FileType", {
            pattern = { "markdown", "text", "gitcommit" },
            callback = function()
                cmp.setup.buffer {
                    sources = cmp.config.sources({
                        { name = 'nvim_lsp' },
                        { name = 'luasnip' },
                        { name = 'buffer' },
                        { name = 'path' },
                        { name = 'spell' },
                    }),
                }
            end,
        })
    end
    --]]
end

-- ============================================================================
-- MARKDOWN-SPECIFIC KEYBINDINGS
-- ============================================================================
-- Automatically activated when opening markdown files

function M.autocmds()
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function()
            -- Set conceallevel for cleaner markdown UI
            -- Level 2 = hide markdown syntax (**, __, etc.)
            vim.opt_local.conceallevel = 2
            vim.opt_local.concealcursor = 'nc'  -- Keep concealing in normal/command mode

            local opts = { buffer = true, silent = true }

            -- ================================================================
            -- TEXT FORMATTING SHORTCUTS
            -- ================================================================
            -- Note: Requires vim-surround or similar plugin

            vim.keymap.set("n", "<leader>mb", "ysiw*", opts)      -- Bold word
            vim.keymap.set("v", "<leader>mb", "S*gvS*", opts)     -- Bold selection
            vim.keymap.set("n", "<leader>mi", "ysiw_", opts)      -- Italic word
            vim.keymap.set("v", "<leader>mi", "S_", opts)         -- Italic selection
            vim.keymap.set("n", "<leader>mc", "ysiw`", opts)      -- Code word
            vim.keymap.set("v", "<leader>mc", "S`", opts)         -- Code selection

            -- ================================================================
            -- HEADER INSERTION
            -- ================================================================

            vim.keymap.set("n", "<leader>m1", "I# <Esc>", opts)   -- Make H1
            vim.keymap.set("n", "<leader>m2", "I## <Esc>", opts)  -- Make H2
            vim.keymap.set("n", "<leader>m3", "I### <Esc>", opts) -- Make H3
            vim.keymap.set("n", "<leader>m4", "I#### <Esc>", opts)-- Make H4

            -- ================================================================
            -- LIST CREATION
            -- ================================================================

            vim.keymap.set("n", "<leader>ml", "I- <Esc>", opts)   -- Bullet list
            vim.keymap.set("n", "<leader>mn", "I1. <Esc>", opts)  -- Numbered list

            -- ================================================================
            -- TASK CHECKBOX MANAGEMENT
            -- ================================================================

            vim.keymap.set("n", "<leader>mt", "I- [ ] <Esc>", opts) -- Create checkbox
            vim.keymap.set("n", "<leader>md", "^f[lrx", opts)       -- Mark done ([ ] → [x])
            vim.keymap.set("n", "<leader>mu", "^f[lr ", opts)       -- Mark undone ([x] → [ ])

            -- ================================================================
            -- LIST INDENTATION (Tab/Shift+Tab in Insert Mode)
            -- ================================================================
            -- Smart Tab: Indents list items (bullets, numbers, checkboxes)
            -- Falls back to normal Tab behavior on non-list lines

            vim.keymap.set("i", "<Tab>", function()
                local line = vim.api.nvim_get_current_line()
                -- Check if line is a list item (bullet, numbered, or checkbox)
                if line:match("^%s*[-*+]%s") or line:match("^%s*%d+%.%s") or line:match("^%s*- %[.%]") then
                    return "<Esc>>>A"  -- Indent and return to insert mode at end of line
                else
                    return "<Tab>"     -- Normal tab behavior
                end
            end, { buffer = true, expr = true, silent = true, desc = "Indent list item or normal tab" })

            vim.keymap.set("i", "<S-Tab>", function()
                local line = vim.api.nvim_get_current_line()
                -- Check if line is a list item (bullet, numbered, or checkbox)
                if line:match("^%s*[-*+]%s") or line:match("^%s*%d+%.%s") or line:match("^%s*- %[.%]") then
                    return "<Esc><<A"  -- Outdent and return to insert mode at end of line
                else
                    return "<S-Tab>"   -- Normal shift-tab behavior
                end
            end, { buffer = true, expr = true, silent = true, desc = "Outdent list item or normal shift-tab" })

            -- ================================================================
            -- LINK CREATION
            -- ================================================================

            vim.keymap.set("v", "<leader>mk", "c[<C-r>\"]()<Esc>", opts) -- Make selection a link

            -- ================================================================
            -- TABLE INSERTION
            -- ================================================================

            vim.keymap.set("n", "<leader>mT",
                "i| Column 1 | Column 2 | Column 3 |<CR>|----------|----------|----------|<CR>| | | |<Esc>",
                opts)

            -- Visual selection to markdown table converter
            -- Usage: Select lines in visual mode, press <leader>mtt
            vim.keymap.set("v", "<leader>mtt", function()
                local start_line = vim.fn.line("'<")
                local end_line = vim.fn.line("'>")
                local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)

                if #lines == 0 then
                    vim.notify("No lines selected!", vim.log.levels.WARN)
                    return
                end

                -- Auto-detect delimiter (tab, comma, or spaces)
                local delimiter = '\t'
                if not lines[1]:find('\t') then
                    delimiter = lines[1]:find(',') and ',' or '%s%s+'
                end

                local rows = {}
                local max_cols = 0

                for _, line in ipairs(lines) do
                    local cells = vim.split(line, delimiter, { trimempty = false })
                    for j, cell in ipairs(cells) do
                        cells[j] = vim.trim(cell)
                    end
                    table.insert(rows, cells)
                    max_cols = math.max(max_cols, #cells)
                end

                local result = {}
                for i, row in ipairs(rows) do
                    while #row < max_cols do table.insert(row, '') end
                    table.insert(result, '| ' .. table.concat(row, ' | ') .. ' |')
                    if i == 1 then
                        local sep = {}
                        for _ = 1, max_cols do table.insert(sep, '-------') end
                        table.insert(result, '| ' .. table.concat(sep, ' | ') .. ' |')
                    end
                end

                vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, result)
                vim.notify("Converted to markdown table", vim.log.levels.INFO)
            end, { buffer = true, silent = true, desc = "Convert selection to table" })

            -- ================================================================
            -- PREVIEW SHORTCUTS
            -- ================================================================

            vim.keymap.set("n", "<leader>mp", ":MarkdownPreview<CR>", opts)     -- Start preview
            vim.keymap.set("n", "<leader>ms", ":MarkdownPreviewStop<CR>", opts) -- Stop preview

            -- ================================================================
            -- GLOW TERMINAL PREVIEW
            -- ================================================================
            -- If glow is installed, creates a beautiful terminal preview

            if vim.fn.executable('glow') == 1 then
                vim.keymap.set("n", "<leader>mg", function()
                    local filepath = vim.fn.expand('%:p')
                    vim.cmd('vnew | terminal glow ' .. filepath)
                    vim.cmd('setlocal nonumber norelativenumber')

                    -- Exit insert mode after a brief delay
                    vim.defer_fn(function()
                        vim.cmd('stopinsert')
                    end, 100)

                    -- Allow q and Esc to close the preview
                    vim.api.nvim_buf_set_keymap(0, 'n', 'q', ':bd!<CR>',
                        { noremap = true, silent = true })
                    vim.api.nvim_buf_set_keymap(0, 'n', '<Esc>', ':bd!<CR>',
                        { noremap = true, silent = true })
                end, { buffer = true, desc = "Preview with Glow" })
            end
        end,
    })
end

-- ============================================================================
-- USER COMMANDS
-- ============================================================================
-- Commands available via :CommandName

function M.commands()

    -- ========================================================================
    -- GLOW PREVIEW COMMAND
    -- ========================================================================
    -- Creates a beautiful markdown preview in a terminal split

    if vim.fn.executable('glow') == 1 then
        vim.api.nvim_create_user_command('Glow', function()
            local filepath = vim.fn.expand('%:p')
            vim.cmd('vnew | terminal glow ' .. filepath)
            vim.cmd('setlocal nonumber norelativenumber')

            vim.defer_fn(function()
                vim.cmd('stopinsert')
                vim.notify("Glow Preview: Use j/k or Ctrl-D/Ctrl-U to scroll. Press q or Esc to close.",
                    vim.log.levels.INFO)
            end, 100)

            -- Set up keybindings to close the preview
            vim.api.nvim_buf_set_keymap(0, 'n', 'q', ':bd!<CR>',
                { noremap = true, silent = true })
            vim.api.nvim_buf_set_keymap(0, 'n', '<Esc>', ':bd!<CR>',
                { noremap = true, silent = true })
        end, { desc = 'Preview markdown with Glow in split' })
    else
        -- If glow isn't installed, provide installation instructions
        vim.api.nvim_create_user_command('GlowInstall', function()
            vim.notify([[
Glow is not installed. Install it for terminal markdown rendering:

Windows:  scoop install glow
Mac:      brew install glow
Linux:    sudo snap install glow

Or download from: https://github.com/charmbracelet/glow/releases

After installing, restart Neovim to use :Glow command
]], vim.log.levels.INFO)
        end, { desc = 'Show Glow installation instructions' })
    end

    -- ========================================================================
    -- MARKDOWN CONCEALING TOGGLE
    -- ========================================================================
    -- Toggles whether markdown syntax is hidden (concealed) or shown

    vim.api.nvim_create_user_command('MarkdownConceal', function()
        if vim.wo.conceallevel == 0 then
            -- Enable concealing (hide syntax like ** and __)
            vim.wo.conceallevel = 2
            vim.wo.concealcursor = 'nc'
            vim.notify("Markdown concealing enabled (hides syntax)", vim.log.levels.INFO)
        else
            -- Disable concealing (show all syntax)
            vim.wo.conceallevel = 0
            vim.wo.concealcursor = ''
            vim.notify("Markdown concealing disabled (shows syntax)", vim.log.levels.INFO)
        end
    end, { desc = 'Toggle markdown syntax concealing' })

    -- ========================================================================
    -- FRONTMATTER VALIDATOR
    -- ========================================================================
    -- Checks if the current file has valid YAML frontmatter for PKM systems

    local function validate_frontmatter()
        local lines = vim.api.nvim_buf_get_lines(0, 0, 50, false)
        local in_frontmatter = false

        -- Required fields for knowledge base documents
        local has_uuid = false
        local has_id = false
        local has_title = false
        local has_description = false
        local has_category = false
        local has_type = false
        local has_tags = false
        local tags_format_correct = true

        -- Scan the first 50 lines for frontmatter
        for i, line in ipairs(lines) do
            if line == "---" then
                if not in_frontmatter then
                    in_frontmatter = true
                else
                    break  -- End of frontmatter
                end
            elseif in_frontmatter then
                -- Check for required fields
                if line:match("^document_uuid:") then has_uuid = true end
                if line:match("^id:") then has_id = true end
                if line:match("^title:") then has_title = true end
                if line:match("^description:") then has_description = true end
                if line:match("^category:") then has_category = true end
                if line:match("^type:") then has_type = true end
                if line:match("^tags:") then has_tags = true end

                -- Check for incorrect inline array format
                if line:match("tags:%s*%[") then
                    tags_format_correct = false
                end
            end
        end

        -- Build list of missing fields
        local missing = {}
        if not has_uuid then table.insert(missing, "document_uuid") end
        if not has_id then table.insert(missing, "id") end
        if not has_title then table.insert(missing, "title") end
        if not has_description then table.insert(missing, "description") end
        if not has_category then table.insert(missing, "category") end
        if not has_type then table.insert(missing, "type") end
        if not has_tags then table.insert(missing, "tags") end

        -- Display results
        if #missing == 0 and tags_format_correct then
            vim.notify("✅ Frontmatter validation passed!",
                vim.log.levels.INFO)
        else
            local message = "Frontmatter Issues:\n\n"
            if #missing > 0 then
                message = message .. "❌ Missing fields: " .. table.concat(missing, ", ") .. "\n"
            end
            if not tags_format_correct then
                message = message .. "⚠️  Use YAML array format for tags (- \"tag\") not [tag]\n"
            end
            message = message .. "\n💡 Use 'frontmatter' snippet for compliant template."
            vim.notify(message, vim.log.levels.WARN)
        end
    end

    vim.api.nvim_create_user_command('FrontmatterValidate', validate_frontmatter,
        { desc = 'Validate YAML frontmatter for PKM systems' })

    -- Insert `ps aux` output as markdown table (Linux/macOS only)
    vim.api.nvim_create_user_command('PsTable', function()
        local output = vim.fn.systemlist('ps aux')
        if vim.v.shell_error ~= 0 or #output == 0 then
            vim.notify("Failed to run 'ps aux'", vim.log.levels.ERROR)
            return
        end

        local result = {}
        for i, line in ipairs(output) do
            local cells = vim.split(line, '%s+', { trimempty = true })
            for j, cell in ipairs(cells) do cells[j] = vim.trim(cell) end
            table.insert(result, '| ' .. table.concat(cells, ' | ') .. ' |')
            if i == 1 then
                local sep = {}
                for _ = 1, #cells do table.insert(sep, '-------') end
                table.insert(result, '| ' .. table.concat(sep, ' | ') .. ' |')
            end
        end

        local row = vim.api.nvim_win_get_cursor(0)[1]
        vim.api.nvim_buf_set_lines(0, row, row, false, result)
        vim.notify("Inserted process table", vim.log.levels.INFO)
    end, { desc = 'Insert ps aux as markdown table' })
end

return M
