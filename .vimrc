" -------------------
" View
" -------------------
colorscheme desert
set modeline
set number       "行番号表示
set ruler        "ルーラー表示
set title        "ウィンドウタイトルを変更
set scrolloff=5

" -------------------
" Language
" -------------------
set encoding=utf-8
set termencoding=utf-8
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
augroup highlightIdegraphicSpace
    autocmd!
    autocmd ColorScheme * highlight IdeographicSpace term=underline ctermbg=DarkGreen guibg=DarkGreen
    autocmd VimEnter,WinEnter * match IdeographicSpace /　/
augroup END

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

" -------------------
" Programming
" -------------------
set showmatch "対応する括弧を強調表示
set cindent   "Cのインデント
set foldmethod=syntax
set grepprg=internal "内蔵grep
augroup grepopen
    autocmd!
    autocmd QuickfixCmdPost vimgrep cw
augroup END

" -------------------
" Backup
" -------------------
set autowrite " ファイル切替時に自動保存
set hidden " 保存しないで他のファイルを表示
set backup "バックアップ
set backupdir=$HOME/.vimback "バックアップディレクトリ
set directory=$HOME/.vimtmp
set history=10000  "ヒストリ件数
set updatetime=500
let g:svbfre = '.\+'
augroup CursorHold
    autocmd!
    autocmd CursorHold * call NewUpdate()
augroup END

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
augroup syntax
    autocmd!
augroup END
filetype indent on "ファイルタイプによるインデントを行う
filetype plugin on "ファイルタイプによるプラグインを使う
augroup bufcmd
    autocmd!
    autocmd BufNewFile * silent! 0r $VIMHOME/templates/%:e.tpl
    autocmd BufEnter * execute ":lcd " . expand("%:p:h")
augroup END

" -------------------
" キーバインド
" -------------------
" vimrc をリローダブルにする
noremap <C-c><C-c> <C-c>
noremap <C-c>ev :edit $HOME/.vimrc<CR>
noremap <C-c>sv :source $HOME/.vimrc<CR>
noremap <C-c>ez :edit $HOME/.zshrc<CR>
noremap <C-c>sz :source $HOME/.zshrc<CR>
noremap <C-c>ee :edit $HOME/.zshenv<CR>
noremap <C-c>se :source $HOME/.zshenv<CR>

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

noremap <Silent> <C-c>wo :set wrap<CR>
noremap <Silent> <C-c>wn :set nowrap<CR>

noremap <Silent> <C-c>ro :set expandtab<CR>:retab<CR>
noremap <Silent> <C-c>rn :set noexpandtab<CR>:retab<CR>
noremap <Silent> <C-c>eo :set expandtab<CR>:retab!<CR>
noremap <Silent> <C-c>en :set noexpandtab<CR>:retab!<CR>

noremap <Silent> <C-c>po :set paste<CR>:set nonumber<CR>:set nolist<CR>
noremap <Silent> <C-c>pn :set nopaste<CR>:set number<CR>:set list<CR>

noremap <Silent> gh :nohlsearch<CR>
noremap ,<Space> :vimgrep<Space>
noremap <Silent> <S->> <C-w>>
noremap <Silent> <S-<> <C-w><
noremap <Silent> <C-[> <C-t>
noremap <Silent> <C-]> <C-]>
noremap ,a :abbreviate<Space>

noremap <C-c>pp :set paste<CR>:set nonumber<CR>:set nolist<CR>
noremap <C-c>pn :set nopaste<CR>:set number<CR>:set list<CR>

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
noremap <C-t>t :tabdo<Space>

" window
noremap <C-w><C-w> <C-w>
noremap <Silent> <C-w>n :new<CR>
noremap <Silent> <C-w>v :vnew<CR>
noremap <Silent> <C-w>q :quit<CR>
noremap <silent> <C-w>- <C-w>-
noremap <Silent> <C-w>= <C-w>+
noremap <Silent> <C-w>, <C-w><
noremap <Silent> <C-w>. <C-w>>

" Compiler
noremap <Silent> <C-c>cm :make<CR>
noremap <Silent> <C-c>cp :compiler perl<CR>
noremap <Silent> <C-c>cy :compiler python<CR>

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

" tags
noremap <C-]><C-]> <C-]>
noremap <C-[><C-[> <C-t>
noremap <C-]><C-w> <C-w>}
noremap <C-[><C-w> <C-w><C-x>

" undo
noremap gl :undolist<CR>
noremap ge :undo NODE_NUMBER<CR>

" Command
inoremap <expr> <C-d>f strftime('%Y-%m-%dT%H:%M:%S')
inoremap <expr> <C-d>d strftime('%Y-%m-%d')
inoremap <expr> <C-d>t strftime('%H:%M:%S')
inoremap <silent> <expr> ,t (exists('#AutoComplPopGlobalAutoCommand#InsertEnter')) ? "\<C-o>:AutoComplPopDisable\<CR>" : "\<C-o>:AutoComplPopEnable\<CR>"


" -------------------
" Plugins
" -------------------
let s:dein_dir = expand('~/.cache/dein')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  execute 'set runtimepath^=' . fnamemodify(s:dein_repo_dir, ':p')
endif

if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  let g:rc_dir    = expand('~/.vim/rc')
  let s:toml      = g:rc_dir . '/dein.toml'
  let s:lazy_toml = g:rc_dir . '/dein_lazy.toml'

  call dein#load_toml(s:toml,      {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})

  call dein#end()
  call dein#save_state()
endif

if dein#check_install()
  call dein#install()
endif


" -------------------
" Plugins Configurations
" -------------------
" minibufexpl
let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplMapWindowNavArrows = 1
let g:miniBufExplMapCTabSwitchBuffs = 1
let g:miniBufExplSplitBelow = 0

" yanktmp
map <silent> sy :call YanktmpYank()<CR>
map <silent> sp :call YanktmpPaste_p()<CR>
map <silent> sP :call YanktmpPaste_P()<CR>
let g:yanktmp_file = "$HOME/.vimtmp/yanktmp"

" yankring
let g:yankring_manual_clipboard_check = 0
let g:yankring_history_dir="$HOME/.vimtmp"
nnoremap <silent> <C-c>y :YRShow<CR>
let g:yankring_max_history = 10
let g:yankring_window_height = 13

" autocomplpop
augroup AutoComplPop
    autocmd!
    autocmd FileType php let g:AutoComplPop_CompleteOption = '.,w,b,u,t,i,k~/.vim/dict/php.dict'
    autocmd CmdwinEnter * AutoComplPopDisable
    autocmd CmdwinLeave * AutoComplPopEnable
augroup END

" snippetsEmu
filetype plugin on "CTRL + Bで設定
let g:snipetsEmu_key=""

" FuzzyFinder
noremap <unique> <silent> eb :FufBuffer!<CR>
noremap <unique> <silent> ef :FufFile!<CR>
noremap <unique> <silent> em :FufMruFile!<CR>
noremap <unique> <silent> ec :FufRenewCache<CR>
augroup FuzzyFinder
    autocmd!
    autocmd FileType fuf nmap <C-c> <ESC>
augroup END
let g:fuf_patternSeparator = ' '
let g:fuf_modesDisable = ['mrucmd']
let g:fuf_mrufile_exclude = '\v\.DS_Store|\.git|\.swp|\.svn'
let g:fuf_mrufile_maxItem = 100
let g:fuf_enumeratingLimit = 20
let g:fuf_file_exclude = '\v\.DS_Store|\.git|\.swp|\.svn'

" QuickRun
noremap <silent> <C-c><C-r> :QuickRun<CR>

" alice.vim
function! s:URLEncode()
    let l:line = getline('.')
    let l:encoded = AL_urlencode(l:line)
    call setline('.', l:encoded)
endfunction
function! s:URLDecode()
    let l:line = getline('.')
    let l:encoded = AL_urldecode(l:line)
    call setline('.', l:encoded)
endfunction
command! -nargs=0 -range URLEncode :<line1>,<line2>call <SID>URLEncode()
command! -nargs=0 -range URLDecode :<line1>,<line2>call <SID>URLDecode()

" vim-funlib
function! Random(a, b)
    return random#randint(a:a, a:b)
endfunction
function! MD5(data)
    return hashlib#md5(a:data)
endfunction
function! Sha1(data)
    return hashlib#sha1(a:data)
endfunction
function! Sha256(data)
    return hashlib#sha256(a:data)
endfunction
