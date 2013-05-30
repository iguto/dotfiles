"行番号の表示
set number
"タブ幅の設定
set tabstop=2	    " ファイル内のtabの空白数
set softtabstop=2  " タブやBSの操作時にtabが対応する空白数
set shiftwidth=2    " インデントの各段階に使われる空白数
"自動インデント?
"set smartindent
set autoindent
"インクリメンタルサーチ
set incsearch
" 検索結果のハイライト
set hlsearch     " :set nohlで多分ハイライトが消える :nohl でいいかも
" 大文字小文字区別なく検索
set noignorecase
":e でtab補完と候補表示をおこなう
" コマンドライン補完拡張モード
set wildmode=list,full

" タブ文字と、行末を表示
" set list
" listモードで使用する文字の設定
set listchars=tab:>-,extends:<,trail:-,eol:<


" HTMLの閉じタグを自動補完
augroup MyXML
	autocmd!
	autocmd Filetype xml inoremap <buffer> </ </ <C-x><C-o>
	autocmd Filetype htmk inoremap <buffer> </ </<C-x><C-o>
augroup END

" () {} [] の閉じ括弧を自動補完
inoremap ( ()<ESC>i
inoremap <expr> ) ClosePair(')')
inoremap { {}<ESC>i
inoremap <expr> } ClosePair('}')
inoremap [ []<ESC>i
inoremap <expr> ] ClosePair(']')
" pair close checker
" from othree vimrc ( http://github.com/othree/rc/blob/master/osx/.vimrc )
function ClosePair(char)
	if getline('.')[col('.') - 1] == a:char
		return "\<Right>"
	else
		return a:char
	endif
endf

" .rb拡張子の時ときにRubyへのパスと、マジックコメントを自動挿入
" vim [file_name]のとき自動挿入
" touch [file_name] → vim [file_name]では自動挿入されない
autocmd BufNewFile *.rb 0r ~/.vim/templates/rb.tpl


"-- 前回開いた場所を記憶
"au BufWritePost,VimLeave * mkview
"autocmd BufReadPost * loadview

"map <C-n> <Down>
"map <C-p> <Up>
"map <C-b> <Left>
"map <C-f> <Right>
imap <C-h> <BS>
imap <C-d> <Del>

""" vundle によるプラグイン管理
" vundle設定のために一時的に設定をオフにする
set nocompatible
filetype off 

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

"" 利用する？している？プラグイン
Bundle 'gmarik/vundle'
Bundle 'neocomplcache'
"Bundle 'https://github.com/Shougo/neosnippet'

""" vundleのためにオフにしていた機能を正常に戻す
filetype indent plugin on


" for neosnippet
let g:neosnippet_enable_at_startup = 1
