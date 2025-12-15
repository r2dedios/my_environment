" Villega's colorscheme

highlight clear
if exists("syntax_on")
  syntax reset
endif

set t_Co=256
let g:colors_name = "villegas"



" Basic colors def
let s:fg=250
let s:fg2="#a3a3a3"
let s:fg3="#959595"
let s:fg4="#878787"
let s:bg2="#3a3636"
let s:bg3="#4b4747"
let s:bg4="#5c5959"
let s:keyword="#96905f"
let s:builtin="#71a46c"
let s:const= "#bd845f"
let s:comment="#5d5a58"
let s:func="#b680b1"
let s:str="#71a19f"
let s:type="#8b8fc6"
let s:var="#c27d7b"
let s:warning="#e81050"
let s:warning2="#e86310"




"   Basic
"   TODO
hi  Normal           ctermfg=248   ctermbg=none  cterm=none
hi  Error            ctermfg=255   ctermbg=160   cterm=none
hi  SPellBad         ctermfg=160   ctermbg=none  cterm=underline
hi  Folded           ctermfg=220   ctermbg=55    cterm=none

"   Interface
hi  Visual           ctermfg=15    ctermbg=19    cterm=none
hi  Pmenu            ctermfg=15    ctermbg=17    cterm=none
hi  PmenuSel         ctermfg=15    ctermbg=124   cterm=bold
hi  PmenuSbar        ctermfg=0     ctermbg=17    cterm=none
hi  PmenuThumb       ctermfg=0     ctermbg=240   cterm=none
hi  CursorColumn     ctermfg=250   ctermbg=234   cterm=none
hi  CursorLine       ctermfg=none  ctermbg=234   cterm=none
hi  CursorLineNr     ctermfg=184   ctermbg=234   cterm=bold
hi  ColorColumn      ctermfg=none  ctermbg=234   cterm=none
hi  LineNr           ctermfg=241   ctermbg=none  cterm=none
hi  ExtraWhitespace  ctermfg=255   ctermbg=9     cterm=none
hi  Search           ctermfg=0     ctermbg=184   cterm=none
hi  MatchParen       ctermfg=160   ctermbg=8     cterm=none
hi  VertSplit        ctermfg=240   ctermbg=234   cterm=none

"   Coding
hi  Comment          ctermfg=242   ctermbg=none  cterm=none
hi  Boolean          ctermfg=190   ctermbg=none  cterm=none
hi  Character        ctermfg=112   ctermbg=none  cterm=none
hi  String           ctermfg=76   ctermbg=none  cterm=none
hi  Type             ctermfg=70   ctermbg=none  cterm=bold
hi  PreProc          ctermfg=76   ctermbg=none  cterm=none
hi  Todo             ctermfg=0     ctermbg=202   cterm=bold
hi  Keyword          ctermfg=172   ctermbg=none  cterm=bold
hi  Define           ctermfg=171   ctermbg=none  cterm=none
hi  Function         ctermfg=125   ctermbg=none  cterm=bold
hi  Number           ctermfg=129   ctermbg=none  cterm=none
hi  Operator         ctermfg=178   ctermbg=none  cterm=none
hi  Label            ctermfg=172   ctermbg=none  cterm=bold
hi  link Conditional Keyword
hi  link Repeat Keyword
hi  Identifier       ctermfg=75   ctermbg=none  cterm=none
hi  Statement        ctermfg=90   ctermbg=none  cterm=bold
hi  Float            ctermfg=90   ctermbg=none  cterm=none
hi  Constant         ctermfg=90   ctermbg=none  cterm=none

hi  ErrorMsg         ctermfg=0   ctermbg=9  cterm=none
hi  WarningMsg       ctermfg=20   ctermbg=208  cterm=none
hi  Special          ctermfg=33   ctermbg=none  cterm=none

hi SignColumn ctermbg=0
hi SignatureMarkLine ctermbg=233
hi SignatureMarkerText ctermbg=8 ctermfg=12
hi SignatureMarkText ctermbg=0 ctermfg=1

hi  SpecialKey       ctermfg=9   ctermbg=none  cterm=none
hi  StorageClass     ctermfg=9   ctermbg=none  cterm=none
hi  Tag              ctermfg=9   ctermbg=none  cterm=none

hi  Title            ctermfg=3   ctermbg=none  cterm=none
hi  Underlined       ctermfg=242   ctermbg=none  cterm=none
hi  NonText          ctermfg=123   ctermbg=none  cterm=none


" Diff Colors
hi  DiffAdd          ctermfg=15    ctermbg=28    cterm=bold
hi  DiffDelete       ctermfg=15    ctermbg=160   cterm=bold
hi  DiffChange       ctermfg=15    ctermbg=208   cterm=bold
hi  DiffText         ctermfg=15    ctermbg=18    cterm=bold


" FoldColum Colors
hi FoldColumn        ctermfg=11    ctermbg=234   cterm=bold


" Go Highlighting
let s:builtin="#19d22e"
exe 'hi goBuiltins guifg='s:builtin
let g:go_highlight_array_whitespace_error = 1
let g:go_highlight_build_constraints      = 1
let g:go_highlight_chan_whitespace_error  = 1
let g:go_highlight_extra_types            = 1
let g:go_highlight_fields                 = 1
let g:go_highlight_format_strings         = 1
let g:go_highlight_function_calls         = 1
let g:go_highlight_function_parameters    = 1
let g:go_highlight_functions              = 1
let g:go_highlight_generate_tags          = 1
let g:go_highlight_operators              = 1
let g:go_highlight_space_tab_error        = 1
let g:go_highlight_string_spellcheck      = 1
let g:go_highlight_types                  = 1
let g:go_highlight_variable_assignments   = 0
let g:go_highlight_variable_declarations  = 1
hi  goParen              ctermfg=84   ctermbg=none  cterm=none
hi  goBlock              ctermfg=84   ctermbg=none  cterm=none
hi  goParamType              ctermfg=84   ctermbg=none  cterm=none
