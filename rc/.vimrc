" ~tgyurci/.vimrc

" Options

"  1 important
set nocompatible
set pastetoggle=<F6>

"  2 moving around, searching and patterns
set noincsearch
set ignorecase
set smartcase

"  3 tags

"  4 displaying text
set nowrap
set showbreak=>
set display=lastline,uhex
if has('patch-7.4.710')
	set listchars=eol:¶,tab:»\ ,space:·,extends:>,precedes:<,nbsp:¬
else
	set listchars=eol:¶,tab:»\ ,extends:>,precedes:<,nbsp:¬
endif

"  5 syntax, highlighting and spelling
set background&
set nohlsearch

"  6 multiple windows

"  7 multiple tab pages

"  8 terminal
set title

"  9 using the mouse

" 10 printing

" 11 messages and info
set shortmess+=mI
set showcmd
set showmode
set ruler
set visualbell
if exists('&belloff')
	set belloff=all
endif

" 12 selecting text

" 13 editing text
set backspace=indent,eol,start

" 14 tabs and indenting
set tabstop=4
set shiftwidth=4

" 15 folding

" 16 diff mode

" 17 mapping
set ttimeoutlen=50

" 18 reading and writing files
set nomodeline
"set backupskip+=$HOME/.tmp/*
"set backupskip+=~/.tmp/*
let &backupskip = &backupskip . ',' . expand('$HOME') . '/.tmp/*'

" 19 the swap file
set updatetime=2000

" 20 command line editing
set wildmode=longest:full,full
set wildmenu

" 21 executing external commands

" 22 running make and jumping to errors
set grepprg=ag\ --vimgrep\ $*
set grepformat^=%f:%l:%c:%m

" 23 language specific
set isfname+=@-@
set keymap=magyar
set iminsert=0
set imsearch=-1

" 24 multi-byte characters

" 25 various
set viminfofile=NONE

" 99 terminal settings
"set t_Co=256
set t_vb=

if &term == "screen" || &term =~ "^screen-"
	set t_ts=_
	set t_fs=\
endif

" Variables

let g:loaded_2html_plugin = 0
let g:loaded_getscriptPlugin = 0
let g:loaded_vimballPlugin = 0
let g:netrw_dirhistmax = 0

" Filetype detection

filetype on

" Syntax highlighting

syntax enable

if &t_Co == 256
	highlight CursorLineNr cterm=bold
	highlight Statement ctermfg=3
endif

highlight CursorLine cterm=NONE ctermbg=LightGray
highlight ExtraWhiteSpace ctermbg=LightGray
highlight NonText ctermfg=Gray
highlight Special ctermfg=92
highlight SpecialKey ctermfg=Gray
highlight Title cterm=bold

"colorscheme default

" Autocommands

augroup vimrc_filetypedetect
	autocmd!

augroup END

augroup vimrc_filetypeplugin
	autocmd!

	" BSD periodic scripts
	autocmd BufRead /etc/periodic/** setlocal tabstop=8 shiftwidth=8

	" Default C include headers
	autocmd BufRead */usr/include/** setlocal tabstop=8 shiftwidth=8

	" Vim runtime scripts
	autocmd BufRead $VIMRUNTIME/*/*.vim setlocal tabstop=8 shiftwidth=8
augroup END

augroup vimrc_securefile
	autocmd!

	autocmd BufNewFile,BufReadPre /tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,$HOME/.tmp/*
		\ setlocal noswapfile | setlocal noundofile
augroup END

augroup vimrc_logfile
	autocmd!

	autocmd BufRead /var/log/* setlocal buftype=nowrite
augroup END

augroup vimrc_cmdwin
	autocmd!

	" Start insert mode in Command-line window
	autocmd CmdwinEnter * startinsert
augroup END

if filereadable(expand('~/.vim/vimrc.local'))
	source ~/.vim/vimrc.local
endif

if filereadable(expand('~/.vimrc.local'))
	source ~/.vimrc.local
endif
