scriptencoding utf-8

if has('unix')
  let s:uname = system('uname')
  let g:python_host_prog='/usr/bin/python'
  let g:python3_host_prog='/usr/bin/python3'
  if s:uname == "Darwin\n"
    let g:python_host_prog='/usr/local/bin/python2'
    let g:python3_host_prog='/usr/local/bin/python3'
  endif
endif

set nocompatible

" change <leader>
let mapleader=","
let maplocalleader = "\\"

filetype off

if has('win32') || has('win64')
  set rtp+=~/vimfiles/bundle/vundle.vim/
  call vundle#begin('$HOME/vimfiles/bundle/')
else
  " Usual quickstart instructions
  set rtp+=~/.vim/bundle/vundle.vim/
  call vundle#begin()
endif

Plugin 'VundleVim/Vundle.vim'
Plugin 'itchyny/lightline.vim'
Plugin 'sheerun/vim-polyglot'
Plugin 'hail2u/vim-css3-syntax'
Plugin 'ap/vim-css-color'
Plugin 'Raimondi/delimitMate'
Plugin 'tpope/vim-fugitive'
Plugin 'airblade/vim-gitgutter'
Plugin 'w0rp/ale'
Plugin 'nathanaelkane/vim-indent-guides'
Plugin 'altercation/vim-colors-solarized'
Plugin 'docunext/closetag.vim'
Plugin 'vim-scripts/supertab'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'tpope/vim-endwise'
Plugin 'tpope/vim-sleuth'
Plugin 'tpope/vim-classpath'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-rhubarb'
Plugin 'tpope/vim-projectionist'
Plugin 'tpope/vim-dispatch'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-eunuch'
Plugin 'tpope/vim-fireplace', { 'for': ['clj','cljs','cljx','clojure'] }
Plugin 'tpope/vim-salve', { 'for': ['clj', 'cljs', 'cljx', 'clojure'] }
Plugin 'guns/vim-sexp', { 'for': ['clj', 'cljs', 'cljx', 'clojure'] }
Plugin 'tpope/vim-sexp-mappings-for-regular-people', { 'for': ['clj', 'cljs', 'cljx', 'clojure'] }
Plugin 'kien/rainbow_parentheses.vim', { 'for': ['clj','cljs','cljx','clojure'] }
Plugin 'jpalardy/vim-slime'
Plugin 'mileszs/ack.vim'
Plugin 'tpope/vim-obsession'
Plugin 'tpope/vim-unimpaired'
Plugin 'scrooloose/nerdtree'
Plugin 'Xuyuanp/nerdtree-git-plugin'

call vundle#end()

filetype plugin indent on

syntax on

map <Leader>v :NERDTreeToggle<cr>
let NERDTreeShowHidden=1 "Show hidden files in nerd tree
let NERDTreeIgnore = ['.DS_Store']

if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

let g:slime_target = "tmux"

" Parentheses colors using Solarized
let g:rbpt_colorpairs = [
      \ [ '13', '#6c71c4'],
      \ [ '5',  '#d33682'],
      \ [ '1',  '#dc322f'],
      \ [ '9',  '#cb4b16'],
      \ [ '3',  '#b58900'],
      \ [ '2',  '#859900'],
      \ [ '6',  '#2aa198'],
      \ [ '4',  '#268bd2'],
      \ ]

let g:solarized_visibility="normal"

" Enable rainbow parentheses for all buffers
augroup rainbow_parentheses
  au!
  au VimEnter * RainbowParenthesesActivate
  au BufEnter * RainbowParenthesesLoadRound
  au BufEnter * RainbowParenthesesLoadSquare
  au BufEnter * RainbowParenthesesLoadBraces
augroup END

" Set up CTRL P
" First set up patterns to ignore
set wildignore+=*/tmp/*,*.so,*/node_modules,*.swp,*.zip     " MacOSX/Linux

if exists("g:ctrlp_user_command")
  unlet g:ctrlp_user_command
endif

if executable('ag')
  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command =
        \ 'ag %s --files-with-matches -g "" --ignore "\.git$\|\.hg$\|\.svn$"'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
else
  " Fall back to using git ls-files if Ag is not available
  let g:ctrlp_custom_ignore = '\.git$\|\.hg$\|\.svn$'
  let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files . --cached --exclude-standard --others']
endif

" Default to filename searches - so that appctrl will find application
" controller
let g:ctrlp_by_filename = 1

" Don't jump to already open window. This is annoying if you are maintaining
" several Tab workspaces and want to open two windows into the same file.
let g:ctrlp_switch_buffer = 0

" ALE
let g:ale_sign_warning = '▲'
let g:ale_sign_error = '✗'
highlight link ALEWarningSign String
highlight link ALEErrorSign Title

" Lightline
let g:lightline = {
      \ 'colorscheme': 'solarized',
      \ 'active': {
      \   'left': [['mode', 'paste'], ['filename', 'modified']],
      \   'right': [['lineinfo'], ['percent'], ['readonly', 'linter_warnings', 'linter_errors', 'linter_ok']]
      \ },
      \ 'component_expand': {
      \   'linter_warnings': 'LightlineLinterWarnings',
      \   'linter_errors': 'LightlineLinterErrors',
      \   'linter_ok': 'LightlineLinterOK'
      \ },
      \ 'component_type': {
      \   'readonly': 'error',
      \   'linter_warnings': 'warning',
      \   'linter_errors': 'error',
      \   'linter_ok': 'ok'
      \ },
      \ }

function! LightlineLinterWarnings() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? '' : printf('%d ◆', all_non_errors)
endfunction

function! LightlineLinterErrors() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? '' : printf('%d ✗', all_errors)
endfunction

function! LightlineLinterOK() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? '✓ ' : ''
endfunction

" Update and show lightline but only if it's visible
autocmd User ALELint call s:MaybeUpdateLightline()

function! s:MaybeUpdateLightline()
  if exists('#lightline')
    call lightline#update()
  end
endfunction

if has("gui_running")
  set guioptions-=m
  set guioptions-=T
  if has('win32') || has('win64')
    set guifont=Consolas:h11:cDEFAULT
  else
    " set guifont=Source\ Code\ Pro\ for\ Powerline:h14
    set guifont=Inconsolata:h14
  endif
  set background=light
  set lines=40                " 40 lines of text instead of 24,
else
  set background=dark
  if !has('win32') && !has('win64') && !has('nvim')
    set term=builtin_ansi       " Make arrow and other keys work\
  endif
endif

" Define color scheme
colorscheme solarized

" always show what mode we're currently editing in
set showmode

" don't wrap lines
set nowrap

" delimitMate
imap <C-c> <CR><Esc>O

" Improve the backspace key
set backspace=indent,eol,start

" Disable the backup files
set nobackup

" Disable the swap files.
set noswapfile
set nowb

" Make <C-A> and <C-X> increment and decrement all numbers as decimals.
set nrformats=

" do not enable folding
set nofoldenable

" 10 nested fold max
set foldnestmax=10

" fold based on indent level
set foldmethod=indent

" Enable the tab complete menu.
set wildmenu

" show command in last line
set showcmd

" show line and column number
set ruler

" Always display the status line, even if only one window is displayed
set laststatus=2

" move vertically by visual line
vnoremap j gj
vnoremap k gk
nnoremap j gj
nnoremap k gk

" define Y like D
nmap Y y$

" disable arrows keys in normal mode
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
" disable arrows keys in insert mode
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>
" disable arrows keys in visual mode
vnoremap <up> <nop>
vnoremap <down> <nop>
vnoremap <left> <nop>
vnoremap <right> <nop>

" Increase the command line history length.
set history=1000

" Corrects the spelling under the cursor with the first suggestion.
nnoremap <leader>z 1z=

" Shows the amount of matches for the previous search. (/)
nnoremap <leader>/ :%s///gn<CR>

" Strips the trailing white space from the file.
nnoremap <leader>w :%s/\s\+$//e<CR>

" Opens the split in a new tab. Kind like "distraction free" mode. (f)
nnoremap <leader>f :tab sp<CR>

" Show the file name in the window title bar.
set title

" Enable line numbers.
set number
set relativenumber

" Show invisible characters.
set listchars=tab:?\ ,trail:�
set list

" Searching
"  Highlight searches.
set hlsearch
"  Ignore case of searches.
set ignorecase
"  If the search contains an upper-case character, become case sensitive.
set smartcase
"  Highlight dynamically as pattern is typed.
set incsearch
"  Clears the search. (c)
nnoremap <silent> <leader>c/ :nohlsearch<CR>
"  Show matching brackets and parens
set showmatch

" Set the default encoding to UTF-8.
set encoding=utf-8

" Configure the spelling language and file.
set spelllang=en_us
if has('win32') || has('win64')
  set spellfile=$HOME/vimfiles/spell/en.utf-8.add
else
  set spellfile=$HOME/.vim/spell/en.utf-8.add
endif
set spell

" Disable error bells.
set noerrorbells visualbell t_vb=
augroup GUIBell
  autocmd!
  autocmd GUIEnter * set visualbell t_vb=
augroup END

" Quickly time out on keycodes, but never time out on mappings
set notimeout ttimeout ttimeoutlen=200

" Don't reset cursor to start of line when moving around.
set nostartofline

" Don't show the intro message when starting vim.
set shortmess=atI

" Disable the extra line at the end of files.
set binary
set noeol

" Start scrolling three lines before the horizontal window border.
set scrolloff=3

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \   exe "normal! g`\"" |
      \ endif

" Remember info about open buffers on close
set viminfo^=%

" Enable better indentation.
set autoindent smartindent
set smarttab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
let g:html_indent_inctags='html,body,head,tbody'

let g:indent_guides_enable_on_vim_startup = 1
let indent_guides_guide_size = 1
let indent_guides_start_level = 2
" Fix indent guide colors to use solarized colors
" https://github.com/nathanaelkane/vim-indent-guides#setting-custom-indent-colors
" For 16 colors term bg colors, base03 => 8, base02 => 0, base01 => 10
let g:indent_guides_auto_colors = 0
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=#073642 ctermbg=236
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=#073642 ctermbg=237

if exists('+colorcolumn')
  set colorcolumn=80
else
  au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)
endif

" Window Manipulation
" -------------------
" Note to self:
" :resize will resize a horizontal split, *and* you can give it
" relative lines, like :resize +5 or :resize -5
" :vertical resize can be used for vertical splits.

" remap window switching to leader then navigation letter
nnoremap <Leader>j <C-W><C-J>
nnoremap <Leader>k <C-W><C-K>
nnoremap <Leader>l <C-W><C-L>
nnoremap <Leader>h <C-W><C-H>

" remap window equal resizing to leader equals
nnoremap <Leader>= <C-W><C-=>

" when opening horizontal splits, place cursor in new split
set splitbelow

" when opening vertical splits, place cursor in new split
set splitright

" Stupid shift key fixes
cmap W w
cmap WQ wq
cmap wQ wq
cmap Q q

augroup vimrc_autocmds
  autocmd BufEnter * set tw=0
  autocmd BufEnter * set fo=cq
  autocmd BufEnter * set wm=0
augroup END

" vim-polyglot's cofffee file type detection doesn't work quite right
autocmd BufNewFile,BufRead *.js.coffee set filetype=coffee

" shell (tab width 2 chr)
autocmd FileType sh set sw=2
autocmd FileType sh set ts=2
autocmd FileType sh set sts=2
" ruby (tab width 2 chr)
autocmd FileType ruby set sw=2
autocmd FileType ruby set ts=2
autocmd FileType ruby set sts=2
" HTML (tab width 2 chr, no wrapping)
autocmd FileType html set sw=2
autocmd FileType html set ts=2
autocmd FileType html set sts=2
autocmd FileType html set textwidth=0
" Python (tab width 4 chr)
autocmd FileType python set sw=4
autocmd FileType python set ts=4
autocmd FileType python set sts=4
" CSS (tab width 2 chr)
autocmd FileType css set sw=2
autocmd FileType css set ts=2
autocmd FileType css set sts=2
" JavaScript (tab width 2 chr)
autocmd FileType javascript set sw=2
autocmd FileType javascript set ts=2
autocmd FileType javascript set sts=2
" JavaScript JSX (tab width 2 chr)
autocmd FileType javascript.jsx set sw=2
autocmd FileType javascript.jsx set ts=2
autocmd FileType javascript.jsx set sts=2
" CoffeeScript
au BufNewFile,BufReadPost *.coffee setl foldmethod=indent nofoldenable
au BufNewFile,BufReadPost *.coffee setl shiftwidth=2 expandtab
" Markdown (tab width 2 chr, wrapping at 80)
autocmd FileType markdown setlocal wrap
autocmd FileType markdown set sw=2
autocmd FileType markdown set ts=2
autocmd FileType markdown set sts=2
autocmd FileType markdown set textwidth=80

" Set Vim Clipboard to System
set clipboard=unnamed

command FormatJSON %!python -m json.tool
