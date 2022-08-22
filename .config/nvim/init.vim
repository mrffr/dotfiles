"VIM-PLUG
call plug#begin('~/.local/share/nvim/plugged')

"theme
Plug 'morhetz/gruvbox'

"Native lsp server
Plug 'neovim/nvim-lspconfig'

"completion engine
Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}
"snippets
Plug 'ms-jpq/coq.artifacts', {'branch': 'artifacts'}

call plug#end()

"if $TERM =~ '^\(xterm\)\(-.*\)\?$'
  set termguicolors
  let g:gruvbox_contrast_dark='hard'
  colorscheme gruvbox
  set background=dark
"endif

set tabstop=2
set shiftwidth=2
set expandtab
set showmatch "show matching parens
set ignorecase
set smartcase "ignore case when searching if all lowercase
set shell=/bin/bash "fish has problems??
set enc=utf-8
set wrapscan

set inccommand=nosplit "show replace preview

"set noshowcmd noruler

":find tab and wildmenu
set path+=**
set wildmenu

"fix potential bug in vim in kitty terminal emulator
"let &t_ut = "" 
"let &t_8f = "\e[38;2;%lu;%lu;%lum"
"let &t_8b = "\e[48;2;%lu;%lu;%lum"

"learn folding"
"set foldenable
set foldlevelstart=999
set foldmethod=syntax
set signcolumn=yes


"use .h as c file
let g:c_syntax_for_h=1

"LSP setup
let g:coq_settings = { 'auto_start': 'shut-up' }
lua << EOF
local lspconfig = require('lspconfig')
local coq = require('coq')

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
  buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end

local servers = { 'ccls' }
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup (
    coq.lsp_ensure_capabilities( 
      {
        on_attach = on_attach,
        init_options = {
          cache = {
            directory = "/tmp/cache";
            };
          }
      }
    )
    )
end
EOF
