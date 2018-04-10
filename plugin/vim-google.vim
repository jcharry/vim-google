function! s:url_encode(str)
  return substitute(a:str,'[^A-Za-z0-9_.~-]','\="%".printf("%02X",char2nr(submatch(0)))','g')
endfunction

function! s:generate_google_string(reg)
  let text = s:url_encode(getreg(reg))
  echomsg text
  return text;
endfunction

function! s:opfunc(type, ...)
  let sel_save = &selection
  let &selection = "inclusive"
  let reg_save = @@
  let type = a:type

  if a:0
    " Invoked from visual mode, use gv to get last highlighted text object
    silent exe "normal! gvy"
  elseif a:type == 'line'
    " Invoked linewise, so use V to yank lines
    silent exe "normal! `[V`]y"
  else
    " Invoked characterwise, so just use v to highlight and yank
    silent exe "normal! `[v`]y"
  endif

  let text = call s:url_encode(getreg('"'))
  call g:Google(text)

  " Reset unnamed register
  let &selection = sel_save
  let @@ = reg_save
endfunction

function! g:Google(search)
  silent! exe "open https://google.com/search?q=".search
endfunction

nnoremap <silent> <Plug>GoogleFromTextObject :<C-U>set opfunc=<SID>opfunc<CR>g@

if !hasmapto('<Plug>GoogleFromTextObject', 'n') || maparg('cl', 'n') ==# ''
  nnoremap go <Plug>GoogleFromTextObject
endif
if !hasmapto('<Plug>GoogleFromTextObject', 'v') || maparg('cl', 'v') ==# ''
  vnoremap go <Plug>GoogleFromTextObject
endif

