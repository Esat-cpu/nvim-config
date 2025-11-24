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

Plug 'neovim/nvim-lspconfig'

Plug 'romgrk/barbar.nvim', { 'requires': 'nvim-web-devicons' }

call plug#end()

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
let g:floaterm_shell = 'powershell.exe'


" home and end key functionality on insert mode
inoremap <C-Left> <C-o>0
inoremap <C-Right> <C-o>$
inoremap <M-h> <C-o>0
inoremap <M-l> <C-o>$




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

require'lspconfig'.jedi_language_server.setup{}

require'barbar'.setup {
  -- En güncel ikon ayarları
  icons = {
    filetype = {
      enabled = true,
    },
  },
  animation = true,
  auto_hide = false,
}



function SmartCloseBuffer()
  local current_buf = vim.api.nvim_get_current_buf()
  local modified = vim.api.nvim_buf_get_option(current_buf, "modified")
  local buffers = vim.fn.getbufinfo({ buflisted = 1 })

  if modified then
    local save_choice = vim.fn.confirm("Buffer değişti. Kaydedilsin mi?", "&Evet\n&Hayır\n&İptal", 3)
    if save_choice == 1 then
      -- Kaydet ve devam et
      vim.cmd("write")
    elseif save_choice == 3 or save_choice == 0 then
      -- İptal veya ESC basıldı, kapatma işlemi iptal
      print("Kapatma iptal edildi.")
      return
    end
  end


  -- Eğer sadece bir buffer kaldıysa yeni aç sonra kapat
  if #buffers <= 1 then
    vim.cmd("enew")
    vim.cmd("bdelete! " .. current_buf)
    return
  end

  -- Başka buffer varsa ona geçip kapat
  local next_buf = nil
  for _, buf in ipairs(buffers) do
    if buf.bufnr ~= current_buf then
      next_buf = buf.bufnr
      break
    end
  end

  if next_buf then
    vim.cmd("buffer " .. next_buf)
    vim.cmd("bdelete! " .. current_buf)
  else
    print("Kapatılacak başka buffer bulunamadı.")
  end
end


vim.api.nvim_set_keymap('n', '<C-e>', ':lua SmartCloseBuffer()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-z>', ':BufferPrevious<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-x>', ':BufferNext<CR>', { noremap = true, silent = true })



vim.api.nvim_create_autocmd("BufAdd", {
  callback = function()
    local bufs = vim.api.nvim_list_bufs()
    for _, buf in ipairs(bufs) do
      local name = vim.api.nvim_buf_get_name(buf)
      local listed = vim.api.nvim_buf_get_option(buf, "buflisted")
      if listed and name == "" and vim.api.nvim_buf_is_loaded(buf) then
        -- "[No Name]" buffer'ı kapat
        vim.cmd("silent! bdelete " .. buf)
      end
    end
  end,
})


EOF
