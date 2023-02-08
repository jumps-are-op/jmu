#!/bin/sed -nf

# Made by jumps are op
# This software is under GPL version 3 and comes with ABSOLUTELY NO WARRANTY

# "All markup languages are overcomplicated and bloated." -- Jumps
# "Jmu is a minimalist, expandable, and usable markup language" -- Jumps
#
# Backstory:
# I was making my webpage (jumps-are-op.github.io)
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
# =sub= script # Only works on alpha numeric charters
# H=2=O
# ~sub~ script
# H~2~O
# A `code` text
# > embedded text
# > *embedded* **text** ~with~ _attributes_
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
# # TODO
# NOTE: A note block.
#
# # TODO
# NOTE:
# 	Also a multi line
# 	Note block (until the end of the paragraph)
#
# # TODO
# ```sh
# 	echo "A multi line code text"
# ```
#
# # TODO
# Text before a horizontal rule
# ---
# Text after a horizontal rule
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
#
# ^1 This is the footnote.
#
# A -- (long dash) character
#
# # TODO
# A :smile: face emoji
#

# See sed.sf.net for more info about How any of this works.

# Clear all previous main text and read next line
# sed do this automatically to us, so we don't need to do anything.

# No matter what happen DO NOT ALLOW NON-PRINTABLE CHARACTERS IN HTML.
s/&/\&amp;/g;
s/&amp;\(#[0-9]\+\|[a-z]\+\);/\&\1;/g
s/[[:space:]]\+<[[:space:]]\+/ \&lt; /g;
s/[[:cntrl:]]/ /g;

# If the line is empty, branch to `start`.
/^$/b start;

# If the line ends in "  " (two spaces), delete it and add a </br>
s#  $#</br>#;

# Add line to hold space. (prefixed with a `newline` character)
H;


# If the line is a valid header, branch to `start`.
/^=\(\|=\|==\|===\|====\|=====\)[[:space:]]*[^=]\+$/b start

# If the line ends in a single . (period), branch to `start`
/\([^\.]\|^\)\.$/{ s/.*//; b start;}

# If the line is the last line, branch to `start`.
$b start;

# Start new cycle.
b;

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

# Delete lines starting with #.
/^[[:space:]]*#/d;

# If main text is empty, start new cycle.
/^$/b;

# NOTE: Use \(\\C\|[^C\n]\)* where C is the character of the attribute,
# NOTE: so the user can add C inside the attribute, for example:
# NOTE: *Italic text with \* inside it*

# NOTE: Use \([^\\]\|^\) to allow the user to escape attributes, for example:
# NOTE: This is a normal text and has \* inside it, and here is \* another one
# NOTE: Don't forget to add \1 at the start of the replacement string

# If the line ends in \ (backslash), concatenate it with the next one.
s/\\\n//g

# = Header
s#^=[[:space:]]*\([^=]\+.*\)$#<h1>\1</h1>#;
s#^==[[:space:]]*\([^=]\+.*\)$#<h2>\1</h2>#;
s#^===[[:space:]]*\([^=]\+.*\)$#<h3>\1</h3>#;
s#^====[[:space:]]*\([^=]\+.*\)$#<h4>\1</h4>#;
s#^=====[[:space:]]*\([^=]\+.*\)$#<h5>\1</h5>#;
s#^======[[:space:]]*\([^=]\+.*\)$#<h6>\1</h6>#;

# EDGE CASE: No empty line before a header.
s#\n=[[:space:]]*\([^=]\+.*\)$#</p>\n<h1>\1</h1>#;
s#\n==[[:space:]]*\([^=]\+.*\)$#</p>\n<h2>\1</h2>#;
s#\n===[[:space:]]*\([^=]\+.*\)$#</p>\n<h3>\1</h3>#;
s#\n====[[:space:]]*\([^=]\+.*\)$#</p>\n<h4>\1</h4>#;
s#\n=====[[:space:]]*\([^=]\+.*\)$#</p>\n<h5>\1</h5>#;
s#\n======[[:space:]]*\([^=]\+.*\)$#</p>\n<h6>\1</h6>#;

# > embed text (recursively)
:embedtext
s#\(\n\|^\)\(>[[:space:]]*\(.[^\n]*\)\(\n\|$\)\)\+#<blockqoute>\n&\n</blockqoute>#g;
s/\n>[[:space:]]*/\n/g;
/\n>/b embedtext;

# **BOLD** text
s#\([^\\]\|^\)\*\*\(\(\\\*\|[^\*\n]\)*\)\*\*#\1<b>\2</b>#g;

# *Italic* text
s#\([^\\]\|^\)\*\(\(\\\*\|[^\*\n]\)*\)\*#\1<i>\2</i>#g;

# ~~Text with a stroke~~
s#\([^\\]\|^\)[-~][-~]\(\(\\[-~]\|[^-~\n]\)*\)[-~][-~]#\1<del>\2</del>#g;

# _Text with an underline_
s#\([^\\]\|^\)_\(\(\\_\|[^_\n]\)*\)_#\1<ins>\2</ins>#g;

# ^super^ text
# X^2^
s#\([^\\]\|^\)\^\(\(\\\^\|[^\^\n]\)*\)\^#\1<sup>\2</sup>#g;

# ~sub~ text
# H~2~O
s#\([^\\]\|^\)~\(\(\\~\|[^~\n]\)*\)~#\1<sub>\2</sub>#g;

# =sub= script # Only works on alpha numeric characters
# H=2=O
s#\([^\\]\|^\)=\([[:alnum:]]*\)=#\1<sub>\2</sub>#g;

# `code` text
s#\([^\\]\|^\)`\(\(\\`\|[^`\n]\)*\)`#\1<code>\2</code>#g;

# TODO: Add images
## IMAGE: https://path/to/an/image.png @WIDTHxHEIGHT@ [https://path/to/go/when/user/clicks] (Image title) {Image alt}
## Image caption

# NOTE: To escape a link, it should be like `https\://an/escaped/link`
# https://path/to/a/link (Link caption)
# <https://path/to/a/link> (Link caption)
s#\(<\|\)\([[:alnum:]]\+\)\(://[a-zA-Z0-9/%?+&=\#_\.-]\+\)\(>\|\)[[:space:]]*(\([^)\n]*\))#<a href="\2\\\3">\5</a>#g;

# https://path/to/a/link
# <https://path/to/a/link>
s#\(<\|\)\([[:alnum:]]\+://[a-zA-Z0-9/%?+&=\#_\.-]\+\)\(>\|\)#<a href="\2">\2</a>#g;

# NOTE: To escape an email link, it should be like `mailto\:me@mywebsite.org`
# mailto:me@mywebsite.org (Email caption)
# <mailto:me@mywebsite.org> (Email caption)
s#\(<\|\)mailto\(:[a-zA-Z0-9/%?+&=\#_\.-]\+\)\(>\|\)[[:space:]]*(\([^)\n]*\))#<a href="mailto\\\2">\4</a>#g;

# mailto:me@mywebsite.org (Email caption)
# <mailto:me@mywebsite.org> (Email caption)
s#\(<\|\)mailto\(:[a-zA-Z0-9/%?+&=\#_\.-]\+\)\(>\|\)[[:space:]]*(\([^)\n]*\))#<a href="mailto\\\2">\4</a>#g;

# Headers
/^<h[1-6]>/{ s/\\\(.\)/\1/g; p; s/.*//; x; d;}

# EDGE CASE: No empty line before a header.
/\n<h[1-6]>[^\n]*<\/h[1-6]>$/{ s/^/<p>/; s/\\\(.\)/\1/g; p; s/.*//; x; d;}

# Paragraphs
s#^#<p>#;
s#$#</p>#;
s/\\\(.\)/\1/g;
p;
d;
