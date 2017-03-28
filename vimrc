let g:nerdtree_tabs_autofind = 1
set nocompatible
set nu
set tw=0

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.

set bg=dark
colorscheme tory
let g:sequence='C'
if &t_Co > 2 || has("gui_running")
	syntax on
	set hlsearch
endif
if has("gui_running")
	set guifont=Droid\ Sans\ Mono:h10
	"set bg=light
	"colorscheme hemisu
	set foldcolumn=4
endif
if has("gui_macvim")
	let g:sequence='D'
	let macvim_hig_shift_movement = 1
	set transparency=7
endif

set showtabline=2
filetype plugin indent on

set termencoding=utf-8
" возможные кодировки файлов и последовательность определения.
set fileencodings=utf8,cp1251
set encoding=utf8
set smartindent
set fo+=cr
map <S-Insert> <MiddleMouse>
set bs=2  " allow backspacing over everything in insert mode
set ai  " always set autoindenting on

set nobackup  " do not keep a backup file, use versions instead
set noswapfile
set viminfo='20,\"50 " read/write a .viminfo file, don't store more
" than 50 lines of registers
set history=50  " keep 50 lines of command line history
set ruler  " show the cursor position all the time

runtime! ftplugin/man.vim

set showcmd

" Don't use Ex mode, use Q for formatting
map Q gq

" Make p in Visual mode replace the selected text with the "" register.
vnoremap p <Esc>:let current_reg=@"<CR>gv"_di<C-R>=current_reg<CR><Esc>

" Only do this part when compiled with support for autocommands.
if has("autocmd")
	" In text files, always limit the width of text to 78 characters
	autocmd BufEnter * lcd %:p:h
	au BufEnter,BufNewFile * exe ':call CommentCreate("#","#","#")'
	au BufEnter *.c,*.cpp,*.h,*.hpp,*.m,*.mm,*.js exe ':call CommentCreate("/*","*","*/")'
	au BufEnter .vimrc exe ':call CommentCreate("\"","\"","\"")'
	autocmd FileType * set formatoptions=tcql nocindent comments&
	autocmd BufNewFile *.pl,*.pm exe ':call CommentFileBegin()'
	autocmd BufNewFile *.pl,*.pm exe '1,13g/CREATED: .\{16}/s//CREATED: '.strftime("%d.%m.%Y %H:%M")
	autocmd BufNewFile *.pl,*.pm exe 'normal G'
	autocmd BufWritePre,FileWritePre *.pl,*.pm,*.js execute "normal ma"
	autocmd BufWritePre,FileWritePre *.pl,*.pm,*.js exe '1,13g/MODIFIED: .\{16}/s//MODIFIED: '.strftime("%d.%m.%Y %H:%M")
	autocmd BufWritePost,FileWritePost *.pl,*.pm,*.js execute 'normal `a'
endif " has("autocmd")

" Слова откуда будем завершать
set complete=""
" Из текущего буфера
set complete+=.
" Из словаря
set complete+=k
" из тегов 
set complete+=t

set completeopt-=preview
set completeopt+=longest
set mps-=[:]

set ts=3
set shiftwidth=3

set guioptions-=L

" открыть обозреватель
map <F4> :NERDTreeToggle<cr>
vmap <F4> <esc>:NERDTreeToggle<cr>
imap <F4> <esc>:NERDTreeToggle<cr>

" сохранить и выйти
map <F10> :wq<cr>
vmap <F10> <esc>:wq<cr>
imap <F10> <esc>:wq<cr>

" новая линия после курсора
exe 'map <'.g:sequence.'-CR> o'
exe 'vmap <'.g:sequence.'-CR> <esc>o'
exe 'imap <'.g:sequence.'-CR> <esc>o'

" новая линия до курсора
exe 'map  <'.g:sequence.'-S-CR> O'
exe 'vmap <'.g:sequence.'-S-CR> <esc>O'
exe 'imap <'.g:sequence.'-S-CR> <esc>O'

" копировать строку
exe 'map <'.g:sequence.'-y> yy'
exe 'vmap <'.g:sequence.'-y> <esc>yy'
exe 'imap <'.g:sequence.'-y> <esc>yy'
" копировать строку
exe 'map <'.g:sequence.'-d> "dyy"dp'
exe 'vmap <'.g:sequence.'-d> <esc>"dyy"dp'
exe 'imap <'.g:sequence.'-d> <esc>"dyy"dpi'

exe 'map <'.g:sequence.'-b> <C-w>gf'
exe 'vmap <'.g:sequence.'-b> <esc><C-w>gf'
exe 'imap <'.g:sequence.'-b> <esc><C-w>gf'

exe 'map <'.g:sequence.'-u> :call Upload()<cr>'
exe 'vmap <'.g:sequence.'-u> <esc>:call Upload()<cr>'
exe 'imap <'.g:sequence.'-u> <esc>:call Upload()<cr>'

nnoremap <C-DOWN> :m .+1<CR>==
nnoremap <C-UP> :m .-2<CR>==
inoremap <C-DOWN> <Esc>:m .+1<CR>==gi
inoremap <C-UP> <Esc>:m .-2<CR>==gi
vnoremap <C-DOWN> :m '>+1<CR>gv=gv
vnoremap <C-UP> :m '<-2<CR>gv=gv

" свернуть/развернуть группу
map <F8> za
vmap <F8> <esc>zai
imap <F8> <esc>zai

cmap w!! w !sudo tee > /dev/null %

function CommentCreate(c_start,c_inner,c_stop)
	let a:trim="\<esc>d".(100-strlen(a:c_stop))."|a".a:c_stop."\<esc>"
	if (strlen(a:c_stop)-1 > 0)
		let a:skip=(strlen(a:c_stop)-1)."h"
	else
		let a:skip=""
	endif
	let @h="o".a:c_start."\<esc>".(100-strlen(a:c_start.a:c_stop))."A".a:c_inner.a:trim
	let @b="$".a:skip."d".(101-strlen(a:c_stop))."|o".a:c_start."\<esc>100A ".a:trim."^5l"
endfunction

function CommentHeader()
	normal 2@hk@b
endfunction

function CommentBody()
	normal @b
endfunction

function CommentFileBegin()
	if (expand("%:e") == "pl")
		normal ggO#!/usr/bin/env perl
	elseif (expand("%:e") == "pm")
		normal ggO#
	endif
	normal 2@hk10@bjo
	exe "normal 4G13|RFILE: ".expand("%:t")
	normal 6G11|RAUTHOR: Denis Daschenko
	normal 7G10|RCREATED:
	normal 8G9|RMODIFIED:
	normal 11G6|RDESCRIPTION:
	normal 13Go
	if (expand("%:e") == "pl" || expand("%:e") == "pm")
		if (expand("%:e") == "pm")
			exe "normal opackage ".expand("%:t:r").";"
		endif
		normal ouse 5.10.0;
		normal ouse strict;
		normal ouse warnings;
		normal ono if $] >= 5.016, warnings => "experimental::smartmatch";
	endif
	normal 11gg19|
endfunction

exe 'map <'.g:sequence.'-1> :call CommentHeader()<cr>i'
exe 'imap <'.g:sequence.'-1> <esc>:call CommentHeader()<cr>i'

exe 'map <'.g:sequence.'-2> :call CommentBody()<cr>i'
exe 'imap <'.g:sequence.'-2> <esc>:call CommentBody()<cr>i'

" фолдинг
syn sync fromstart
set foldmethod=syntax " тип фолдинга
set foldnestmax=2 " максимальная вложенность фолдинга
let perl_fold=1
"let perl_fold_blocks=0
set foldlevelstart=1

" case intensirive
set ic
set scs

imap <tab> <c-r>=InsertTabWrapper()<cr>
nnoremap <Tab> >>_
nnoremap <S-Tab> <<_
inoremap <S-Tab> <C-D>
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv

imap <C-F> <C-X><C-O>
function InsertTabWrapper()
	let col = col('.') - 1
	if !col || getline('.')[col - 1] !~ '\k'
		return "\<tab>"
	else
		return "\<c-p>"
	endif
endfunction

function Upload()
	:!/bin/bash -c 'search=1; while [ "$search" = "1" ]; do [ -f .upload ] && unset search && bash $PWD/.upload || [ "$PWD" = "/" ] && unset search && echo ".upload is not found" || cd ..; done'
endfunction

map ё `
map й q
map ц w
map у e
map к r
map е t
map н y
map г u
map ш i
map щ o
map з p
map х [
map ъ ]
map ф a
map ы s
map в d
map а f
map п g
map р h
map о j
map л k
map д l
map ж ;
map э '
map я z
map ч x
map с c
map м v
map и b
map т n
map ь m
map б ,
map ю .
map Ё ~
map Й Q
map Ц W
map У E
map К R
map Е T
map Н Y
map Г U
map Ш I
map Щ O
map З P
map Х {
map Ъ }
map Ф A
map Ы S
map В D
map А F
map П G
map Р H
map О J
map Л K
map Д L
map Ж :
map Э "
map Я Z
map Ч X
map С C
map М V
map И B
map Т N
map Ь M
map Б <
map Ю >
