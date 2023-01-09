set nocompatible              " be iMproved, required

" Install vim-plug if not found
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

call plug#begin('~/.vim/plugged')

" GitHub repo
Plug 'tpope/vim-fugitive'
Plug 'mhinz/vim-signify'

" ui colors and themes
Plug 'flazz/vim-colorschemes'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'edkolev/tmuxline.vim'

" Nerd fonts
Plug 'ryanoasis/vim-devicons'

" Integrations
Plug 'airblade/vim-gitgutter'
Plug 'vwxyutarooo/nerdtree-devicons-syntax'

" Where am i
Plug 'preservim/nerdtree' | Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'majutsushi/tagbar'
Plug 'ctrlpvim/ctrlp.vim'
"  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }

" Syntax
Plug 'scrooloose/syntastic'
Plug 'yggdroot/indentline'
Plug 'godlygeek/tabular'
Plug 'chrisbra/csv.vim'
Plug 'elzr/vim-json'
Plug 'ntpeters/vim-better-whitespace'
Plug 'plasticboy/vim-markdown'
Plug 'cespare/vim-toml'
Plug 'kevinoid/vim-jsonc'

if has('nvim')
  " lspconfig
  Plug 'neovim/nvim-lspconfig'
  " coc-config
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
endif

" All of your Plugins must be added before the following line
call plug#end()

let g:indentLine_char_list = ['|', '¦', '┆', '┊']
let g:indentLine_setColors = 1
let g:indentLine_defaultGroup = 'SpecialKey'

syntax on           " always show syntax
set number              " show line numbers
set wrap                " wrap lines
set encoding=utf-8      " set encoding to UTF-8 (default was latin1)
set hidden
set mouse=a             " enable mouse support (might not work well on Mac OS X)
set wildmenu            " visual autocomplete for command menu
"set lazyredraw          " redraw screen only when we need to
set showmatch           " highlight matching parentheses / brackets [{()}]
set cursorline          " highlight current line
set laststatus=2
set background=dark     " dark variant of the theme
set t_Co=256            " true colors
set ttimeoutlen=50      " eliminate insert pause
set updatetime=100      " async update time
set autochdir     " auto switch directory to the current file
set tabstop=2     " (ts) width (in spaces) that a <tab> is displayed as
set expandtab     " (et) expand tabs to spaces (use :retab to redo entire file)
set shiftwidth=2  " (sw) width (in spaces) used in each step of autoindent (aswell as << and >>)

" a marker line at 120 chars
"set colorcolumn=+2,120
"highlight ColorColumn term=reverse guibg=#202020 ctermbg=233

" Set your own guifont
if has('gui_running')
  set guioptions-=T  " no toolbar
  set lines=80 columns=120 linespace=0
  if has('gui_win32')
    set guifont=Fira_Code_Retina_Nerd_Font_Complete_Mono:h12:cANSI
  else
    set guifont=Fira_Code_Retina_Nerd_Font_Complete:h12
  endif
endif

let g:airline_theme = 'jellybeans'
colorscheme jellybeans

let g:airline_powerline_fonts = 1
let g:airline_mode_map = {
      \ '__'     : '-',
      \ 'c'      : 'C',
      \ 'i'      : 'I',
      \ 'ic'     : 'I',
      \ 'ix'     : 'I',
      \ 'n'      : 'N',
      \ 'multi'  : 'M',
      \ 'ni'     : 'N',
      \ 'no'     : 'N',
      \ 'R'      : 'R',
      \ 'Rv'     : 'R',
      \ 's'      : 'S',
      \ 'S'      : 'S',
      \ ''     : 'S',
      \ 't'      : 'T',
      \ 'v'      : 'V',
      \ 'V'      : 'V',
      \ ''     : 'V',
      \ }

let g:airline_highlighting_cache = 1
"let g:airline_focuslost_inactive = 1
"let g:airline_statusline_ontop = 1
let g:airline_stl_path_style = 'short'
let g:airline_skip_empty_sections = 1

" https://github.com/vim-airline/vim-airline/blob/master/doc/airline.txt
let g:airline#extensions#battery#enabled = 1
let g:airline#extensions#branch#vcs_checks = ['untracked', 'dirty']
let g:airline#extensions#csv#enabled = 1
let g:airline#extensions#csv#column_display = 'Name'
let g:airline#extensions#cursormode#enabled = 1
let g:cursormode_color_map = {
\ "nlight": '#000000',
\ "ndark": '#BBBBBB',
\ "i": g:airline#themes#{g:airline_theme}#palette.insert.airline_a[1],
\ "R": g:airline#themes#{g:airline_theme}#palette.replace.airline_a[1],
\ "v": g:airline#themes#{g:airline_theme}#palette.visual.airline_a[1],
\ "V": g:airline#themes#{g:airline_theme}#palette.visual.airline_a[1],
\ "\<C-V>": g:airline#themes#{g:airline_theme}#palette.visual.airline_a[1],
\ }
let g:airline#extensions#hunks#enabled = 1
let g:airline#extensions#hunks#non_zero_only = 1
let g:airline#extensions#nerdtree_statusline = 1
let g:airline#extensions#quickfix#quickfix_text = 'Quickfix'
let g:airline#extensions#quickfix#location_text = 'Location'
let g:airline#extensions#searchcount#enabled = 1
let g:airline#extensions#syntastic#enabled = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline#extensions#tabline#alt_sep = 1
let g:airline#extensions#tabline#show_tabs = 1
let g:airline#extensions#tagbar#enabled = 1
let g:airline#extensions#tmuxline#enabled = 0
let g:airline#extensions#whitespace#enabled = 1

" rounded separators (extra-powerline-symbols):
let g:airline_left_sep = "\uE0B4"
let g:airline_right_sep = "\uE0B6"

" tmux is set to airline
let g:tmuxline = 'airline'

let g:gitgutter_set_sign_backgrounds = 1
highlight GitGutterAdd    guifg=#009900 ctermfg=2
highlight GitGutterChange guifg=#bbbb00 ctermfg=3
highlight GitGutterDelete guifg=#ff2222 ctermfg=1
highlight link GitGutterAddLine    NONE
highlight link GitGutterChangeLine NONE
highlight link GitGutterDeleteLine NONE
let g:gitgutter_diff_args = '-w'
let g:gitgutter_highlight_linenrs = 1
let g:gitgutter_async = 1
let g:gitgutter_highlight_lines = 1
let g:gitgutter_map_keys = 0
let g:gitgutter_sign_allow_clobber = 1
autocmd BufWritePost * GitGutter

let g:better_whitespace_enabled=1
let g:strip_whitespace_on_save=1
let g:current_line_whitespace_disabled_soft=1
let g:show_spaces_that_precede_tabs=1

nmap <F8> :TagbarToggle<CR>

let g:vim_markdown_folding_disabled = 1
set nofoldenable

" Start NERDTree. If a file is specified, move the cursor to its window.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * NERDTree | if argc() > 0 || exists("s:std_in") | wincmd p | endif
" Open the existing NERDTree on each new tab.
autocmd BufWinEnter * silent NERDTreeMirror
nnoremap <F10> :NERDTreeFocus<CR>
"nnoremap <C-t> :NERDTree<CR>
"nnoremap <C-t> :NERDTreeToggle<CR>
"nnoremap <C-f> :NERDTreeFind<CR>
" Exit Vim if NERDTree is the only window left.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() |
    \ quit | endif
let g:NERDTreeGitStatusUseNerdFonts = 1
let g:NERDTreeGitStatusShowClean = 0
let g:NERDTreeGitStatusConcealBrackets = 0
let g:WebDevIconsNerdTreeGitPluginForceVAlign = 1
let g:NERDTreeShowHidden=1


"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*
"let g:syntastic_python_checkers = ["mypy","flake8"]
let g:syntastic_aggregate_errors = 1
let g:syntastic_always_populate_loc_list = 0
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif


" coc extensions
let g:coc_global_extensions = ['coc-git', 'coc-tsserver', 'coc-markdownlint' ]

" coc-configuration
" https://github.com/neoclide/coc.nvim

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

if has("nvim")
  " Highlight the symbol and its references when holding the cursor.
  autocmd CursorHold * silent call CocActionAsync('highlight')
endif
" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>
