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
Plug 'rust-lang/rust.vim'

Plug 'romgrk/barbar.nvim', { 'requires': 'nvim-web-devicons' }

call plug#end()



let mapleader = " "



autocmd FileType floaterm setlocal nonumber norelativenumber

nnoremap <C-t> :Neotree toggle<CR>
nnoremap T :Neotree toggle<CR>
nnoremap <C-l> :UndotreeToggle<CR>


let g:onedark_config = {'style': 'warmer',}
colorscheme onedark

let g:floaterm_keymap_new    = '<F7>'
let g:floaterm_keymap_prev   = '<F8>'
let g:floaterm_keymap_next   = '<F9>'
let g:floaterm_keymap_toggle = '<F12>'

nnoremap <F5> :w<CR>:FloatermNew --autoclose=0 python3 %<CR>
nnoremap <F6> :w<CR>:FloatermNew --autoclose=0 gcc % -o z -g -fsanitize=address && {./z; rm z}<CR>
nnoremap <F2> :w<CR>:FloatermNew --autoclose=0 cargo run<CR>

" terminal
" open/toggle
nnoremap <leader>t :FloatermToggle<CR>
" exit
tnoremap <C-e> <C-d>
" toggle
tnoremap <C-t> <C-\><C-n>:FloatermToggle<CR>
" terminal normal mode
tnoremap <C-n> <C-\><C-n>



let g:floaterm_position = 'bottom'
let g:floaterm_height = 0.4
let g:floaterm_wintype = 'split'






set clipboard=unnamedplus



" indent selected lines
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv

" comment out the selected line
xmap <leader>y gc


" home and end key functionality on insert mode
inoremap <C-Left> <C-o>0
inoremap <C-Right> <C-o>$
inoremap <M-h> <C-o>0
inoremap <M-l> <C-o>$


" move up and down in insert mode
inoremap <M-j> <Esc>ja
inoremap <M-k> <Esc>ka


" home and end shortcuts
nnoremap <leader>h <Home>
nnoremap <leader>l <End>
vnoremap <leader>h <Home>
vnoremap <leader>l <End>h


" shortuct for moving the page depend on cursor
nnoremap <leader><leader> zz


" manuel page
nnoremap <leader>m K
vnoremap <leader>m K

" half page up
nnoremap K <C-u>
vnoremap K <C-u>


" whatever J is doing
nnoremap <leader>j J
vnoremap <leader>j J
nnoremap J <C-d>
vnoremap J <C-d>


" select all
nnoremap <leader>a ggVG


" redo
nnoremap R <C-r>
nnoremap <leader>R R


" scroll page
nnoremap <C-j> <C-e>
nnoremap <C-k> <C-y>
vnoremap <C-j> <C-e>
vnoremap <C-k> <C-y>


" delete only
nnoremap d "_d
vnoremap d "_d
nnoremap D "_D
vnoremap D "_D


" cut and go to normal mode
nnoremap c c<Esc>
vnoremap c c<Esc>


" Parentheses
vnoremap <leader>( c(<C-r>")<Esc>
vnoremap <leader>[ c[<C-r>"]<Esc>
vnoremap <leader>{ c{<C-r>"}<Esc>
vnoremap <leader>" c"<C-r>""<Esc>
vnoremap <leader>' c'<C-r>"'<Esc>


" F
nnoremap F M
vnoremap F M
nnoremap <leader>F F
vnoremap <leader>F F

"
nnoremap , <C-w>
nnoremap <leader>w <C-w>

"
inoremap <M-f> <Esc>
vnoremap <M-f> <Esc>


" toggle lsp
nnoremap <leader>x :lua toggle_lsp()<CR>




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

  vim.api.nvim_create_autocmd("TermLeave", {
      callback = function()
        require("neo-tree.sources.manager").refresh("filesystem")
      end,
  }),
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




-- LSP

-- Rust
vim.lsp.config("rust-analyzer", {
  cmd = { "rust-analyzer" },
  filetypes = { "rust" },
  root_markers = { "Cargo.toml", ".git" },

  settings = {
    ["rust-analyzer"] = {
      cargo = {
        allFeatures = true,
      },
      checkOnSave = true,
      check = {
        command = "clippy",
      },
    },
  },
})


vim.lsp.enable("rust-analyzer")

-- Python
vim.lsp.config.pylsp = {
  cmd = {"pylsp"},
  settings = {
    pylsp = {
      plugins = {
        pyflakes = { enabled = true },
        pycodestyle = { enabled = false },
      },
    },
  },
}

vim.lsp.enable("pylsp")


-- C/C++
vim.lsp.config("clangd", {
  cmd = { "clangd", "--background-index" },
  filetypes = { "c", "cpp" },
  root_markers = { "compile_commands.json", ".git" },
})
vim.lsp.enable("clangd")


-- LSP keymaps
vim.api.nvim_set_keymap('n', '<leader>e',
    '<cmd>lua vim.lsp.buf.hover()<CR>',
    { noremap = true, silent = true }
)

vim.api.nvim_set_keymap(
  'n',
  '<leader>d',
  '<cmd>lua vim.diagnostic.open_float()<CR>',
  { noremap = true, silent = true }
)

vim.api.nvim_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>c', '<cmd>lua vim.lsp.buf.code_action()<CR>', { noremap = true, silent = true })



-- Icons
require'barbar'.setup {
  -- En güncel ikon ayarları
  icons = {
    filetype = {
      enabled = true,
    },
  },
  animation = true,
  auto_hide = false,}


-- Closing modified buffer
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

  -- Başka buffer varsa en son açılan (MRU) olana geçip kapat
  local next_buf = nil
  local last_used = -1
  for _, buf in ipairs(buffers) do
    if buf.bufnr ~= current_buf and buf.lastused and buf.lastused > last_used then
      next_buf = buf.bufnr
      last_used = buf.lastused
    end
  end

  if next_buf then
    vim.cmd("buffer " .. next_buf)
    vim.cmd("bdelete! " .. current_buf)
  else
    print("Kapatılacak başka buffer bulunamadı.")
  end
end

-- Close Buffer
vim.api.nvim_set_keymap('n', '<C-e>', ':lua SmartCloseBuffer()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>q', ':lua SmartCloseBuffer()<CR>', { noremap = true, silent = true })

-- Buffer prev/next
vim.api.nvim_set_keymap('n', '<C-x>', ':BufferPrevious<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-c>', ':BufferNext<CR>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<leader>s', ':BufferPrevious<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>g', ':BufferNext<CR>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<M-Left>', ':BufferPrevious<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<M-Right>', ':BufferNext<CR>', { noremap = true, silent = true })


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



-- Toggle lsp function
_G.toggle_lsp = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({ bufnr = bufnr })

  if #clients > 0 then
    vim.lsp.stop_client(clients)
    vim.notify("LSP stopped", vim.log.levels.WARN)
  else
    -- Determine the server depends on filetype
    local ft = vim.bo[bufnr].filetype
    local server = nil
    if ft == "rust" then
      server = "rust-analyzer"
    elseif ft == "python" then
      server = "python-lsp-server"
    elseif ft == "c" or ft == "cpp" then
      server = "clangd"
    end

    if server then
      vim.lsp.enable(server)
      vim.notify(server .. " enabled", vim.log.levels.INFO)
    else
      vim.notify("No LSP configured for this filetype: " .. ft, vim.log.levels.WARN)
    end
  end
end



EOF
