"" CUSTOM VIM CONFIG
set term=xterm-256color

""_______________________

"" General
set number relativenumber " Show hybrid line numbers
set wrap
set wrapmargin=0
set linebreak       " Break lines at word (requires Wrap lines)
set showbreak=+++   " Wrap-broken line prefix
set textwidth=0     " Line wrap (number of cols)
set showmatch       " Highlight matching brace
set errorbells      " Beep or flash screen on errors

set hlsearch        " Highlight all search results
set smartcase       " Enable smart-case search
set ignorecase      " Always case-insensitive
set incsearch       " Searches for strings incrementally

set autoindent            " Auto-indent new lines
set shiftwidth=2          " Number of auto-indent spaces
set smartindent           " Enable smart-indent
set smarttab              " Enable smart-tabs
set softtabstop=0	        " Number of spaces per tab
set tabstop=2 expandtab   " For spaces instead of tabs

"" Advanced
set ruler	        " Show row and column ruler information
set undolevels=1000               " Number of undo levels
set backspace=indent,eol,start    " Backspace behaviour

"" Other custom settings...
if has("clipboard")
    set clipboard=unnamed   " Use system clipboard by default

    if has ("unnamedplus")  " X11 support
	set clipboard+=unnamedplus
    endif
endif
