set ignorecase smartcase
set modeline
set wildmenu
set number
set tabstop=4 softtabstop=4 shiftwidth=4 expandtab
set autoindent
set wrap
set smarttab
set showmatch
set matchtime=5
set hlsearch
set incsearch
set list
set listchars=tab:\|\ ,trail:.,extends:>,precedes:<
set splitbelow
set splitright

" airline
set laststatus=2

" syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" phpcomplete
let g:phpcomplete_parse_docblock_comments = 1

" PHP settings
autocmd FileType php setlocal cindent|set cinkeys-=0#
autocmd FileType php setlocal comments=s1:/*,mb:*,ex:*/,://,:#
autocmd FileType php setlocal formatoptions+=cro
autocmd FileType php setlocal iskeyword-=$
autocmd FileType php let b:surround_45 = "<?php \r ?>"
autocmd FileType php let b:surround_61 = "<?= \r ?>"

let g:surround_indent = 0
let g:miniBufExplTabWrap = 1
let g:miniBufExplModSelTarget = 1
let g:miniBufExplCycleArround = 1
let g:tagbar_phpctags_bin='~/.vim/bundle/tagbar-phpctags/bin/phpctags'
let g:tagbar_autofocus = 1
let g:tagbar_autoclose = 1
let g:tagbar_sort = 0
let g:tagbar_iconchars = ['+', '-']
let b:match_ignorecase = 1
let php_sql_query = 1
let php_htmlInStrings = 1
let php_baselib = 1
let php_asp_tags = 0
let php_parent_error_close = 1
let php_parent_error_open = 1
let php_no_shorttags = 1
let php_folding = 0
let php_sync_method = 0

let g:viewdoc_open = 'new'
let g:viewdoc_openempty = 0
cnoreabbrev <expr> h ((getcmdtype() is# ':' && getcmdline() is# 'h')?('ViewDocHelp!'):('h'))

" enable syntax highlighting
syntax on

" shortcuts
let g:SuperTabDefaultCompletionType = "<c-x><c-o>" " <TAB> for autocomplete
