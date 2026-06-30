return {
  "nvim-neo-tree/neo-tree.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  config = function()
    -- Disable netrw (same as nvim-tree)
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    require("neo-tree").setup({
      close_if_last_window = true, -- Close Neo-tree if it's the last window
      popup_border_style = "rounded",
      enable_git_status = true,
      enable_diagnostics = true,

      default_component_configs = {
        indent = {
          indent_size = 2,
          padding = 1,
          with_markers = true,
          indent_marker = "│",
          last_indent_marker = "└",
          with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
          expander_collapsed = "",
          expander_expanded = "",
          expander_highlight = "NeoTreeExpander",
        },
        icon = {
          folder_closed = "",
          folder_open = "",
          folder_empty = "∅",
          default = "*",
          highlight = "NeoTreeFileIcon"
        },
        modified = {
          symbol = "[+]",
          highlight = "NeoTreeModified",
        },
        name = {
          trailing_slash = false,
          use_git_status_colors = true,
          highlight = "NeoTreeFileName",
        },
        git_status = {
          symbols = {
            -- Change type
            added     = "+",  -- Simple plus sign
            modified  = "M",  -- M for modified (matches git status)
            deleted   = "✖",  -- Already compatible
            renamed   = "→", -- Arrow for renamed
            -- Status type
            untracked = "?",  -- Question mark for untracked
            ignored   = "◌",  -- Circle for ignored
            unstaged  = "●",  -- Filled circle for unstaged
            staged    = "✓",  -- Checkmark for staged
            conflict  = "!",  -- Exclamation for conflict
          }
        },
      },

      window = {
        position = "left",
        width = 35,
        mappings = {
          ["<Tab>"] = "toggle_node",
          ["<2-LeftMouse>"] = "open",
          ["<cr>"] = "open",
          ["l"] = "open",
          ["h"] = "close_node",
          ["z"] = "close_all_nodes",
          ["Z"] = "expand_all_nodes",
          ["a"] = {
            "add",
            config = {
              show_path = "none" -- "none", "relative", "absolute"
            }
          },
          ["A"] = "add_directory",
          ["d"] = "delete",
          ["r"] = "rename",
          ["y"] = "copy_to_clipboard",
          ["x"] = "cut_to_clipboard",
          ["p"] = "paste_from_clipboard",
          ["c"] = "copy", -- takes text input for destination
          ["m"] = "move", -- takes text input for destination
          ["q"] = "close_window",
          ["R"] = "refresh",
          ["?"] = "show_help",
        }
      },

      filesystem = {
        filtered_items = {
          visible = false, -- when true, they will just be displayed differently
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_by_name = {
            ".DS_Store",
            "thumbs.db"
          },
        },
        follow_current_file = {
          enabled = true, -- This will find and focus the file in the active buffer
        },
        group_empty_dirs = false,
        hijack_netrw_behavior = "open_default", -- netrw disabled, open as usual
        use_libuv_file_watcher = true, -- auto-refresh on file changes
        window = {
          mappings = {
            ["<bs>"] = "navigate_up",
            ["."] = "set_root",
            ["H"] = "toggle_hidden",
            ["/"] = "fuzzy_finder",
            ["f"] = "filter_on_submit",
            ["<c-x>"] = "clear_filter",
            ["[g"] = "prev_git_modified",
            ["]g"] = "next_git_modified",
          }
        }
      },

      buffers = {
        follow_current_file = {
          enabled = true
        },
        group_empty_dirs = true,
        show_unloaded = true,
      },

      git_status = {
        window = {
          position = "float",
        }
      },
    })

    -- Set keymaps (matching nvim-tree keybindings)
    local keymap = vim.keymap

    keymap.set("n", "<leader>ee", "<cmd>Neotree toggle<CR>", { desc = "Toggle file explorer" })
    keymap.set("n", "<leader>ef", "<cmd>Neotree reveal<CR>", { desc = "Reveal current file in explorer" })
    keymap.set("n", "<leader>ec", "<cmd>Neotree close<CR>", { desc = "Close file explorer" })
    keymap.set("n", "<leader>er", "<cmd>Neotree refresh<CR>", { desc = "Refresh file explorer" })
  end,
}
