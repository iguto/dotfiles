"
" Basic settings
"
"

"
" 表示
"
" シンタックスハイライトを有効 +その他
syntax on
filetype on

filetype plugin on
filetype indent on
"行番号の表示
set number
" タブ文字と、行末を表示
set list
" listモードで使用する文字の設定
set listchars=tab:>-,extends:<,trail:-,eol:$
"コマンドをステータス行に表示
set showcmd

"
" インデント
"
set smarttab
set expandtab
"タブ幅の設定
set tabstop=2	    " ファイル内のtabの空白数
set softtabstop=2  " タブやBSの操作時にtabが対応する空白数
set shiftwidth=2    " インデントの各段階に使われる空白数
"自動インデント?
"set smartindent
set autoindent

"
" 検索
"
"インクリメンタルサーチ
set incsearch
" 検索結果のハイライト
set hlsearch     " :nohlでハイライトを消せる
" 大文字小文字区別なく検索
set noignorecase

"
" keymap
"
" emacs like 
imap <C-h> <BS>
imap <C-d> <Del>
imap <C-a> <Home>
imap <C-e> <End>
imap <C-f> <Right>
imap <C-b> <Left>
" C-c をEscに
imap <C-c> <Esc>

"
" カーソル位置の調節
"
" `()`まで入力すると、カーソル位置を括弧の中に移動する
imap {} {}<Left>
imap () ()<Left>
imap '' ''<Left>
imap "" ""<Left>
imap <> <><Left>


"
" misc
"
"バックスペースでインデントや改行を削除できるようにする
set backspace=indent,eol,start

":e でtab補完と候補表示をおこなう
" コマンドライン補完拡張モード
set wildmode=list,full



"
"
" optional setting
"
"


"
" undoとカーソル位置の記録
"
" ファイルを閉じても編集履歴を覚えておく
if has('persistent_undo')
	set undodir=~/.vim/undo
	set undofile
endif
" カーソル位置の記録
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\""









" HTMLの閉じタグを自動補完
augroup MyXML
	autocmd!
	autocmd Filetype xml inoremap <buffer> </ </ <C-x><C-o>
	autocmd Filetype htmk inoremap <buffer> </ </<C-x><C-o>
augroup END

" () {} [] の閉じ括弧を自動補完
"inoremap ( ()<ESC>i
"inoremap <expr> ) ClosePair(')')
"inoremap { {}<ESC>i
"inoremap <expr> } ClosePair('}')
"inoremap [ []<ESC>i
"inoremap <expr> ] ClosePair(']')

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


""" vundle によるプラグイン管理
" vundle設定のために一時的に設定をオフにする
set nocompatible
filetype off 

"set rtp+=~/.vim/bundle/vundle/
"call vundle#rc()
"
""" 利用する？している？プラグイン
"Bundle 'gmarik/vundle'
"Bundle 'neocomplcache'
""Bundle 'https://github.com/Shougo/neosnippet'

""" vundleのためにオフにしていた機能を正常に戻す
filetype indent plugin on


" for neosnippet
let g:neosnippet_enable_at_startup = 1

helptags ~/.vim/doc

"
" memo
"

" カーソル移動
"   H: カーソル位置を表示画面上の一番上の行に移動
"   M: カーソル位置を表示画面上の真ん中の行に移動
"   L: カーソル位置を表示画面上の一番下の行に移動
"
"   gj: 表示上、カーソルを1行下へ移動
"   gk: 表示上、カーソルを1行上へ移動

"   `: マークした位置へ移動 +レジスタ
"   m: マークする
"   :marks: マーク一覧
"
"   :reg: レジスタに格納されている情報一覧  

" tab
"    :tabnew FILE
"    :tabedit FILE    FILEを新しいタブで開く
"    :tabclose        タブを閉じる
"    gT               一つ前のタブに移動
"    gt               次のタブに移動
"
" text object
" カーソル位置は関係なく、同一行の後ろ？
"    di'  '' で囲まれた文字列を削除する ''は残す
"    da'  '' で囲まれた文字列と''自身を削除する
"    dat   tag



