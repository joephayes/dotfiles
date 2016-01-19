scriptencoding utf-8
set encoding=utf-8

set nocompatible
filetype off

if has('win32') || has('win64')
  set rtp+=~/vimfiles/bundle/vundle.vim/
  call vundle#begin('$HOME/vimfiles/bundle/')
else
  " Usual quickstart instructions
  set rtp+=~/.vim/bundle/vundle.vim/
  call vundle#begin()
endif

Plugin 'bling/vim-airline'
Plugin 'Raimondi/delimitMate'
Plugin 'othree/html5.vim'
Plugin 'elzr/vim-json'
Plugin 'burnettk/vim-angular'
Plugin 'pangloss/vim-javascript'
Plugin 'othree/javascript-libraries-syntax.vim'
Plugin 'claco/jasmine.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'moll/vim-node'
Plugin 'hail2u/vim-css3-syntax'
Plugin 'groenewege/vim-less'
Plugin 'digitaltoad/vim-jade'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/nerdcommenter'
Plugin 'scrooloose/syntastic'
Plugin 'nathanaelkane/vim-indent-guides'
Plugin 'altercation/vim-colors-solarized'
Plugin 'ternjs/tern_for_vim'
Plugin 'docunext/closetag.vim'
Plugin 'vim-scripts/supertab'
Plugin 'kien/ctrlp.vim'

call vundle#end()

" Set up CTRL P {{{
" First set up patterns to ignore
set wildignore+=*/tmp/*,*.so,*/node_modules,*.swp,*.zip     " MacOSX/Linux
let g:ctrlp_map = '<c-p>'
" Open CTRL+P to search MRU (most recently used), files and buffers
let g:ctrlp_cmd = 'CtrlPMixed'
let g:ctrlp_working_path_mode = ''
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
" Make CTRL+P only look for filenames by default
let g:ctrlp_by_filename = '1'

"""""""""  CTRL+P Mappings """""""""
" Make CTRL+B open buffers
nnoremap <C-b> :CtrlPBuffer<CR>
" Make CTRL+F open Most Recently Used files
nnoremap <C-f> :CtrlPMRU<CR>
" }}}
"
" Airline {{{
" Make sure powerline fonts are used
let g:airline_powerline_fonts = 1
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_symbols.space = "\ua0"
let g:airline_theme="badwolf"
let g:airline#extensions#tabline#enabled = 1 "enable the tabline
let g:airline#extensions#tabline#fnamemod = ':t' " show just the filename of buffers in the tab line
let g:airline_detect_modified=1
let g:airline#extensions#bufferline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
set laststatus=2
" }}}
"
" This does what it says on the tin. It will check your file on open too, not just on save.
" You might not want this, so just leave it out if you don't.
let g:syntastic_check_on_open=1

" angular.vim
let g:angular_skip_alternate_mappings=1
let g:angular_find_ignore=['dist/', 'data/']

filetype plugin indent on
syntax on

if has("gui_running")
    set guioptions-=m
    set guioptions-=T
    "set guifont=Consolas:h11:cDEFAULT
    set guifont=Source\ Code\ Pro\ for\ Powerline:h14
    set background=light
    set lines=40                " 40 lines of text instead of 24,
else
    set background=dark
    if !has('win32') && !has('win64') && !has('nvim')
        set term=builtin_ansi       " Make arrow and other keys work\
    endif
endif

color solarized

" delimitMate
imap <C-c> <CR><Esc>O

" NERDTree
autocmd VimEnter * nmap <F3> :NERDTreeToggle<CR>
autocmd VimEnter * imap <F3> <Esc>:NERDTreeToggle<CR>a

" Improve the backspace key
set backspace=indent,eol,start

" Disable the backup files
set nobackup

" Disable the swap files.
set noswapfile

" Make <C-A> and <C-X> increment and decrement all numbers as decimals.
set nrformats=

" Disabled code folding. It can be weird sometimes.
set nofoldenable

" Enable the tab complete menu.
set wildmenu

"set lazyredraw

set showmatch
set showcmd

" Increase the command line history length.
set history=1000

" change <leader> to a comma
let mapleader=","

" Clears the search. (c)
nnoremap <silent> <leader>c/ :nohlsearch<CR>

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

" Show invisible characters.
set listchars=tab:?\ ,trail:�
set list
 
" Highlight searches.
set hlsearch

" Ignore case of searches.
set ignorecase

" If the search contains an upper-case character, become case sensitive.
set smartcase

" Highlight dynamically as pattern is typed.
set incsearch

" Set the default encoding to UTF-8.
set enc=utf-8

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

" Improve the speed for updating the status line when leaving insert mode.
set ttimeoutlen=10
augroup FastEscape
  autocmd!
  autocmd InsertEnter * set timeoutlen=0
  autocmd InsertLeave * set timeoutlen=1000
augroup END

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

"***Language specified***
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
" JavaScript (tab width 4 chr)
autocmd FileType javascript set sw=4
autocmd FileType javascript set ts=4
autocmd FileType javascript set sts=4
" CoffeeScript
au BufNewFile,BufReadPost *.coffee setl foldmethod=indent nofoldenable
au BufNewFile,BufReadPost *.coffee setl shiftwidth=2 expandtab
