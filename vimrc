scriptencoding utf-8
set encoding=utf-8

set nocompatible
filetype off

if has('win32') || has('win64')
  set rtp+=~/vimfiles/bundle/vundle/
  call vundle#rc('$HOME/vimfiles/bundle/')
else
  " Usual quickstart instructions
  set rtp+=~/.vim/bundle/vundle/
  call vundle#rc()
endif

Plugin 'gmarik/vundle'
Plugin 'Raimondi/delimitMate'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-rails'
Plugin 'moll/vim-node'
Plugin 'digitaltoad/vim-jade'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/nerdcommenter'
Plugin 'scrooloose/syntastic'
Plugin 'jelera/vim-javascript-syntax'
Plugin 'pangloss/vim-javascript'
Plugin 'nathanaelkane/vim-indent-guides'
Plugin 'altercation/vim-colors-solarized'
Plugin 'marijnh/tern_for_vim'
Plugin 'docunext/closetag.vim'
Plugin 'vim-scripts/supertab'
Plugin 'PProvost/vim-ps1'
Plugin 'fatih/vim-go.git'

let g:go_disable_autoinstall = 1

" This does what it says on the tin. It will check your file on open too, not just on save.
" You might not want this, so just leave it out if you don't.
let g:syntastic_check_on_open=1

filetype plugin on
filetype indent on
syntax on
color solarized

if has("gui_running")
    set guioptions-=m
    set guioptions-=T
    set guifont=Consolas:h11:cDEFAULT
    set background=light
    set lines=40                " 40 lines of text instead of 24,
else
    set background=dark
    set term=builtin_ansi       " Make arrow and other keys work
endif

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

" Increase the command line history length.
set history=1000

" Set the local leader.
let maplocalleader = "|"

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
set listchars=tab:?\ ,trail:·
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

" from https://github.com/spf13/spf13-vim/blob/master/.vimrc
if has('statusline')
    set laststatus=2
    " Broken down into easily includeable segments
    set statusline=%<%f\    " Filename
    set statusline+=%w%h%m%r " Options
    set statusline+=%{fugitive#statusline()} "  Git Hotness
    set statusline+=\ [%{&ff}/%Y]            " filetype
    set statusline+=\ [%{getcwd()}]          " current dir
    set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " Right aligned file nav info
endif

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

