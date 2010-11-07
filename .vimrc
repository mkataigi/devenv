" -------------------
" init
" -------------------
autocmd!

" -------------------
" View
" -------------------
colorscheme default
set number       "行番号表示
set ruler        "ルーラー表示
set title        "ウィンドウタイトルを変更
"set visualbell   "visual bellの使用
set scrolloff=5
if v:version >= 700
 set cursorline   "カーソル行を強調
 highlight CursorLine guibg=lightblue ctermbg=lightgray
endif

" -------------------
" Language
" -------------------
set encoding=utf-8
"set encoding=euc-jp
set termencoding=utf-8
"set termencoding=eud-jp
set fileencoding=utf-8
set fileencodings=utf-8,euc-jp,iso-2022-jp,cp932
set fileformat=unix
set fileformats=unix,dos,mac

" -------------------
" Search
" -------------------
set incsearch  "インクリメンタルサーチ
set ignorecase "大文字小文字無視
set smartcase  "大文字で開始したら大文字小文字区別
set wrapscan   "最後まで検索したら最初に戻る
set hlsearch   "検索結果をハイライト

" -------------------
" Tab Char
" -------------------
set tabstop=4
set shiftwidth=4
set softtabstop=0
set expandtab

" -------------------
" Special `Key
" -------------------
set list
set listchars=tab:>-,trail:-,extends:<,precedes:<
highlight SpecialKey ctermfg=darkgray

" -------------------
" Input
" -------------------
set nocompatible
set backspace=indent,eol,start "BSで何でも消せるようにする
set formatoptions+=mM          "整形オプションにマルチバイト追加
set autoindent
set smartindent

" -------------------
" Command
" -------------------
set wildmenu
set wildmode=full:list
"set completeopt=menu,preview,menuone

" -------------------
" Programming
" -------------------
set showmatch "対応する括弧を強調表示
set cindent   "Cのインデント
set foldmethod=syntax
set grepprg=internal "内蔵grep

" -------------------
" Mouse
" -------------------
"set mouse=a
"set ttymouse=xterm2

" -------------------
" Backup
" -------------------
set autowrite " ファイル切替時に自動保存
set hidden " 保存しないで他のファイルを表示
set backup         "バックアップ
set backupdir=$HOME/.vimback "バックアップディレクトリ
set directory=$HOME/.vimtmp
set history=10000  "ヒストリ件数
set updatetime=500
"set viminfo=""       ".viminfoファイルの設定
let g:svbfre = '.\+'
autocmd CursorHold * call NewUpdate()

" -------------------
" Status Line
" -------------------
set showcmd      "ステータスラインにコマンドを表示
set laststatus=2 "ステータスラインを常に表示
set statusline=[%L]\ %t\ %y%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}%r%m%=%c:%l/%L

" -------------------
" Window
" -------------------
set splitright "Window Split時に新Windowを右に表示
set splitbelow "Window Split時に新Window下をに表示

" -------------------
" Spell Check
" -------------------
"set spell
"set spelllang=en
"set spellsuggest=en

" -------------------
" Dictionary
" -------------------
set dictionary=/usr/share/dict/words

" -------------------
" File Type
" -------------------
syntax on "シンタックスハイライト
"au FileType perl call PerlType()
filetype indent on "ファイルタイプによるインデントを行う
filetype plugin on "ファイルタイプによるプラグインを使う
" ファイルタイプに応じてテンプレートを自動読み込み
autocmd BufNewFile * silent! 0r $VIMHOME/templates/%:e.tpl
" バッファを開いた時に、カレントディレクトリを自動で移動
autocmd BufEnter * execute ":lcd " .  expand("%:p:h")


" -------------------
" キーバインド
" -------------------
" vimrc をリローダブルにする
noremap <C-c><C-c> <C-c>
noremap <C-c><C-e>e :edit $HOME/.vimrc<CR>
noremap <C-c><C-e>s :source $HOME/.vimrc<CR>

" 表示行単位で移動
noremap j gj
noremap k gk
vnoremap j gj
vnoremap k gk
noremap <C-h> <C-w>gh
noremap <C-j> <C-w>gj
noremap <C-k> <C-w>gk
noremap <C-l> <C-w>gl

" 検索箇所を真ん中に
noremap n nzz
noremap N Nzz
noremap * *zz
noremap # #zz
noremap g* g*zz
noremap g# g#zz

noremap <Space>  /
noremap s :%s/
noremap ; :
noremap <C-n> :nohl<CR>

noremap <Silent> <C-c><C-w>p :set wrap<CR>
noremap <Silent> <C-c><C-w>n :set nowrap<CR>

noremap <Silent> <C-c><C-r>t :set expandtab<CR>:retab<CR>
noremap <Silent> <C-c><C-r>a :set expandtab<CR>:retab!<CR>
noremap <Silent> <C-c><C-r>s :set noexpandtab<CR>:retab<CR>
noremap <Silent> <C-c><C-r>b :set noexpandtab<CR>:retab!<CR>

noremap <Silent> gh :nohlsearch<CR>
noremap ,<Space> :vimgrep<Space>
noremap <Silent> <S->> <C-w>>
noremap <Silent> <S-<> <C-w><
noremap <Silent> <C-[> <C-t>
noremap <Silent> <C-]> <C-]>
noremap ,a :abbreviate<Space>
"noremap a iabbrev
"noremap a cabbrev

" buffer
noremap ee :e .
noremap bb :ls<CR>:buf<Space>
noremap bd :buffdo
noremap bh :set :hidden<CR>
noremap bf :edit <Cfile><CR>
noremap <C-b><C-b> <C-b>
noremap <silent> ] :bp<CR>
noremap <silent> [ :bn<CR>
noremap <silent> bp :bp<CR>
noremap <silent> bn :bn<CR>
noremap <silent> bd :bd<CR>
noremap <silent> <C-Left> :bp<CR>
noremap <silent> <C-Right> :bn<CR>
noremap <silent> <F2> :bq<CR>
noremap <silent> <F3> :bn<CR>
noremap <silent> <F4> :bw<CR>
noremap <silent> bq :Kwbd<CR>

" tab
noremap tt :tabnew .
noremap <silent> tn :tabn<CR>
noremap <silent> tp :tabp<CR>
"noremap x :tabfirst<CR>
"noremap x :tablast<CR>
"noremap x :tabm
noremap <C-t>t :tabdo<Space>

" window
noremap <C-w><C-w> <C-w>
noremap <Silent> ws :new<CR>
noremap <Silent> wv :vnew<CR>
noremap <Silent> wq :quit<CR>
noremap <silent> <F1> :new<CR>
noremap <silent> <F2> :vnew<CR>
noremap <silent> <F3> :quit<CR>
noremap wj <C-w>j
noremap wk <C-w>k
noremap wh <C-w>h
noremap wl <C-w>l
noremap w- <C-w>-
noremap <Silent> w= <C-w>+
noremap <Silent> w, <C-w><
noremap <Silent> w. <C-w>>

" IDE
noremap <C-i><C-i> <C-i>
noremap <Silent> <C-i>w :Tlist<CR>

" help
noremap ,h :<C-u>help<CR>
noremap ,u :<C-u>help<Space><C-r><C-w><CR>
noremap ,g :<C-u>helpgrep<Space>
noremap ,ms :marks<CR>
noremap ,md :delmarks!<CR>

" foldmethod
noremap <silent> <C-f><C-f> zA
noremap <silent> <C-f><C-o> zO
noremap <silent> <C-f><C-c> zC

" undo
noremap <C-c><C-g>+ g+
noremap <C-c><C-g>- g-
noremap <C-c><C-g>l :undolist<CR>
noremap <C-c><C-g>e :undo NODE_NUMBER<CR>

" paste mode
noremap ,po :set paste<CR>
noremap ,pn :set nopaste<CR>

" Command
inoremap <expr> <C-d>f strftime('%Y-%m-%dT%H:%M:%S')
inoremap <expr> <C-d>d strftime('%Y-%m-%d')
inoremap <expr> <C-d>t strftime('%H:%M:%S')
inoremap <silent> <expr> ,t (exists('#AutoComplPopGlobalAutoCommand#InsertEnter')) ? "\<C-o>:AutoComplPopDisable\<CR>" : "\<C-o>:AutoComplPopEnable\<CR>"

" -------------------
" Plugins
" -------------------
" Pathogen
call pathogen#runtime_append_all_bundles()
"call pathogen#helptags()

" minibufexpl
let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplMapWindowNavArrows = 1
let g:miniBufExplMapCTabSwitchBuffs = 1
let g:miniBufExplSplitBelow = 0

" Explore
let g:explHideFiles='^\.,\.gz$,\.exe$,\.zip$'
let g:explDetailedHelp=0
let g:explWinSize=''
let g:explSplitBelow=1
let g:explUseSeparators=1

" yanktmp
map <silent> sy :call YanktmpYank()<CR> 
map <silent> sp :call YanktmpPaste_p()<CR> 
map <silent> sP :call YanktmpPaste_P()<CR> 
let g:yanktmp_file = '/Users/mkataigi/tmp/yanktmp'

" yankring
let g:yankring_history_dir="$HOME/.vimtmp"

" QuickBuf
let g:qb_hotkey = "<F5>"

" autocomplpop
autocmd FileType php let g:AutoComplPop_CompleteOption = '.,w,b,u,t,i,k~/.vim/dict/php.dict'
autocmd CmdwinEnter * AutoComplPopDisable
autocmd CmdwinLeave * AutoComplPopEnable

" snippetsEmu
filetype plugin on "CTRL + Bで設定
let g:snipetsEmu_key=""

" FuzzyFinder
noremap <unique> <silent> eb :FufBuffer!<CR>
noremap <unique> <silent> ef :FufFile!<CR>
noremap <unique> <silent> em :FufMruFile!<CR>
noremap <unique> <silent> ec :FufRenewCache<CR>
autocmd FileType fuf nmap <C-c> <ESC>
let g:fuf_patternSeparator = ' '
let g:fuf_modesDisable = ['mrucmd']
let g:fuf_mrufile_exclude = '\v\.DS_Store|\.git|\.swp|\.svn'
let g:fuf_mrufile_maxItem = 100
let g:fuf_enumeratingLimit = 20
let g:fuf_file_exclude = '\v\.DS_Store|\.git|\.swp|\.svn'

" Pydiction
let g:pydiction_location = '$VIMHOME/ftplugin/pydiction/complete-dict'
let g:pydiction_menu_height = 20
autocmd FileType python let g:pydiction_location = '$VIMHOME/.vim/pydiction/complete-dict'

" ZenCoding
let g:user_zen_expandabbr_key = '<c-e>'
let g:user_zen_settings = {'indentation' : '    ',}

" quick run
noremap <silent> <C-c><C-r> :QuickRun<CR>

" -------------------
" 関数の定義
" -------------------
:com! Kwbd let kwbd_bn=bufnr("%")|enew|exe "bdel ".kwbd_bn|unlet kwbd_bn

" 自動更新
function! NewUpdate()
   let time = strftime("%H", localtime())
   exe "set backupext=.".time
   if expand('%') =~ g:svbfre && !&readonly && &buftype == ''
      silent! update
   endif
endfunction

" encoding
command! Cp932 edit ++enc=cp932
command! Eucjp edit ++enc=euc-jp
command! Iso2022jp edit ++enc=iso-2022-jp
command! UTF8 edit ++enc=utf-8
command! Jis Iso2022jp
command! Sjis Cp932

" cd
command! -complete=customlist,CompleteCD -nargs=? CD cd <args>
function! CompleteCD(arglead, cmdline, cursorpos)
    let pattern = join(split(a:cmdline, '\s', !0)[1:], ' ') . '*/'
    return split(globpath(&cdpath, pattern), "\n")
endfunction
cnoreabbrev <expr> cd (getcmdtype() == ':' && getcmdline() ==# 'cd') ? 'CD' : 'cd'
