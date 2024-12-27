return {
  'nvim-telescope/telescope.nvim',
  branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',

    -- Fuzzy Finder Algorithm which requires local dependencies to be built.
    -- Only load if `make` is available. Make sure you have the system
    -- requirements installed.
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      -- NOTE: If you are having trouble with this installation,
      --       refer to the README for telescope-fzf-native for more instructions.
      build = 'make',
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },

    -- Telescope extension to list projects, folders
    'nvim-telescope/telescope-project.nvim',
  },
  config = function()
    require("telescope").setup({
      extensions = {
        project = {
          on_project_selected = function(prompt_bufnr)
            require("telescope._extensions.project.actions").change_working_directory(prompt_bufnr, false)
          end,
          base_dirs = {
            { '~/src', max_depth = 4 },
          },
          search_by = "path",
        }
      }
    })

    local t_builtin = require("telescope.builtin")
    local telescope_with_theme = function(picker, opts)
      local default_opts = {
        layout_config = { height = 15 },
        border = true,
      }

      opts = vim.tbl_deep_extend("force", default_opts, opts or {})

      return function()
        picker(require("telescope.themes").get_ivy(opts))
      end
    end

    vim.keymap.set('n', '<leader>sf', telescope_with_theme(t_builtin.find_files), { desc = '[S]earch [F]iles' })
    vim.keymap.set('n', '<leader>sh', telescope_with_theme(t_builtin.help_tags), { desc = '[S]earch [H]elp' })
    vim.keymap.set('n', '<leader>sg', telescope_with_theme(t_builtin.live_grep), { desc = '[S]earch by [G]rep' })
    vim.keymap.set('n', '<leader>sp',
      telescope_with_theme(require("telescope").extensions.project.project,
        { display_type = "full", hide_workspace = true }),
      { desc = '[S]earch by [G]rep' })
    vim.keymap.set('n', '<leader>x', telescope_with_theme(t_builtin.commands), { desc = '[S]earch [C]ommands' })

    -- Enable telescope fzf native, if installed
    require("telescope").load_extension("fzf")
  end
}

-- -- Telescope live_grep in git root
-- -- Function to find the git root directory based on the current buffer's path
-- local function find_git_root()
--   -- Use the current buffer's path as the starting point for the git search
--   local current_file = vim.api.nvim_buf_get_name(0)
--   local current_dir
--   local cwd = vim.fn.getcwd()
--   -- If the buffer is not associated with a file, return nil
--   if current_file == "" then
--     current_dir = cwd
--   else
--     -- Extract the directory from the current file's path
--     current_dir = vim.fn.fnamemodify(current_file, ":h")
--   end
--
--   -- Find the Git root directory from the current file's path
--   local git_root = vim.fn.systemlist("git -C " .. vim.fn.escape(current_dir, " ") .. " rev-parse --show-toplevel")[1]
--   if vim.v.shell_error ~= 0 then
--     print("Not a git repository. Searching on current working directory")
--     return cwd
--   end
--   return git_root
-- end
--
-- -- Custom live_grep function to search in git root
-- local function live_grep_git_root()
--   local git_root = find_git_root()
--   if git_root then
--     require('telescope.builtin').live_grep({
--       search_dirs = { git_root },
--     })
--   end
-- end

-- vim.api.nvim_create_user_command('LiveGrepGitRoot', live_grep_git_root, {})
--
-- -- See `:help telescope.builtin`
-- vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
-- vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
-- vim.keymap.set('n', '<leader>/', function()
--   -- You can pass additional configuration to telescope to change theme, layout, etc.
--   require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
--     winblend = 10,
--     previewer = false,
--   })
-- end, { desc = '[/] Fuzzily search in current buffer' })
--
-- -- vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
-- -- vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
-- -- vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
-- vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
-- vim.keymap.set('n', '<leader>sb', require('telescope.builtin').buffers, { desc = '[S]earch [B]uffers' })
-- vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
-- vim.keymap.set('n', '<leader>sG', ':LiveGrepGitRoot<cr>', { desc = '[S]earch by [G]rep on Git Root' })
-- vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
-- vim.keymap.set('n', '<leader>sr', require('telescope.builtin').resume, { desc = '[S]earch [R]esume' })