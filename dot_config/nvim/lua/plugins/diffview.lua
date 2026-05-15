return {
  "sindrets/diffview.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles", "DiffviewFileHistory" },
  config = function()
    local actions = require("diffview.actions")

    require("diffview").setup({
      diff_binaries = false,
      enhanced_diff_hl = false,
      git_cmd = { "git" },
      use_icons = true,
      show_help_hints = true,
      watch_index = true,
      icons = {
        folder_closed = "",
        folder_open = "",
      },
      signs = {
        fold_closed = "",
        fold_open = "",
        done = "✓",
      },
      view = {
        default = {
          layout = "diff2_horizontal",
          disable_diagnostics = false,
          winbar_info = false,
        },
        merge_tool = {
          layout = "diff3_horizontal",
          disable_diagnostics = true,
          winbar_info = true,
        },
        file_history = {
          layout = "diff2_horizontal",
          disable_diagnostics = false,
          winbar_info = false,
        },
      },
      file_panel = {
        listing_style = "tree",
        tree_options = {
          flatten_dirs = true,
          folder_statuses = "only_folded",
        },
        win_config = {
          position = "left",
          width = 35,
          win_opts = {},
        },
      },
      file_history_panel = {
        log_options = {
          git = {
            single_file = {
              diff_merges = "combined",
            },
            multi_file = {
              diff_merges = "first-parent",
            },
          },
        },
        win_config = {
          position = "bottom",
          height = 16,
          win_opts = {},
        },
      },
      keymaps = {
        disable_defaults = false,
        view = {
          { "n", "<tab>", actions.select_next_entry, { desc = "Open the diff for the next file" } },
          { "n", "<s-tab>", actions.select_prev_entry, { desc = "Open the diff for the previous file" } },
          { "n", "gf", actions.goto_file_edit, { desc = "Open the file in the previous tabpage" } },
          { "n", "<leader>de", actions.focus_files, { desc = "Bring focus to the file panel" } },
          { "n", "<leader>db", actions.toggle_files, { desc = "Toggle the file panel" } },
          { "n", "g<C-x>", actions.cycle_layout, { desc = "Cycle through available layouts" } },
          { "n", "[x", actions.prev_conflict, { desc = "Jump to the previous conflict" } },
          { "n", "]x", actions.next_conflict, { desc = "Jump to the next conflict" } },
        },
        file_panel = {
          { "n", "j", actions.next_entry, { desc = "Bring the cursor to the next file entry" } },
          { "n", "k", actions.prev_entry, { desc = "Bring the cursor to the previous file entry" } },
          { "n", "<cr>", actions.select_entry, { desc = "Open the diff for the selected entry" } },
          { "n", "o", actions.select_entry, { desc = "Open the diff for the selected entry" } },
          { "n", "l", actions.select_entry, { desc = "Open the diff for the selected entry" } },
          { "n", "-", actions.toggle_stage_entry, { desc = "Stage / unstage the selected entry" } },
          { "n", "S", actions.stage_all, { desc = "Stage all entries" } },
          { "n", "U", actions.unstage_all, { desc = "Unstage all entries" } },
          { "n", "X", actions.restore_entry, { desc = "Restore entry to the state on the left side" } },
          { "n", "L", actions.open_commit_log, { desc = "Open the commit log panel" } },
          { "n", "<tab>", actions.select_next_entry, { desc = "Open the diff for the next file" } },
          { "n", "<s-tab>", actions.select_prev_entry, { desc = "Open the diff for the previous file" } },
          { "n", "gf", actions.goto_file_edit, { desc = "Open the file in the previous tabpage" } },
          { "n", "R", actions.refresh_files, { desc = "Update stats and entries in the file list" } },
          { "n", "<leader>de", actions.focus_files, { desc = "Bring focus to the file panel" } },
          { "n", "<leader>db", actions.toggle_files, { desc = "Toggle the file panel" } },
        },
        file_history_panel = {
          { "n", "g!", actions.options, { desc = "Open the option panel" } },
          { "n", "y", actions.copy_hash, { desc = "Copy the commit hash of the entry under the cursor" } },
          { "n", "L", actions.open_commit_log, { desc = "Show commit details" } },
          { "n", "j", actions.next_entry, { desc = "Bring the cursor to the next file entry" } },
          { "n", "k", actions.prev_entry, { desc = "Bring the cursor to the previous file entry" } },
          { "n", "<cr>", actions.select_entry, { desc = "Open the diff for the selected entry" } },
          { "n", "o", actions.select_entry, { desc = "Open the diff for the selected entry" } },
          { "n", "l", actions.select_entry, { desc = "Open the diff for the selected entry" } },
          { "n", "<tab>", actions.select_next_entry, { desc = "Open the diff for the next file" } },
          { "n", "<s-tab>", actions.select_prev_entry, { desc = "Open the diff for the previous file" } },
          { "n", "gf", actions.goto_file_edit, { desc = "Open the file in the previous tabpage" } },
          { "n", "<leader>de", actions.focus_files, { desc = "Bring focus to the file panel" } },
          { "n", "<leader>db", actions.toggle_files, { desc = "Toggle the file panel" } },
        },
      },
    })

    -- Keymaps for opening diffview
    vim.keymap.set("n", "<leader>gd", "<cmd>DiffviewOpen<cr>", { desc = "Open Diffview" })
    vim.keymap.set("n", "<leader>gD", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" })
    vim.keymap.set("n", "<leader>gh", "<cmd>DiffviewFileHistory<cr>", { desc = "Diffview File History (all)" })
    vim.keymap.set("n", "<leader>gH", "<cmd>DiffviewFileHistory %<cr>", { desc = "Diffview File History (current file)" })
  end,
}
