#!/usr/bin/env bash

root_install() { pacman -Syu --needed neovim; }
export -f root_install

su root -c 'root_install'

mkdir -p ~/.config/nvim

cat > ~/.config/nvim/init.lua <<'EOF'

vim.g.mapleader = " "

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt smartindent = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.scrolloff = 4

vim.keymap.set("n", "<leader>w", "<cmd>write<cr>", { desc = "write to file" })
vim.keymap.set("n", "<leader>q", "<cmd>quit<cr>", { desc = "quit" })
EOF
