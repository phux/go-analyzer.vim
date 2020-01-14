let s:go_analyzer_signs = {}

function! go_analyzer#Analyze()
    call go_analyzer#reset()
    let l:lines = systemlist('go build -gcflags -m '.expand('%:h').'/*.go')

    let l:list_items = {}
    for line in l:lines
        if  line =~# expand('%')
            let l:pos = split(line, ':')
            let l:lineNo = 0 + l:pos[1]
            let l:sign_type = ''
            if line =~# 'escapes to heap'
                let l:sign_type = 'escape'
            elseif line =~# 'inlining call'
                let l:sign_type = 'inline'
            else
                continue
            endif

            if len(l:sign_type) > 0 && get(s:go_analyzer_signs, l:lineNo, '') !~# l:sign_type
                let s:go_analyzer_signs[l:lineNo] = get(s:go_analyzer_signs, l:lineNo, '') . l:sign_type
                call go_analyzer#add_to_list(line)
            endif
        endif
    endfor

    for [line, type] in items(s:go_analyzer_signs)
        exe ':sign place '.line.' group=go_analyzer line='.line.' name=go_analyzer_'.type.' file='.expand('%:p')
    endfor


    cwindow
endfunction

function! go_analyzer#Toggle()
    if len(s:go_analyzer_signs) == 0
        call go_analyzer#Analyze()
    else
        call go_analyzer#reset()
    endif
endfunction

function! go_analyzer#reset()
    call go_analyzer#close_list()
    call go_analyzer#clear_list()

    for [line, type] in items(s:go_analyzer_signs)
        exe 'sign unplace '.line.' group=go_analyzer file='.expand('%:p')
    endfor

    let s:go_analyzer_signs = {}
endfunction

function! go_analyzer#open_list()
    if g:go_analyzer_list_type ==# 'quickfix'
        cwindow
    elseif g:go_analyzer_list_type ==# 'locationlist'
        lwindow
    else
        echom 'go_analyzer.vim error: unknown list type '.g:go_analyzer_list_type
    endif
endfunction

function! go_analyzer#close_list()
    if g:go_analyzer_list_type ==# 'quickfix'
        cclose
    elseif g:go_analyzer_list_type ==# 'locationlist'
        lclose
    else
        echom 'go_analyzer.vim error: unknown list type '.g:go_analyzer_list_type
    endif
endfunction

function! go_analyzer#clear_list()
    if g:go_analyzer_list_type ==# 'quickfix'
        call setqflist([])
    elseif g:go_analyzer_list_type ==# 'locationlist'
        call setloclist([])
    else
        echom 'go_analyzer.vim error: unknown list type '.g:go_analyzer_list_type
    endif
endfunction


function! go_analyzer#add_to_list(line)
    if g:go_analyzer_list_type ==# 'quickfix'
        caddexpr a:line
    elseif g:go_analyzer_list_type ==# 'locationlist'
        laddexpr a:line
    else
        echom 'go_analyzer.vim error: unknown list type '.g:go_analyzer_list_type
    endif
endfunction
