#!/bin/sed -nf

# Made by jumps are op
# This software is under GPL version 3 and comes with ABSOLUTELY NO WARRANTY

# "All markup languages are overcomplicated and bloated." -- Jumps
# "Jmu is a minimalist, expandable, and usable markup language" -- Jumps
#
# Backstory:
# I was making my webpage (~~jumps-are-op.github.io~~ now jumps.neocities.org)
# and I needed to choose a markup language, the obvious choice was markdown
# I already know some markdown and I started with it.
# The more and more I use it I realize it's a bare bone language,
# And every program have their own "flavors",
# and these "flavors" are incompatible with each other.
# Then I started using AsciiDoc, which is a BLOATED markup language,
# and I can't even use it,
# AsciiDoctor (most famous implementation) uses ruby gems
# which contains non-free packages and is PROPRIETARY.
# I use Parabola GNU/Linux-libre (Arch Linux without non-free software)
# I only use 100% free software, I will NEVER install any proprietary blob.
# So I created jmu, A minimalist, expandable, and usable markup language.
#
# Quick reference guide (list of everything possible):
#
# <h1>Basic HTML is support</h1>.
#
# # Any line start with a # is a comment and will be ignored.
#
# Lines grouped together
# will be merged.
#
# Lines ending with a . (period) won't be merged together.
# Lines ending with a "  " (two spaces) will add a newline at the end  
#
#
# *Italic text*
# **BOLD text**
# ~~Text with stroke~~
# --Also text with stroke--
# --This is also a text with stroke~~
# _Text with an underline_
# ^super^ script
# X^2^
# # Only works on alpha numeric charters
# =sub= script
# H=2=O
# ~sub~ script
# H~2~O
# A `code` text
# >
#  embedded text
# >>
#  *embedded* **text** ~with~ _attributes_
# >>
# >
#
# = Header 1
# == Header 2
# === Header 3
# ==== Header 4
# ===== Header 5
# ====== Header 6
#
# https://path/to/a/link
# <https://path/to/a/link>
# https://path/to/a/link (Link caption)
# <https://path/to/a/link> (Link caption)
#
# mailto:me@mywebsite.org
# <mailto:me@mywebsite.org>
# mailto:me@mywebsite.org (My email)
# <mailto:me@mywebsite.org> (My email)
#
# Text before a horizontal rule
# ---
# Text after a horizontal rule
#
# # TODO
# NOTE: A note block.
#
# # TODO
# NOTE:
# 	Also a multi line
# 	Note block (until the end of the paragraph)
#
# ```sh
# 	echo "A multi line code text"
# ```
#
# # TODO
# Table Name
# Column 1 | Column 2
# ----|----
# 1x1 | 1x2
# 2x1 | 2x2
#
# # TODO
# Here is a sentence with a footnote^1.
# ^1 This is the footnote.
#
# A --- (long dash) character
#
# IMAGE: https://path/to/an/image.png [WIDTH[*|X|x| ]HEIGHT] [HTML ATTRIBUTES]
# Image caption until the end of the paragraph.
#
# # TODO
# A :smile: face emoji
#

# See sed.sf.net for more info about How any of this works.

# Clear all previous main text and read next line
# sed do this automatically to us, so we don't need to do anything.

# No matter what happen DO NOT ALLOW NON-PRINTABLE CHARACTERS IN HTML.
s/&/\&amp;/g;
s/&amp;\(#[0-9]\+\|[a-z]\+\);/\&\1;/g;
s/[[:space:]]\+<[[:space:]]\+/ \&lt; /g;
s/[[:cntrl:]]/ /g;

# If the line is a code block start, branch to `start`
/^```[[:alnum:]]*$/{ b start;}

# Add line to hold space. (prefixed with a `newline` character)
H;

# If we are not in a ```code``` block, check for the following:
# the line ends in a single . (period), branch to `start`
# the line is a valid header, branch to `start`.
# the line is empty, branch to `start`.
x;
/^```[[:alnum:]]*/!{ x;
	/^=\{1,6\}[[:space:]]*[^=]\+$/{ s/.*//; b start;}
	/\([^.]\|^\)\.$/{ s/.*//; b start;}
	/^$/{ s/.*//; b start;}
	x;
}
x;

# If the line is the not last line, start new cycle.
$!b;

# Now we have a "paragraph" of text in the hold space.
:start;

# Treat hold space as the main text.
x;

# NOTE: At this point ^ and $ have different meanings
# 	^ now mean `start of text chunk`
# 	$ now mean `end of text chunk`
# 	So they are NOT `start of line` and `end of line`.

# Well now there is a stray `newline` character at the start, delete it.
s/^\n//;

# ```CLASS code``` text
/^```[[:alnum:]]*\n/{
	# Hold space now have ```, move it to Patern space
	x; s/.*//; x; s/$/```/;
	s#^```\([[:alnum:]]\+\)\n\(.*\)```$#<pre><code class="language-\1">\2\n</code></pre>#g;
	s#^```\n\(.*\)```$#<pre><code>\1</code></pre>#g;
	b end;
}

# Delete lines starting with #.
s/\(\n\|^\)[[:space:]]*#[^\n]*//g;

# If main text is empty, start new cycle.
/^$/b;

# NOTE: Use \(\\C\|[^C\n]\)* where C is the character of the attribute,
# NOTE: so the user can add C inside the attribute, for example:
# NOTE: *Italic text with \* inside it*

# NOTE: Use \([^\\]\|^\) to allow the user to escape attributes, for example:
# NOTE: This is a normal text and has \* inside it, and here is \* another one
# NOTE: Don't forget to add \1 at the start of the replacement string

# If the line ends in \ (backslash), concatenate it with the next one.
s/\\\n//g;

# If the line ends in "  " (two spaces), delete it and add a <br/>
s#  \(\n\|$\)#<br/>\1#g;

# If the line is just dashes or equal signs, change it to a horizontal ruler
s#\(\n\|^\)[=-][=-][=-][=-]*\(\n\|$\)#\1<hr/>\2#g;


# `code` text
s#\([^\\]\|^\)`\(\(\\`\|[^`]\)*\)`#\1<code>\2</code>#g;

# = Header
s#\(\n\|^\)=[[:space:]]*\([^=]\+.*\)$#<h1>\2</h1>#;
s#\(\n\|^\)==[[:space:]]*\([^=]\+.*\)$#<h2>\2</h2>#;
s#\(\n\|^\)===[[:space:]]*\([^=]\+.*\)$#<h3>\2</h3>#;
s#\(\n\|^\)====[[:space:]]*\([^=]\+.*\)$#<h4>\2</h4>#;
s#\(\n\|^\)=====[[:space:]]*\([^=]\+.*\)$#<h5>\2</h5>#;
s#\(\n\|^\)======[[:space:]]*\([^=]\+.*\)$#<h6>\2</h6>#;

# Only 9 levels are supported
s#\(\n\|^\)>\{9\}\(\(\n[^>]\{9\}[^\n]*\)*\)\n>\{9\}\(\n\|$\)#\1<blockquote><p>\2\n</p></blockquote>\4#g;
s#\(\n\|^\)>\{8\}\(\(\n[^>]\{8\}[^\n]*\)*\)\n>\{8\}\(\n\|$\)#\1<blockquote><p>\2\n</p></blockquote>\4#g;
s#\(\n\|^\)>\{7\}\(\(\n[^>]\{7\}[^\n]*\)*\)\n>\{7\}\(\n\|$\)#\1<blockquote><p>\2\n</p></blockquote>\4#g;
s#\(\n\|^\)>\{6\}\(\(\n[^>]\{6\}[^\n]*\)*\)\n>\{6\}\(\n\|$\)#\1<blockquote><p>\2\n</p></blockquote>\4#g;
s#\(\n\|^\)>>>>>\(\(\n[^>]\{5\}[^\n]*\)*\)\n>>>>>\(\n\|$\)#\1<blockquote><p>\2\n</p></blockquote>\4#g;
s#\(\n\|^\)>>>>\(\(\n[^>]\{4\}[^\n]*\)*\)\n>>>>\(\n\|$\)#\1<blockquote><p>\2\n</p></blockquote>\4#g;
s#\(\n\|^\)>>>\(\(\n[^>]\{3\}[^\n]*\)*\)\n>>>\(\n\|$\)#\1<blockquote><p>\2\n</p></blockquote>\4#g;
s#\(\n\|^\)>>\(\(\n[^>]\{2\}[^\n]*\)*\)\n>>\(\n\|$\)#\1<blockquote><p>\2\n</p></blockquote>\4#g;
s#\(\n\|^\)>\(\(\n[^>][^\n]*\)*\)\n>\(\n\|$\)#\1<blockquote><p>\2\n</p></blockquote>\4#g;

# **BOLD** text
s#\([^\\]\|^\)\*\*\(\(\\\*\|[^*]\|\*[^*]\)*\)\*\*#\1<b>\2</b>#g;

# *Italic* text
s#\([^\\]\|^\)\*\(\(\\\*\|[^*]\)*\)\*#\1<i>\2</i>#g;

# ~~Text with a stroke~~
s#\([^\\]\|^\)[-~][-~]\(\(\\[-~]\|[^-~\n]\)*\)[-~][-~]#\1<del>\2</del>#g;

# _Text with an underline_
s#\([^\\]\|^\)_\(\(\\_\|[^_]\)*\)_#\1<ins>\2</ins>#g;

# ^super^ text
# X^2^
s#\([^\\]\|^\)\^\(\(\\\^\|[^\^]\)*\)\^#\1<sup>\2</sup>#g;

# ~sub~ text
# H~2~O
s#\([^\\]\|^\)~\(\(\\~\|[^~]\)*\)~#\1<sub>\2</sub>#g;

# =sub= script # Only works on alpha numeric characters
# H=2=O
s#\([^\\]\|^\)=\([[:alnum:]]*\)=#\1<sub>\2</sub>#g;

# A --- long dash
s#\([^\\]\|^\)---#\1\&ndash;#g;

# IMAGE: https://path/to/an/image.png [WIDTH[*|X|x| ]HEIGHT] [HTML ATTRIBUTES]
# Image caption until the end of the paragraph.
s#\(\n\|^\)[[:space:]]*[Ii][Mm][Aa][Gg][Ee][[:space:]]*:[[:space:]]*<\{0,1\}\([[:alnum:]]\+\)\(://[a-zA-Z0-9/%?+&=\#_.-]\+\)>\{0,1\}[[:space:]]*\([0-9]\+\)[*Xx ]\([0-9]\+\)\([[:space:]]\+.*\|\)\
\(.*\)#<figure><a href="\2\\\3">\
<img src="\2\\\3" width="\4" height="\5"\6>\
</a><figcaption>\n\7\n</figcaption></figure>#;
s#\(\n\|^\)[[:space:]]*[Ii][Mm][Aa][Gg][Ee][[:space:]]*:[[:space:]]*<\{0,1\}\([[:alnum:]]\+\)\(://[a-zA-Z0-9/%?+&=\#_.-]\+\)>\{0,1\}[[:space:]]*\([[:space:]]\+.*\|\)\
\(.*\)#<figure><a href="\2\\\3">\
<img src="\2\\\3"\4>\
</a><figcaption>\n\5\n</figcaption></figure>#;

# IMAGE: [:/]/path/to/a/local/image.png [WIDTH[*|X|x| ]HEIGHT] [HTML ATTRIBUTES]
# Image caption until the end of the paragraph.
s#\(\n\|^\)[[:space:]]*[Ii][Mm][Aa][Gg][Ee][[:space:]]*:[[:space:]]*<\{0,1\}\(:/\|\)\(/[a-zA-Z0-9/%?+&=\#_.-]\+\)>\{0,1\}[[:space:]]*\([0-9]\+\)[*Xx ]\([0-9]\+\)\([[:space:]]\+.*\|\)\
\(.*\)#<figure><a href="\3">\
<img src="\3" width="\4" height="\5"\6>\
</a><figcaption>\n\7\n</figcaption></figure>#;
s#\(\n\|^\)[[:space:]]*[Ii][Mm][Aa][Gg][Ee][[:space:]]*:[[:space:]]*<\{0,1\}\(:/\|\)\(/[a-zA-Z0-9/%?+&=\#_.-]\+\)>\{0,1\}[[:space:]]*\([[:space:]]\+.*\|\)\
\(.*\)#<figure><a href="\3">\
<img src="\3"\4>\
</a><figcaption>\n\5\n</figcaption></figure>#;

# NOTE: To escape a link, it should be like `https\://an/escaped/link`
# https://path/to/a/link (Link caption)
# <https://path/to/a/link> (Link caption)
# (Link caption) https://path/to/a/link
# (Link caption) <https://path/to/a/link>
s#\(<\|\)\([[:alnum:]]\+\)\(://[a-zA-Z0-9/%?@+&=\#_.-]\+\)\(>\|\)[[:space:]]*(\(\(\\)\|[^)\n]\)*\))#<a href="\2\\\3">\5</a>#g;
s#(\(\(\\)\|[^)\n]\)*\))[[:space:]]*\(<\|\)\([[:alnum:]]\+\)\(://[a-zA-Z0-9/%?@+&=\#_.-]\+\)\(>\|\)#<a href="\4\\\5">\1</a>#g;

# https://path/to/a/link
# <https://path/to/a/link>
s#\(<\|\)\([[:alnum:]]\+\)\(://[a-zA-Z0-9/%?@+&=\#_.-]\+\)\(>\|\)#<a href="\2\\\3">\2\\\3</a>#g;

# NOTE: To escape an email link, it should be like `mailto\:me@mywebsite.org`
# mailto:me@mywebsite.org (Email caption)
# <mailto:me@mywebsite.org> (Email caption)
# (Email caption) mailto:me@mywebsite.org
#  (Email caption)<mailto:me@mywebsite.org>
s#\(<\|\)mailto\(:[a-zA-Z0-9/%?+&=\#_.-]*\(@\|\)[a-zA-Z0-9/%?+&=\#_.-]\+\)\(>\|\)[[:space:]]*(\(\(\\)\|[^)]\)*\))#<a href="mailto\\\2">\5</a>#g;
s#(\(\(\\)\|[^)]\)*\))[[:space:]]*\(<\|\)mailto\(:[a-zA-Z0-9/%?+&=\#_.-]*\(@\|\)[a-zA-Z0-9/%?+&=\#_.-]\+\)\(>\|\)#<a href="mailto\\\4">\1</a>#g;

# mailto:me@mywebsite.org
# <mailto:me@mywebsite.org>
s#\(<\|\)mailto:\([a-zA-Z0-9/%?+&=\#_.-]*\(@\|\)[a-zA-Z0-9/%?+&=\#_.-]\+\)\(>\|\)#<a href="mailto:\2">\2</a>#g;

# NOTE: To escape a local link, it should be like `\://path/to/a/local/link`
# ://path/to/a/local/link (Link caption)
# <://path/to/a/local/link> (Link caption)
# (Link caption) ://path/to/a/local/link
# (Link caption) <://path/to/a/local/link>
s#\([^\\]\|^\)\(<\|\):/\(/[a-zA-Z0-9/%?@+&=\#_.-]\+\)\(>\|\)[[:space:]]*(\(\(\\)\|[^)]\)*\))#\1<a href="\3">\5</a>#g;
s#(\(\(\\)\|[^)]\)*\))[[:space:]]*\(<\|\):/\(/[a-zA-Z0-9/%?@+&=\#_.-]\+\)\(>\|\)#<a href="\4">\1</a>#g;

# ://path/to/a/local/link
# <://path/to/a/local/link>
s#\([^\\]\|^\)\(<\|\)://\([a-zA-Z0-9/%?@+&=\#_.-]\+\)\(>\|\)#\1<a href="/\3">\3</a>#g;

# Headers
/^<h[1-6]>/{ s/\\\(.\)/\1/g; p; s/.*//; x; d;}

# Blockquote
/^<blockquote>/{ s/\\\(.\)/\1/g; p; s/.*//; x; d;}

# Paragraphs
s#^#<p>#;
s#[[:space:]]*$#</p>#;

# Headers should be outside paragraphs
s#\(<h[0-6]>.*</h[0-6]>\)</p>$#</p>\n\1#;

# Escape
s/\\\(.\)/\1/g;

# End
:end;
p;
d;
