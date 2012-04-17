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
