" URL encode a string. ie. Percent-encode characters as necessary.
function! s:url_encode(string)

    let result = ""

    let characters = split(a:string, '.\zs')
    for character in characters
        if character == " "
            let result = result . "+"
        elseif s:character_requires_url_encoding(character)
            let i = 0
            while i < strlen(character)
                let byte = strpart(character, i, 1)
                let decimal = char2nr(byte)
                let result = result . "\\%" . printf("%02x", decimal)
                let i += 1
            endwhile
        else
            let result = result . character
        endif
    endfor

    return result

endfunction

" Returns 1 if the given character should be percent-encoded in a URL encoded
" string.
function! s:character_requires_url_encoding(character)
  let ascii_code = char2nr(a:character)
  if ascii_code >= 48 && ascii_code <= 57
    return 0
  elseif ascii_code >= 65 && ascii_code <= 90
    return 0
  elseif ascii_code >= 97 && ascii_code <= 122
    return 0
  elseif a:character == "-" || a:character == "_" || a:character == "." || a:character == "~"
    return 0
  endif

  return 1
endfunction

function! s:google(...)
  silent execute "!open https://google.com/search?q=".s:url_encode(join(a:000))
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

  call s:google(getreg('"'))

  " Reset unnamed register
  let &selection = sel_save
  let @@ = reg_save
endfunction

vnoremap <silent> <Plug>GoogleFromTextObject :<C-U>call <SID>opfunc(visualmode(), 1)<CR>
nnoremap <silent> <Plug>GoogleFromTextObject :<C-U>set opfunc=<SID>opfunc<CR>g@

if !hasmapto('<Plug>GoogleFromTextObject', 'n') || maparg('go', 'n') ==# ''
  nmap go <Plug>GoogleFromTextObject
endif
if !hasmapto('<Plug>GoogleFromTextObject', 'v') || maparg('go', 'v') ==# ''
  vmap go <Plug>GoogleFromTextObject
endif

com! -nargs=* Google call <SID>google(<f-args>)

