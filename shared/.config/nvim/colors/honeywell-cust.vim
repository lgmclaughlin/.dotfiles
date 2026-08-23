" File:       honeywell.vim
" Author:     Samuel Volk (IllegalLeft)
" Modified:   13 Mar 2026 (edited)

hi clear

if exists("syntax on")
    syntax reset
endif

let g:colors_name="honeywell"

" Color Palette
" Greyscale 
let s:black         = { "gui": "#303236", "cterm": "247" }
let s:light_black   = { "gui": "#3A3A3A", "cterm": "248" }
let s:dark_grey     = { "gui": "#505359", "cterm": "249" }
let s:grey          = { "gui": "#c3c5cc", "cterm": "251" }
let s:light_grey    = { "gui": "#e5e5e5", "cterm": "253" }
let s:lighter_grey  = { "gui": "#f3f3f3", "cterm": "254" }
let s:dark_white    = { "gui": "#f4f4f4", "cterm": "255" }
let s:white         = { "gui": "#FFFFFF", "cterm": "255" }

" Accent/Secondary
let s:darkest_red   = { "gui": "#660000", "cterm":  "52" }
let s:dark_red      = { "gui": "#ff2828", "cterm": "124" }
let s:red           = { "gui": "#ff6161", "cterm": "160" }
let s:light_red     = { "gui": "#ff4747", "cterm": "196" }
let s:pink          = { "gui": "#ec8b8b", "cterm": "181" }

" misc. colours
let s:blue          = { "gui": "#004666", "cterm":  "38" }
let s:light_blue    = { "gui": "#0076b2", "cterm":  "38" }
let s:lighter_blue  = { "gui": "#3eb3ef", "cterm":  "38" }
let s:lightest_blue = { "gui": "#add5ff", "cterm": "117" }

let s:actual_black  = { "gui": "#000000", "cterm":  "16" }
let s:actual_white  = { "gui": "#ffffff", "cterm": "231" }

if &background == "dark"
    let s:bg            = s:blue
    let s:bg_light      = s:light_blue
    let s:bg_lighter    = s:lighter_blue
    let s:norm          = s:light_grey
    let s:fg            = s:norm
    let s:fg_light      = s:lighter_grey
    let s:fg_lighter    = s:white
    let s:accent        = s:red
    let s:red_subtle    = s:darkest_red
else
    let s:bg            = s:white
    let s:bg_light      = s:dark_white
    let s:bg_lighter    = s:light_grey
    let s:norm          = s:dark_grey
    let s:fg            = s:norm
    let s:fg_light      = s:grey
    let s:fg_lighter    = s:white
    let s:accent        = s:red
    let s:red_subtle    = s:light_red
endif

function! s:h(group, style)
      execute "highlight" a:group
              \ "guifg="   (has_key(a:style, "fg")    ? a:style.fg.gui   : "NONE")
              \ "guibg="   (has_key(a:style, "bg")    ? a:style.bg.gui   : "NONE")
              \ "guisp="   (has_key(a:style, "sp")    ? a:style.sp.gui   : "NONE")
              \ "gui="     (has_key(a:style, "gui")   ? a:style.gui      : "NONE")
              \ "ctermfg=" (has_key(a:style, "fg")    ? a:style.fg.cterm : "NONE")
              \ "ctermbg=" (has_key(a:style, "bg")    ? a:style.bg.cterm : "NONE")
              \ "cterm="   (has_key(a:style, "cterm") ? a:style.cterm    : "NONE")
endfunction

" Highlights
call s:h("Normal",          { "fg": s:dark_red, "bg": s:actual_white})
call s:h("Comment",         { "fg": s:bg_lighter})

" Cursor
call s:h("Cursor",          { "bg": s:grey,  "fg": s:black })
call s:h("iCursor",         { "bg": s:grey,  "fg": s:black })
call s:h("vCursor",         { "bg": s:grey,  "fg": s:black })
call s:h("CursorLine",      { "bg": s:light_black })
call s:h("CursorLineNr",    { "fg": s:dark_white, "bg": s:dark_red })

" Constants
call s:h("Constant",        {"fg": s:lightest_blue})
hi! link String             Constant
hi! link Character          Constant
hi! link Number             Constant
hi! link Boolean            Constant
hi! link Float              Constant

" Identifiers (variables)
call s:h("Identifier",      {"fg": s:lightest_blue})
hi! link Function           Identifier

" Statements
call s:h("Statement",       {"fg": s:fg_light})
hi! link Conditional        Statement
hi! link Repeat             Statement
hi! link Label              Statement
hi! link Keyword            Statement
hi! link Exception          Statement

call s:h("Operator",        {"fg": s:norm})

" PreProcessors
call s:h("PreProc",         {"fg": s:norm})
hi! link Include            PreProc
hi! link Define             PreProc
hi! link Macro              PreProc
hi! link PreCondit          PreProc

" Types
call s:h("Type",            {"fg": s:fg_light})
hi! link StorageClass       Type
hi! link Structure          Type
hi! link Typedef            Type
