runtime! syntax/html.vim
unlet! b:current_syntax

syn case ignore
syn spell toplevel

syn keyword jmuNdash ---
syn match jmuEmoji ':[[:alnum:]_-]\+:'
syn region jmuCodeBlock start='^```[[:alnum:]]*$' end='^```$'

syn cluster jmuAttrs contains=jmuItalic,jmuBold,jmuUnderline,jmuStrikethrough,jmuCodeInline
syn region jmuItalic start='\*' end='\*'
syn region jmuBold start='\*\*' end='\*\*'
syn region jmuUnderline start='_' end='_'
syn region jmuCodeInline start='`' end='`'
syn region jmuStrikethrough start='[-~][-~]' end='[-~][-~]'

syn cluster jmuHAttrs contains=jmuHItalic,jmuHBold,jmuHUnderline,jmuHStrikethrough,jmuHCodeInline
syn region jmuHItalic start='\*' end='\*' contained
syn region jmuHBold start='\*\*' end='\*\*' contained
syn region jmuHUnderline start='_' end='_' contained
syn region jmuHStrikethrough start='[-~][-~]' end='[-~][-~]' contained
syn region jmuHCodeInline start='`' end='`' contained

syn region jmuH1 start='^=[^=]' skip='\n=[^=]' end='$' contains=@jmuHAttrs,jmuHLocalLink,jmuHLink
syn region jmuH2 start='^==[^=]' skip='\n==[^=]' end='$' contains=@jmuHAttrs,jmuHLocalLink,jmuHLink
syn region jmuH3 start='^===[^=]' skip='\n===[^=]' end='$' contains=@jmuHAttrs,jmuHLocalLink,jmuHLink
syn region jmuH4 start='^====[^=]' skip='\n====[^=]' end='$' contains=@jmuHAttrs,jmuHLocalLink,jmuHLink
syn region jmuH5 start='^=====[^=]' skip='\n=====[^=]' end='$' contains=@jmuHAttrs,jmuHLocalLink,jmuHLink
syn region jmuH6 start='^======[^=]' skip='\n======[^=]' end='$' contains=@jmuHAttrs,jmuHLocalLink,jmuHLink

syn match jmuEmbed '^>\+[[:space:]]*$'

syn match jmuImage '^[[:space:]]*IMAGE[[:space:]]*:[[:space:]]*.*\n.*$' contains=jmuHLocalLink,jmuHLink,jmuImageSize,htmlArg,htmlString,htmlValue
syn match jmuImageSize '[0-9]\+[*x ][0-9]\+'

syn match jmuLocalLink '\(<\|\)://[a-zA-Z0-9/%?+&=\#_.-]\+\(>\|\)'
syn match jmuLink '\(<\|\)[[:alnum:]]\+://[a-zA-Z0-9/%?+&=\#_.-]\+\(>\|\)'
syn match jmuMailtoLink '\(<\|\)mailto:[a-zA-Z0-9@/%?+&=\#_.-]\+\(>\|\)'
syn match jmuLocalLinkCaption '(.*)[[:space:]]*\(<\|\)://[a-zA-Z0-9/%?+&=\#_.-]\+\(>\|\)' contains=jmuCaption
syn match jmuLocalLinkCaption '\(<\|\)://[a-zA-Z0-9/%?+&=\#_.-]\+\(>\|\)[[:space:]]*(.*)' contains=jmuCaption
syn match jmuLinkCaption '(.*)[[:space:]]*\(<\|\)[[:alnum:]]\+://[a-zA-Z0-9/%?+&=\#_.-]\+\(>\|\)' contains=jmuCaption
syn match jmuLinkCaption '\(<\|\)[[:alnum:]]\+://[a-zA-Z0-9/%?+&=\#_.-]\+\(>\|\)[[:space:]]*(.*)' contains=jmuCaption
syn match jmuMailtoLinkCaption '(.*)[[:space:]]*\(<\|\)mailto:[a-zA-Z0-9@/%?+&=\#_.-]\+\(>\|\)' contains=jmuCaption
syn match jmuMailtoLinkCaption '\(<\|\)mailto:[a-zA-Z0-9@/%?+&=\#_.-]\+\(>\|\)[[:space:]]*(.*)' contains=jmuCaption

syn match jmuHLocalLink '\(<\|\)://[a-zA-Z0-9/%?+&=\#_.-]\+\(>\|\)' contained
syn match jmuHLink '\(<\|\)[[:alnum:]]\+://[a-zA-Z0-9/%?+&=\#_.-]\+\(>\|\)' contained
syn match jmuHMailtoLink '\(<\|\)mailto:[a-zA-Z0-9@/%?+&=\#_.-]\+\(>\|\)' contained
syn match jmuHLocalLinkCaption '(.*)[[:space:]]*\(<\|\)://[a-zA-Z0-9/%?+&=\#_.-]\+\(>\|\)' contained contains=jmuCaption
syn match jmuHLocalLinkCaption '\(<\|\)://[a-zA-Z0-9/%?+&=\#_.-]\+\(>\|\)[[:space:]]*(.*)' contained contains=jmuCaption
syn match jmuHLinkCaption '(.*)[[:space:]]*\(<\|\)[[:alnum:]]\+://[a-zA-Z0-9/%?+&=\#_.-]\+\(>\|\)' contained contains=jmuCaption
syn match jmuHLinkCaption '\(<\|\)[[:alnum:]]\+://[a-zA-Z0-9/%?+&=\#_.-]\+\(>\|\)[[:space:]]*(.*)' contained contains=jmuCaption
syn match jmuHMailtoLinkCaption '(.*)[[:space:]]*\(<\|\)mailto:[a-zA-Z0-9@/%?+&=\#_.-]\+\(>\|\)' contained contains=jmuCaption
syn match jmuHMailtoLinkCaption '\(<\|\)mailto:[a-zA-Z0-9@/%?+&=\#_.-]\+\(>\|\)[[:space:]]*(.*)' contained contains=jmuCaption

syn region jmuCaption start='[[:space:]]*(' end=')[[:space:]]*' contained contains=@jmuHAttrs

syn match jmuHr '^[=-][=-][=-][=-]*$'

syn match jmuComment '^[[:space:]]*#.*$'

syn match jmuEscape '\\.'

hi def link jmuComment Comment

hi def link jmuItalic htmlItalic
hi def link jmuBold htmlBold
hi def link jmuUnderline htmlUnderline
hi def link jmuStrikethrough htmlStrikethrough
hi def link jmuCodeInline htmlSpecialChar
hi def link jmuCodeBlock htmlSpecialChar
hi def link jmuNdash htmlSpecialChar
hi def link jmuEmoji htmlSpecialChar

hi def link jmuItalicBold          htmlItalicBold
hi def link jmuItalicBoldUnderline htmlItalicBoldUnderline
hi def link jmuItalicUnderline     htmlItalicUnderline 
hi def link jmuItalicUnderlineBold htmlItalicUnderlineBold
hi def link jmuBoldItalic          htmlBoldItalic
hi def link jmuBoldItalicUnderline htmlBoldItalicUnderline
hi def link jmuBoldUnderline       htmlBoldUnderline
hi def link jmuBoldUnderlineItalic htmlBoldUnderlineItalic
hi def link jmuUnderlineItalic     htmlUnderlineItalic
hi def link jmuUnderlineItalicBold htmlUnderlineItalicBold
hi def link jmuUnderlineBold       htmlUnderlineBold
hi def link jmuUnderlineBoldItalic htmlUnderlineBoldItalic


hi def link jmuHItalic HItalic
hi def link jmuHBold HBold
hi def link jmuHUnderline HUnderline
hi def link jmuHStrikethrough HStrikethrough
hi def link jmuHCodeInline HStrikethrough

hi def link jmuH1 Title
hi def link jmuH2 Title
hi def link jmuH3 Title
hi def link jmuH4 Title
hi def link jmuH5 Title
hi def link jmuH6 Title

hi def link jmuEmbed htmlSpecialChar

hi def link jmuImage htmlSpecialChar
hi def link jmuImageSize htmlString

hi def link jmuCaption htmlString
hi def link jmuLocalLink htmlLink
hi def link jmuLocalLinkCaption htmlLink
hi def link jmuLink htmlLink
hi def link jmuLinkCaption htmlLink
hi def link jmuMailtoLink htmlLink
hi def link jmuMailtoLinkCaption htmlLink
hi def link jmuHLocalLink htmlLink
hi def link jmuHLocalLinkCaption htmlLink
hi def link jmuHLink htmlLink
hi def link jmuHLinkCaption htmlLink
hi def link jmuHMailtoLink htmlLink
hi def link jmuHMailtoLinkCaption htmlLink

hi def link jmuHr htmlSpecialChar

hi def link jmuEscape htmlSpecialChar

hi jmuHItalic term=italic cterm=italic gui=italic ctermfg=224 guifg=Orange
hi jmuHBold term=bold cterm=bold gui=bold ctermfg=224 guifg=Orange
hi jmuHUnderline term=underline cterm=underline gui=underline ctermfg=224 guifg=Orange
hi jmuHStrikethrough term=strikethrough cterm=strikethrough gui=strikethrough ctermfg=224 guifg=Orange
hi jmuHItalicBold term=italic,bold cterm=italic,bold gui=italic,bold ctermfg=224 guifg=Orange
hi jmuHItalicBoldUnderline term=italic,bold,underline cterm=italic,bold,underline gui=italic,bold,underline ctermfg=224 guifg=Orange
hi jmuHItalicUnderline term=italic,underline cterm=italic,underline gui=italic,underline ctermfg=224 guifg=Orange
hi jmuHItalicUnderlineBold term=italic,underline,bold cterm=italic,underline,bold gui=italic,underline,bold ctermfg=224 guifg=Orange
hi jmuHBoldItalic term=bold,italic cterm=bold,italic gui=bold,italic ctermfg=224 guifg=Orange
hi jmuHBoldItalicUnderline term=bold,italic,underline cterm=bold,italic,underline gui=bold,italic,underline ctermfg=224 guifg=Orange
hi jmuHBoldUnderline term=bold,underline cterm=bold,underline gui=bold,underline ctermfg=224 guifg=Orange
hi jmuHBoldUnderlineItalic term=bold,underline,italic cterm=bold,underline,italic gui=bold,underline,italic ctermfg=224 guifg=Orange
hi jmuHUnderlineItalic term=underline,italic cterm=underline,italic gui=underline,italic ctermfg=224 guifg=Orange
hi jmuHUnderlineItalicBold term=underline,italic,bold cterm=underline,italic,bold gui=underline,italic,bold ctermfg=224 guifg=Orange
hi jmuHUnderlineBold term=underline,bold cterm=underline,bold gui=underline,bold ctermfg=224 guifg=Orange
hi jmuHUnderlineBoldItalic term=underline,bold,italic cterm=underline,bold,italic gui=underline,bold,italic ctermfg=224 guifg=Orange
