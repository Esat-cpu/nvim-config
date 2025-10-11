set tabstop=4
set shiftwidth=4
set expandtab
set number
set list

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
Plug 'windwp/nvim-autopairs'

Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'


" Plug 'neovim/nvim-lspconfig'

Plug 'romgrk/barbar.nvim', { 'requires': 'nvim-web-devicons' }

call plug#end()

autocmd FileType floaterm setlocal nonumber norelativenumber

nnoremap <C-t> :Neotree toggle<CR>
nnoremap <C-l> :UndotreeToggle<CR>


vnoremap <Tab> >gv
vnoremap <S-Tab> <gv


let g:onedark_config = {'style': 'warmer',}
colorscheme onedark

let g:floaterm_keymap_new    = '<F7>'
let g:floaterm_keymap_prev   = '<F8>'
let g:floaterm_keymap_next   = '<F9>'
let g:floaterm_keymap_toggle = '<F12>'
nnoremap <F5> :w<CR>:FloatermNew --autoclose=0 python3 %<CR>


let g:floaterm_position = 'bottom'
let g:floaterm_height = 0.3
let g:floaterm_wintype = 'split'
" let g:floaterm_shell = 'powershell.exe'


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

require('nvim-autopairs').setup{
    check_ts = false,
}

local npairs = require('nvim-autopairs')
local Rule = require('nvim-autopairs.rule')

-- Süslü parantezlerde Enter
npairs.add_rules{
    Rule("{", "}")
        :with_pair(function() return true end)
        :with_move(function(opts)
            return opts.char == "}"
        end)
        :use_key("\n")
}


local cmp = require'cmp'
local luasnip = require'luasnip'

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },

  mapping = {
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),

    ['<CR>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        local entry = cmp.get_selected_entry()
        if entry == nil then
          cmp.abort()   -- öneriler açık ama seçili yoksa kapat
        else
          cmp.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = false,
          })
        end
      else
        fallback()  -- öneriler kapalıysa alt satıra geç
      end
    end, {'i', 's'}),
  },

  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer' },
    { name = 'path' },
  }
})

-- require'lspconfig'.jedi_language_server.setup{}

require'barbar'.setup {
  -- En güncel ikon ayarları
  icons = {
    filetype = {
      enabled = true,
    },
  },
  animation = true,
  auto_hide = false,}


EOF
