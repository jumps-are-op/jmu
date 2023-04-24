" Vim syntax file
" Language:    Jumps' MarkUp language
" Maintainer:  Jumps Are Op <jumpsareop@gmail.com>
" Filenames:   *.jmu *.jm
" g:jmu_fenced_languages -> Array of lanugage jmu hightlight in code blocks
" g:jmu_conceal_links -> Should jmu conceal link and only display captions

if exists("b:current_syntax")
  finish
endif

if !exists('main_syntax')
  let main_syntax = 'jmu'
endif

runtime! syntax/html.vim
unlet! b:current_syntax

syn case ignore

syn cluster jmuAttrs contains=jmuItalic,jmuBold,jmuUnderline,jmuStrikethrough,jmuCodeInline
syn region jmuItalic matchgroup=jmuDelimiter start='\*' end='\*' contains=@Spell concealends
syn region jmuBold matchgroup=jmuDelimiter start='\*\*' end='\*\*' contains=@Spell concealends
syn region jmuUnderline matchgroup=jmuDelimiter start='_' end='_' contains=@Spell concealends
syn region jmuCodeInline matchgroup=jmuDelimiter start='`' end='`' contains=@Spell concealends
syn region jmuStrikethrough matchgroup=jmuDelimiter start='[-~][-~]' end='[-~][-~]' contains=@Spell concealends

syn cluster jmuHAttrs contains=jmuHItalic,jmuHBold,jmuHUnderline,jmuHStrikethrough,jmuHCodeInline
syn region jmuHItalic matchgroup=jmuDelimiter start='\*' end='\*' contains=@Spell concealends contained
syn region jmuHBold matchgroup=jmuDelimiter start='\*\*' end='\*\*' contains=@Spell concealends contained
syn region jmuHUnderline matchgroup=jmuDelimiter start='_' end='_' contains=@Spell concealends contained
syn region jmuHStrikethrough matchgroup=jmuDelimiter start='[-~][-~]' end='[-~][-~]' contains=@Spell concealends contained
syn region jmuHCodeInline matchgroup=jmuDelimiter start='`' end='`' contains=@Spell concealends contained

syn region jmuH start='^=\{1,6\}[^=]' end='$' contains=@jmuHAttrs,@jmuLinks,@jmuSpecial,@Spell

syn match jmuEmbed '^>\{1,9\}\s*$' conceal

syn match jmuImage '^\s*IMAGE\s*:\s*' nextgroup=jmuImageLink skipwhite conceal
syn match jmuImageLink '<\?\([[:alnum:]]*:/\)\?/[a-zA-Z0-9/%?@+&=#_.-]\+>\?' contained nextgroup=jmuImageAttrs skipwhite
syn region jmuImageAttrs start='.' skip='\\$' end='$' contained contains=jmuImageSize,htmlArg,htmlString,htmlValue
syn match jmuImageSize '[0-9]\+[*x ][0-9]\+' contained

syn cluster jmuLinks contains=jmuLink,jmuMailtoLink

if !exists("g:jmu_conceal_links")
	syn match jmuLink '\((\(\\)\|[^)\n]\)*)\)\?[[:space:]\n]*<\?[[:alnum:]]*://[a-zA-Z0-9/%?@+&=#_.-]\+>\?' contains=jmuCaption
	syn match jmuLink '<\?[[:alnum:]]*://[a-zA-Z0-9/%?@+&=#_.-]\+>\?[[:space:]\n]*(\(\\)\|[^)\n]\)*)' contains=jmuCaption
	syn match jmuMailtoLink '\((\(\\)\|[^)\n]\)*)\)\?[[:space:]\n]*<\?mailto:[a-zA-Z0-9@/%?+&=#_.-]\+>\?' contains=jmuCaption
	syn match jmuMailtoLink '<\?mailto:[a-zA-Z0-9@/%?+&=#_.-]\+>\?[[:space:]\n]*(\(\\)\|[^)\n]\)*)' contains=jmuCaption

	syn region jmuCaption start='\s*(' end=')\s*' contained contains=@jmuHAttrs,@Spell
else
	syn match jmuLink '<\?[[:alnum:]]*://[a-zA-Z0-9/%?@+&=#_.-]\+>\?'
	syn match jmuLink '(\(\\)\|[^)\n]\)*)[[:space:]\n]*<\?[[:alnum:]]*://[a-zA-Z0-9/%?@+&=#_.-]\+>\?' contains=jmuCaption conceal
	syn match jmuLink '<\?[[:alnum:]]*://[a-zA-Z0-9/%?@+&=#_.-]\+>\?[[:space:]\n]*(\(\\)\|[^)\n]\)*)' contains=jmuCaption conceal
	syn match jmuMailtoLink '<\?mailto:[a-zA-Z0-9@/%?+&=#_.-]\+>\?'
	syn match jmuMailtoLink '(\(\\)\|[^)\n]\)*)[[:space:]\n]*<\?mailto:[a-zA-Z0-9@/%?+&=#_.-]\+>\?' contains=jmuCaption conceal
	syn match jmuMailtoLink '<\?mailto:[a-zA-Z0-9@/%?+&=#_.-]\+>\?[[:space:]\n]*(\(\\)\|[^)\n]\)*)' contains=jmuCaption conceal

	syn region jmuCaption matchgroup=jmuDelimiter start='(' end=')' concealends contained contains=@jmuHAttrs,@Spell
endif

syn match jmuHr '^[=-][=-][=-][=-]*$'
syn match jmuComment '^\s*#.*$'

syn cluster jmuSpecial contains=jmuEscape,jmuNdash,jmuEmoji
syn match jmuEscape '\\.'
syn keyword jmuNdash ---
syn match jmuEmoji ':[[:alnum:]_-]\+:'

syn region jmuCodeBlock matchgroup=jmuDelimiter start='^```[[:alnum:]]*$' end='^```$' concealends

" Languages in code blocks
if !exists('g:jmu_fenced_languages')
  let g:jmu_fenced_languages = []
endif
let s:done_include = {}
for s:type in map(copy(g:jmu_fenced_languages),'matchstr(v:val,"[^=]*$")')
  if has_key(s:done_include, matchstr(s:type,'[^.]*'))
    continue
  endif
  if s:type =~ '\.'
    let b:{matchstr(s:type,'[^.]*')}_subtype = matchstr(s:type,'\.\zs.*')
  endif
  exe 'syn include @jmuHighlight'.substitute(s:type,'\.','','g').' syntax/'.matchstr(s:type,'[^.]*').'.vim'
  unlet! b:current_syntax
  let s:done_include[matchstr(s:type,'[^.]*')] = 1
endfor
unlet! s:type
unlet! s:done_include
if main_syntax ==# 'jmu'
  let s:done_include = {}
  for s:type in g:jmu_fenced_languages
    if has_key(s:done_include, matchstr(s:type,'[^.]*'))
      continue
    endif
    exe 'syn region jmuHighlight'.substitute(matchstr(s:type,'[^=]*$'),'\..*','','').' matchgroup=jmuDelimiter start="^\s*````*\s*\%({.\{-}\.\)\='.matchstr(s:type,'[^=]*').'}\=\S\@!.*$" end="^\s*````*\ze\s*$" keepend concealends contains=@jmuHighlight'.substitute(matchstr(s:type,'[^=]*$'),'\.','','g')
    let s:done_include[matchstr(s:type,'[^.]*')] = 1
  endfor
  unlet! s:type
  unlet! s:done_include
endif


hi def link jmuComment Comment

hi def link jmuItalic htmlItalic
hi def link jmuBold htmlBold
hi def link jmuUnderline htmlUnderline
hi def link jmuStrikethrough htmlStrikethrough
hi def link jmuCodeInline htmlSpecialChar
hi def link jmuCodeBlock htmlSpecialChar

hi def link jmuH Title
hi def link jmuEmbed htmlSpecialChar

hi def link jmuImage htmlSpecialChar
hi def link jmuImageSize htmlString
hi def link jmuImageLink htmlLink

if !exists("g:jmu_conceal_links")
	hi def link jmuCaption Tag
else
	hi def link jmuCaption htmlLink
endif

hi def link jmuLink htmlLink
hi def link jmuMailtoLink htmlLink

hi def link jmuHr htmlSpecialChar
hi def link jmuEscape htmlSpecialChar
hi def link jmuNdash htmlSpecialChar
hi def link jmuEmoji htmlSpecialChar

hi jmuHItalic term=italic cterm=italic gui=italic ctermfg=224 guifg=Orange
hi jmuHBold term=bold cterm=bold gui=bold ctermfg=224 guifg=Orange
hi jmuHUnderline term=underline cterm=underline gui=underline
			\ ctermfg=224 guifg=Orange
hi jmuHStrikethrough term=strikethrough cterm=strikethrough gui=strikethrough
			\ ctermfg=224 guifg=Orange

syn sync minlines=50

let b:current_syntax = "jmu"
