" ============================================
" General Settings
" ============================================

set nocompatible              " Use Vim defaults instead of Vi
set encoding=utf-8            " UTF-8 encoding
set fileencoding=utf-8
set history=1000              " Command history
set undolevels=1000           " Undo history

" ============================================
" UI / Display
" ============================================

syntax on                     " Syntax highlighting
set number                    " Show line numbers
set relativenumber            " Relative line numbers
set cursorline                " Highlight current line
set showmatch                 " Highlight matching brackets
set showcmd                   " Show incomplete commands
set wildmenu                  " Visual autocomplete for command menu
set laststatus=2              " Always show status line
set ruler                     " Show cursor position
set scrolloff=8               " Keep 8 lines above/below cursor
set signcolumn=yes            " Always show sign column

" ============================================
" Indentation
" ============================================

set autoindent                " Copy indent from current line
set smartindent               " Smart autoindenting
set expandtab                 " Use spaces instead of tabs
set tabstop=2                 " Tab width
set shiftwidth=2              " Indent width
set softtabstop=2             " Backspace through spaces
filetype plugin indent on     " Filetype-specific indentation

" ============================================
" Search
" ============================================

set incsearch                 " Incremental search
set hlsearch                  " Highlight search results
set ignorecase                " Case insensitive search
set smartcase                 " Case sensitive if uppercase used

" ============================================
" Editing
" ============================================

set backspace=indent,eol,start " Backspace through anything
set clipboard=unnamed          " Use system clipboard
set nowrap                     " Don't wrap lines
set mouse=a                    " Enable mouse support

" ============================================
" Performance
" ============================================

set lazyredraw                " Don't redraw during macros
set ttyfast                   " Fast terminal connection

" ============================================
" Files
" ============================================

set nobackup                  " Don't create backup files
set nowritebackup
set noswapfile                " Don't create swap files
set autoread                  " Auto reload changed files

" ============================================
" Key Mappings
" ============================================

" Set leader key to space
let mapleader = " "

" Clear search highlights
nnoremap <leader><space> :nohlsearch<CR>

" Quick save and quit
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>

" Move between splits
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Move lines up and down in visual mode
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" Keep cursor centered when scrolling
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz

" Keep search results centered
nnoremap n nzzzv
nnoremap N Nzzzv
