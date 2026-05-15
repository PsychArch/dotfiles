-- Keymaps are loaded before lazy.nvim startup.

vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

---------------------
-- General Keymaps -------------------

-- use jk to exit insert mode
-- keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

-- clear search highlights
-- keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- delete single character without copying into register
-- keymap.set("n", "x", '"_x')

-- increment/decrement numbers
-- keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- increment
-- keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement

-- window management
-- keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
-- keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

-- keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
-- keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab

vim.cmd([[
nnoremap ; :

nnoremap <C-a> 0
inoremap <C-a> <HOME>
cnoremap <C-a> <HOME>
onoremap <C-a> <HOME>
snoremap <C-a> <HOME>
xnoremap <C-a> <HOME>

" CTRL-e
nnoremap <C-e> $
inoremap <C-e> <END>
cnoremap <C-e> <END>
onoremap <C-e> <END>
snoremap <C-e> <END>
xnoremap <C-e> <END>

" shift+arrow selection
nmap <S-Up> v<Up>
nmap <S-Down> v<Down>
nmap <S-Left> v<Left>
nmap <S-Right> v<Right>
vmap <S-Up> <Up>
vmap <S-Down> <Down>
vmap <S-Left> <Left>
vmap <S-Right> <Right>
imap <S-Up> <Esc>v<Up>
imap <S-Down> <Esc>v<Down>
imap <S-Left> <Esc>v<Left>
imap <S-Right> <Esc>v<Right>

nmap <M-Down> :<C-u>move.+1<CR>
nmap <M-Up> :<C-u>move.-2<CR>
imap <M-Down> <C-o>:<C-u>move.+1<CR>
imap <M-Up> <C-o>:<C-u>move.-2<CR>
vmap <M-Down> :move '>+1<CR>gv
vmap <M-Up> :move '<-2<CR>gv

nnoremap <M-t> :tabnew<CR>
nnoremap <M-w> :tabclose<CR>
]])

-- Sudo write shortcut - type :w!! to save with sudo
vim.keymap.set("c", "w!!", "w !sudo tee % > /dev/null", { desc = "Sudo write shortcut" })
