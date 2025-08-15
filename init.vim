set tabstop=4
set shiftwidth=4
set expandtab
set number

call plug#begin()

Plug 'https://github.com/vim-airline/vim-airline'
Plug 'https://github.com/ryanoasis/vim-devicons'
Plug 'https://github.com/mbbill/undotree'
Plug 'https://github.com/navarasu/onedark.nvim'
Plug 'voldikss/vim-floaterm'
Plug 'https://github.com/matze/vim-move'
Plug 'alvan/vim-closetag'
Plug 'https://github.com/lepture/vim-jinja'

Plug 'nvim-neo-tree/neo-tree.nvim', {'branch': 'v3.x'}
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'MunifTanjim/nui.nvim'

Plug 'dstein64/nvim-scrollview'


call plug#end()

nnoremap <C-t> :Neotree toggle<CR>
nnoremap <C-l> :UndotreeToggle<CR>


let g:onedark_config = {'style': 'warmer',}
colorscheme onedark

inoremap <expr> <Tab> pumvisible() ? "\<C-N>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-P>" : "\<C-H>"


let g:floaterm_keymap_new    = '<F7>'
let g:floaterm_keymap_prev   = '<F8>'
let g:floaterm_keymap_next   = '<F9>'
let g:floaterm_keymap_toggle = '<F12>'
nnoremap <F5> :w<CR>:FloatermNew --autoclose=0 python3 %<CR>


let g:floaterm_position = 'bottom'
let g:floaterm_height = 0.3
let g:floaterm_wintype = 'split'
let g:floaterm_shell = 'powershell.exe'


lua << EOF
require("neo-tree").setup({
  filesystem = {
    follow_current_file = { enabled = true },
    use_libuv_file_watcher = true,
    filtered_items = {
        visible = false, -- Show hidden files
        hide_dotfiles = false, -- Show files starting with .
        hide_gitignored = false, -- Show .gitignored files
    },
  },
})

require('scrollview').setup()
EOF
