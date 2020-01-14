""
" @section Introduction, intro
" go-analyzer.vim provides a wrapper around `go build -gcflags -m`

if !exists('g:go_analyzer_list_type')
    ""
    " Display the analysis results in (locationlist|quickfix)
    let g:go_analyzer_list_type = 'quickfix'
endif

if !exists('g:go_analyzer_custom_signs')
    ""
    " Default highlighting, use let g:go_analyzer_custom_signs = 0 to disable
    " and define your own. Defaults:
    "
    " sign define go_analyzer_inline text=i texthl=Search
    "
    " sign define go_analyzer_escape text=e texthl=Error
    "
    " sign define go_analyzer_escapeinline text=ei texthl=Error
    "
    " sign define go_analyzer_inlineescape text=ei texthl=Error
    let g:go_analyzer_custom_signs = 0
endif

if g:go_analyzer_custom_signs == 0
    sign define go_analyzer_inline text=i texthl=Search
    sign define go_analyzer_escape text=e texthl=Error
    sign define go_analyzer_escapeinline text=ei texthl=Error
    sign define go_analyzer_inlineescape text=ei texthl=Error
endif

command! GoAnalyzeToggle :call go_analyzer#Toggle()
