#!/bin/sed -nf
#n
# Made by Jumps Are Op (jumpsareop@gmail.com)
# This software is under GPL version 3 and comes with ABSOLUTELY NO WARRANTY

/^$/{ x; /^$/b; x;}
/^[[:space:]]*#/b
s#^[=-]\{3,\}$#<hr/>#
s#  $#<br/>#

s#&#&amp;#g;s#&amp;\(\#[[:digit:]]\{1,\}\|[[:lower:]]\{1,\}\);#\&\1;#g
s/[[:space:]]\{1,\}<[[:space:]]\{1,\}/ \&lt; /g

# ```lang
# Some code in some language.
# ```
/^```[[:alnum:]~._-]*$/{
	x; s#..*#<p>&</p>#p; s###; x;
	s#^```$#<pre><code>#p
	s#^```\(.*\)$#<pre><code class="language-\1">#p
	s#.*##
	:cblock
	N
	s#&#&amp;#g;s#&amp;\(\#[[:digit:]]\{1,\}\|[[:lower:]]\{1,\}\);#\&\1;#g
	s/[[:space:]]\{1,\}<[[:space:]]\{1,\}/ \&lt; /g
	/\n```$/!{ $!b cblock;}
	s#^\n##; s#```$#</code></pre>#
	p;b
}

# Attributes
s#\\\\#\\~#g
s#\(^\|[^\\]\)\*\*\(\(\\\*\|.\)*\)\*\*#\1<b>\2</b>#g
s#\(^\|[^\\]\)\*\(\(\\\*\|.\)*\)\*#\1<i>\2</i>#g
s#\(^\|[^\\]\)~~\(\(\\~\|.\)*\)~~#\1<s>\2</s>#g
s#\(^\|[^\\]\)_~\(\(\\~\|.\)*\)~_#\1<u>\2</u>#g
s#\(^\|[^\\]\)^\(\(\\^\|.\)*\)^#\1<sup>\2</sup>#g
s#\(^\|[^\\]\)=\([[:alnum:]~._-]\+\)=#\1<sub>\2</sub>#g
s#\(^\|[^\\]\)~\(\(\\~\|.\)*\)~#\1<sub>\2</sub>#g
s#\(^\|[^\\]\)`\(\(\\`\|.\)*\)`#\1<code>\2</code>#g
s#\\~#\\#g
s#\\\(.\)#\1#g

# Foot notes^[1].
#
# 1. A foot note.
s#\(^\|[^\\]\)\^\[\([[:digit:]]\{1,\}\)]#\1<a name="footnote-ref-\2" href="\#footnote-\2"><sup>\2</sup></a>#g
s#^[[:space:]]*\([[:digit:]]\{1,\}\)\.#<a name="footnote-\1" href="\#footnote-ref-\1">\1</a>.#

# = A header.
# == Another header.
/^=\{1,6\}[[:space:]]*[^=].*$/{
    x; s#..*#<p>&</p>#p; s###; x;
	s#^======[[:space:]]*\(.*\)$#<h6>\1</h6>#p
	s#^=====[[:space:]]*\(.*\)$#<h5>\1</h5>#p
	s#^====[[:space:]]*\(.*\)$#<h4>\1</h4>#p
	s#^===[[:space:]]*\(.*\)$#<h3>\1</h3>#p
	s#^==[[:space:]]*\(.*\)$#<h2>\1</h2>#p
	s#^=[[:space:]]*\(.*\)$#<h1>\1</h1>#p
    b
}

# [An externial link](some.link.to/page.html)
s#\(^\|[^\\]\)\[\(\(\\]\|[^]]\)*\)][[:space:]]*(\([^[:space:])]*\))#\1<a href="\4">\2</a>#g

# IMAGE: https://link.to/image.png
# Image description.
\#^[Ii][Mm][Aa][Gg][Ee][[:space:]]*:[[:space:]]*\([^[:space:]]\{1,\}\([[:space:]]\{1,\}.*\)\?\)$#{
    s##\1#; x; s#$#<figure><a><img src="#; G
	s#\n\([^[:space:]\n]*\)\([[:space:]][^\n]*\|\)$#\1"\2></a><figcaption>#; x
	s#.*$#---#
}

# Paragraphs
H; x; s/^\n//;

/\n$/b end
/\.$/b end
s#\n---$##
$!{ x;b;}

:end
s#\n$##
/<figcaption>/s#.*#<p>&\n</figcaption></caption></p>#p
/<figcaption>/!s#.*#<p>&</p>#p
x; s###; x

/^$/{ x; /^$/b; x;}
/^[[:space:]]*#/b
