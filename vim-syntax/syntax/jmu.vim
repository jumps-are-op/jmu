runtime! syntax/html.vim
unlet! b:current_syntax

syn case ignore

syn region jmuItalic start='\(^\|[^\\]\)\*' skip='\\\*' end='\*'
syn region jmuBold start='\(^\|[^\\]\)\*\*' skip='\\\*' end='\*\*'
syn region jmuUnderline start='\(^\|[^\\]\)_' skip='\\_' end='_'
syn region jmuStrikethrough start='\(^\|[^\\]\)[-~][-~]' skip='\\[-~]' end='[-~][-~]'
syn region jmuCodeInline start='\(^\|[^\\]\)`' skip='\\`' end='`'
syn region jmuCodeBlock start='^```' end='^```$'
syn match jmuNdash '\(^\|[^\\]\)---'
syn match jmuEmoji '\(^\|[^\\]\):[[:alnum:]_-]\+:'

syn region jmuHItalic start='\(^\|[^\\]\)\*' skip='\\\*' end='\*' contained
syn region jmuHBold start='\(^\|[^\\]\)\*\*' skip='\\\*' end='\*\*' contained
syn region jmuHUnderline start='\(^\|[^\\]\)_' skip='\\_' end='_' contained
syn region jmuHStrikethrough start='\(^\|[^\\]\)[-~][-~]' skip='\\[-~]' end='[-~][-~]' contained
syn region jmuHCodeInline start='\(^\|[^\\]\)`' skip='\\`' end='`' contained

syn region jmuH1 start='^=[^=]' skip='\n=[^=]' end='$' contains=jmuHItalic,jmuHBold,jmuHUnderline,jmuHStrikethrough
syn region jmuH2 start='^==[^=]' skip='\n==[^=]' end='$' contains=jmuHItalic,jmuHBold,jmuHUnderline,jmuHStrikethrough
syn region jmuH3 start='^===[^=]' skip='\n===[^=]' end='$' contains=jmuHItalic,jmuHBold,jmuHUnderline,jmuHStrikethrough
syn region jmuH4 start='^====[^=]' skip='\n====[^=]' end='$' contains=jmuHItalic,jmuHBold,jmuHUnderline,jmuHStrikethrough
syn region jmuH5 start='^=====[^=]' skip='\n=====[^=]' end='$' contains=jmuHItalic,jmuHBold,jmuHUnderline,jmuHStrikethrough
syn region jmuH6 start='^======[^=]' skip='\n======[^=]' end='$' contains=jmuHItalic,jmuHBold,jmuHUnderline,jmuHStrikethrough

syn region jmuEmbed start='^>\+' end='^>\+'

syn region jmuCaption start='\(^\|[^\\]\)(' skip='\\(' end=')'
syn match jmuLink '\(<\|\)[[:alnum:]]\+://[a-zA-Z0-9/%?+&=\#_\.-]\+\(>\|\)'
syn match jmuMailtoLink '\(<\|\)mailto:[a-zA-Z0-9@/%?+&=\#_\.-]\+\(>\|\)'
syn match jmuLocalLink '\(^\|[^\\]\)\(<\|\)://[a-zA-Z0-9/%?+&=\#_\.-]\+\(>\|\)'

syn match jmuHr '^[=-][=-][=-][=-]*$'

syn match jmuComment '^[[:space:]]*#.*$'

hi def link jmuComment Comment

hi def link jmuItalic htmlItalic
hi def link jmuBold htmlBold
hi def link jmuUnderline htmlUnderline
hi def link jmuStrikethrough htmlStrikethrough
hi def link jmuCodeInline htmlSpecialChar
hi def link jmuCodeBlock htmlSpecialChar
hi def link jmuNdash htmlSpecialChar
hi def link jmuEmoji htmlSpecialChar

hi def link jmuHItalic HItalic
hi def link jmuHBold HBold
hi def link jmuHUnderline HUnderline
hi def link jmuHStrikethrough HStrikethrough
hi def link jmuHCodeInline HStrikethrough

hi def link jmuH1 htmlSpecialChar
hi def link jmuH2 htmlSpecialChar
hi def link jmuH3 htmlSpecialChar
hi def link jmuH4 htmlSpecialChar
hi def link jmuH5 htmlSpecialChar
hi def link jmuH6 htmlSpecialChar

hi def link jmuEmbed htmlSpecialChar

hi def link jmuCaption htmlString
hi def link jmuLink htmlLink
hi def link jmuMailtoLink htmlLink
hi def link jmuLocalLink htmlLink

hi def link jmuHr htmlSpecialChar

hi HItalic term=italic cterm=italic gui=italic ctermfg=224 guifg=Orange
hi HBold term=bold cterm=bold gui=bold ctermfg=224 guifg=Orange
hi HUnderline term=underline cterm=underline gui=underline ctermfg=224 guifg=Orange
hi HStrikethrough term=strikethrough cterm=strikethrough gui=strikethrough ctermfg=224 guifg=Orange
