"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Maintainer:
"       Amir Salihefendic - @amix3k
"
" Awesome_version:
"       Get this config, nice color schemes and lots of plugins!
"
"       Install the awesome version from:
"
"           https://github.com/amix/vimrc
"
" Sections:
"    -> General
"    -> VIM user interface
"    -> Colors and Fonts
"    -> Files and backups
"    -> Text, tab and indent related
"    -> Visual mode related
"    -> Moving around, tabs and buffers
"    -> Status line
"    -> Editing mappings
"    -> vimgrep searching and cope displaying
"    -> Spell checking
"    -> Misc
"    -> Helper functions
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Sets how many lines of history VIM has to remember
set nocp
set history=500
set number
set mouse=a
set cursorline

" Change the cursor shape
 if !has("nvim")
   if &term != "linux"
       let &t_SI = "\<Esc>[6 q"
       let &t_SR = "\<Esc>[4 q"
       let &t_EI = "\<Esc>[2 q"
   endif
else
   set guicursor=n-v:block-Cursor/lCursor-blinkon0
   set guicursor+=i-ci-c:ver100-Cursor/lCursor-blinkon0
   set guicursor+=r-cr:hor100-Cursor/lCursor-blinkon0
endif

" Enable filetype plugins
filetype plugin on
filetype indent on
"
" " Set to auto read when a file is changed from the outside
set autoread
au FocusGained,BufEnter * silent! checktime
"
" " :W sudo saves the file
" " (useful for handling the permission-denied error)
command! W execute 'w !sudo tee % > /dev/null' <bar> edit!
"
"
" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" " => VIM user interface
" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" " Set 7 lines to the cursor - when moving vertically using j/k
set so=7
"
" " Avoid garbled characters in Chinese language windows OS
let $LANG='en'
set langmenu=en
" " Turn on the Wild menu
set wildmenu
"
" " Ignore compiled files
set wildignore=*.o,*~,*.pyc
if has("win16") || has("win32")
    set wildignore+=.git\*,.hg\*,.svn\*
else
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif
" " Always show current position
set ruler
" " Height of the command bar
set cmdheight=1
" " A buffer becomes hidden when it is abandoned
set hid
" " Configure backspace so it acts as it should act
" set backspace=eol,start,indent
" set whichwrap+=<,>,h,l
"
" " Ignore case when searching
set ignorecase
"
" " When searching try to be smart about cases
set smartcase
"
" " Highlight search results
set hlsearch
"
" " Makes search act like search in modern browsers
set incsearch
"
" " Don't redraw while executing macros (good performance config)
set lazyredraw
"
" " For regular expressions turn magic on
set magic
"
" " Show matching brackets when text indicator is over them
set showmatch
"
" " How many tenths of a second to blink when matching brackets
set mat=2
"
" " No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Properly disable sound on errors on MacVim
if has("gui_macvim")
    autocmd GUIEnter * set vb t_vb=
endif

" Add a bit extra margin to the left
set foldcolumn=1
"
"
" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" " => Colors and Fonts
" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" " Enable syntax highlighting
syntax enable
"
" " Set regular expression engine automatically
set regexpengine=0
"
" " Enable 256 colors palette in Gnome Terminal
if $COLORTERM == 'gnome-terminal'
    set t_Co=256
endif

try
    colorscheme desert
catch
endtry

set background=dark
"
" " Set extra options when running in GUI mode
if has("gui_running")
    set guioptions-=T
    set guioptions-=e
    set t_Co=256
    set guitablabel=%M\ %t
endif
"
" " Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8
"
" " Use Unix as the standard file type
set ffs=unix,dos,mac
"
"
" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" " => Files, backups and undo
" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" " Turn backup off, since most stuff is in SVN, git etc. anyway...
set nobackup
set nowb
set noswapfile


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" " Use spaces instead of tabs
set expandtab

" " Be smart when using tabs ;)
set smarttab
"
" " 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4
"
" " Linebreak on 500 characters
set lbr
set tw=500
"
set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines
"
"
" " Specify the behavior when switching between buffers
try
  set switchbuf=useopen,usetab,newtab
  set stal=2
catch
endtry
"
" " Return to last edit position when opening files (You want this!)
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
"
"
" """"""""""""""""""""""""""""""
" " => Status line
" """"""""""""""""""""""""""""""
" Always show the status line
set laststatus=2

" " Format the status line
"set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l\ \ Column:\ %c
"
"Delete trailing white space on save, useful for some filetypes ;)
fun! CleanExtraSpaces()
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    silent! %s/\s\+$//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)
endfun

if has("autocmd")
    autocmd BufWritePre *.txt,*.js,*.py,*.wiki,*.sh,*.coffee :call CleanExtraSpaces()
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    endif
    return ''
endfunction

" Don't close window, when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
    let l:currentBufNum = bufnr("%")
    let l:alternateBufNum = bufnr("#")

    if buflisted(l:alternateBufNum)
        buffer #
    else
        bnext
    endif

    if bufnr("%") == l:currentBufNum
        new
    endif

    if buflisted(l:currentBufNum)
        execute("bdelete! ".l:currentBufNum)
    endif
endfunction

function! CmdLine(str)
    call feedkeys(":" . a:str)
endfunction

function! VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", "\\/.*'$^~[]")
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'gv'
        call CmdLine("Ack '" . l:pattern . "' " )
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction
