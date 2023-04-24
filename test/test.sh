#!/bin/sh -e

# Made by jumps are op
# This software is under GPL version 3 and comes with ABSOLUTELY NO WARRANTY

# Test for jmu.sed

# Configuration
: "${JMU:=../jmu.sed}"

q="'"
tmp=$(echo "mkstemp(\`/tmp/tmp.XXXXXX')" | m4)

testjmu(){
	"$JMU" <&3 >"$tmp"
	diff --color=auto -- "$tmp" - <&4 || { cat "$tmp"; rm -f "$tmp"; exit 1;}
}

# <h1>Basic HTML is support</h1>.
exec 3<<TEST
<h1>Basic HTML is support</h1>.
TEST
exec 4<<ANS
<h1>Basic HTML is support</h1>.
ANS
testjmu

# # Any line start with a # is a comment and will be ignored.
exec 3<<TEST
# Any line start with a # is a comment and will be ignored.
TEST
exec 4<<ANS
ANS
testjmu

# Lines grouped together
# will be merged.
exec 3<<TEST
Lines grouped together
will be merged.
TEST
exec 4<<ANS
<p>Lines grouped together
will be merged.</p>
ANS
testjmu

# Lines ending with a . (period) won't be merged together.
# Lines ending with a "  " (two spaces) will add a newline at the end  
testjmu 3<<-EOF 4<<-EOF
Lines ending with a . (period) won't be merged together.
Lines ending with a "  " (two spaces) will add a newline at the end  
EOF
<p>Lines ending with a . (period) won${q}t be merged together.</p>
<p>Lines ending with a "  " (two spaces) will add a newline at the end<br/></p>
EOF

# *Italic text*
# **BOLD text**
# ~~Text with stroke~~
# --Also text with stroke--
# --This is also a text with stroke~~
# _Text with an underline_
# ^super^ script
# X^2^
#  =sub= script
# H=2=O
# ~sub~ script
# H~2~O
# A `code` text
exec 3<<TEST
*Italic text*
**BOLD text**
~~Text with stroke~~
--Also text with stroke--
--This is also a text with stroke~~
_Text with an underline_
^super^ script
X^2^
# Only works on alpha numeric characters AND cannot be at the start of the line
 =sub= script
H=2=O
~sub~ script
H~2~O
A \`code\` text
TEST
exec 4<<ANS
<p><i>Italic text</i>
<b>BOLD text</b>
<del>Text with stroke</del>
<del>Also text with stroke</del>
<del>This is also a text with stroke</del>
<ins>Text with an underline</ins>
<sup>super</sup> script
X<sup>2</sup>
 <sub>sub</sub> script
H<sub>2</sub>O
<sub>sub</sub> script
H<sub>2</sub>O
A <code>code</code> text</p>
ANS
testjmu

# >
#  embedded text
# >>
#   *embedded* **text** ~with~ _attributes_
# >>
# >
exec 3<<TEST
>
 embedded text
 *embedded* **text** ~with~ _attributes_
>>
  double embedded text
  double *embedded* **text** ~with~ _attributes_
>>
>
TEST
exec 4<<ANS
<blockquote><p>
 embedded text
 <i>embedded</i> <b>text</b> <sub>with</sub> <ins>attributes</ins>
<blockquote><p>
  double embedded text
  double <i>embedded</i> <b>text</b> <sub>with</sub> <ins>attributes</ins>
</p></blockquote>
</p></blockquote>
ANS
testjmu

# = Header 1
# == Header 2
# === Header 3
# ==== Header 4
# ===== Header 5
# ====== Header 6
exec 3<<TEST
= Header 1
== Header 2
=== Header 3
==== Header 4
===== Header 5
====== Header 6
Paragraph
=Header 1
Paragraph
==Header 2
Paragraph
===Header 3
Paragraph
====Header 4
Paragraph
=====Header 5
Paragraph
======Header 6
TEST
exec 4<<ANS
<h1>Header 1</h1>
<h2>Header 2</h2>
<h3>Header 3</h3>
<h4>Header 4</h4>
<h5>Header 5</h5>
<h6>Header 6</h6>
<p>Paragraph</p>
<h1>Header 1</h1>
<p>Paragraph</p>
<h2>Header 2</h2>
<p>Paragraph</p>
<h3>Header 3</h3>
<p>Paragraph</p>
<h4>Header 4</h4>
<p>Paragraph</p>
<h5>Header 5</h5>
<p>Paragraph</p>
<h6>Header 6</h6>
ANS
testjmu

# IMAGE: https://path/to/an/image.png [HTML ATTRIBUTES]
# IMAGE: https://path/to/an/image.png WIDTH[*|X|x| ]HEIGHT [HTML ATTRIBUTES]
# IMAGE: [:/]/path/to/a/local/image.png [HTML ATTRIBUTES]
# IMAGE: [:/]/path/to/a/local/image.png WIDTH[*|X|x| ]HEIGHT [HTML ATTRIBUTES]
# Image caption until the end of the paragraph.
exec 3<<TEST
IMAGE: https://path/to/an/image.png attr="value"
caption.
IMAGE: https://path/to/an/image.png 10x20 attr="value"
caption.
IMAGE: ://path/to/a/local/image.png attr="value"
caption.
IMAGE: ://path/to/a/local/image.png 10x20 attr="value"
caption.
IMAGE: /path/to/a/local/image.png attr="value"
caption.
IMAGE: /path/to/a/local/image.png 10x20 attr="value"
caption.
IMAGE: https://path/to/an/image.png
caption.
IMAGE: https://path/to/an/image.png 10x20
caption.
IMAGE: ://path/to/a/local/image.png
caption.
IMAGE: ://path/to/a/local/image.png 10x20
caption.
IMAGE: /path/to/a/local/image.png
caption.
IMAGE: /path/to/a/local/image.png 10x20
caption.
TEST
exec 4<<ANS
<p><figure><a href="https://path/to/an/image.png">
<img src="https://path/to/an/image.png" attr="value">
</a><figcaption>
caption.
</figcaption></figure></p>
<p><figure><a href="https://path/to/an/image.png">
<img src="https://path/to/an/image.png" width="10" height="20" attr="value">
</a><figcaption>
caption.
</figcaption></figure></p>
<p><figure><a href="/path/to/a/local/image.png">
<img src="/path/to/a/local/image.png" attr="value">
</a><figcaption>
caption.
</figcaption></figure></p>
<p><figure><a href="/path/to/a/local/image.png">
<img src="/path/to/a/local/image.png" width="10" height="20" attr="value">
</a><figcaption>
caption.
</figcaption></figure></p>
<p><figure><a href="/path/to/a/local/image.png">
<img src="/path/to/a/local/image.png" attr="value">
</a><figcaption>
caption.
</figcaption></figure></p>
<p><figure><a href="/path/to/a/local/image.png">
<img src="/path/to/a/local/image.png" width="10" height="20" attr="value">
</a><figcaption>
caption.
</figcaption></figure></p>
<p><figure><a href="https://path/to/an/image.png">
<img src="https://path/to/an/image.png">
</a><figcaption>
caption.
</figcaption></figure></p>
<p><figure><a href="https://path/to/an/image.png">
<img src="https://path/to/an/image.png" width="10" height="20">
</a><figcaption>
caption.
</figcaption></figure></p>
<p><figure><a href="/path/to/a/local/image.png">
<img src="/path/to/a/local/image.png">
</a><figcaption>
caption.
</figcaption></figure></p>
<p><figure><a href="/path/to/a/local/image.png">
<img src="/path/to/a/local/image.png" width="10" height="20">
</a><figcaption>
caption.
</figcaption></figure></p>
<p><figure><a href="/path/to/a/local/image.png">
<img src="/path/to/a/local/image.png">
</a><figcaption>
caption.
</figcaption></figure></p>
<p><figure><a href="/path/to/a/local/image.png">
<img src="/path/to/a/local/image.png" width="10" height="20">
</a><figcaption>
caption.
</figcaption></figure></p>
ANS
testjmu

# NOTE: Link captions can be on another line of a link,
# NOTE: this is a feature not a bug!
# NOTE: forward captions have priority over backward captions
# https://path/to/a/link
# <https://path/to/a/link>
# https://path/to/a/link (Link caption)
# <https://path/to/a/link> (Link caption)
# (Link caption) https://path/to/a/link
# (Link caption) <https://path/to/a/link>
# mailto:me@mywebsite.org
# <mailto:me@mywebsite.org>
# mailto:me@mywebsite.org (My email)
# <mailto:me@mywebsite.org> (My email)
# (My email) mailto:me@mywebsite.org
# (My email) <mailto:me@mywebsite.org>
# ://path/to/a/local/link
# <://path/to/a/local/link>
# ://path/to/a/local/link (Link caption)
# <://path/to/a/local/link> (Link caption)
# (Link caption) ://path/to/a/local/link
# (Link caption) <://path/to/a/local/link>
exec 3<<TEST
https://path/to/a/link
<https://path/to/a/link>
https://path/to/a/link (Link caption)
<https://path/to/a/link> (Link caption)
(Link caption) https://path/to/a/link
--
(Link caption) <https://path/to/a/link>
mailto:me@mywebsite.org
<mailto:me@mywebsite.org>
mailto:me@mywebsite.org (My email)
<mailto:me@mywebsite.org> (My email)
(My email) mailto:me@mywebsite.org
--
(My email) <mailto:me@mywebsite.org>
://path/to/a/local/link
<://path/to/a/local/link>
://path/to/a/local/link (Link caption)
<://path/to/a/local/link> (Link caption)
(Link caption) ://path/to/a/local/link
--
(Link caption) <://path/to/a/local/link>
TEST
exec 4<<ANS
<p><a href="https://path/to/a/link">https://path/to/a/link</a>
<a href="https://path/to/a/link">https://path/to/a/link</a>
<a href="https://path/to/a/link">Link caption</a>
<a href="https://path/to/a/link">Link caption</a>
<a href="https://path/to/a/link">Link caption</a>
--
<a href="https://path/to/a/link">Link caption</a>
<a href="mailto:me@mywebsite.org">me@mywebsite.org</a>
<a href="mailto:me@mywebsite.org">me@mywebsite.org</a>
<a href="mailto:me@mywebsite.org">My email</a>
<a href="mailto:me@mywebsite.org">My email</a>
<a href="mailto:me@mywebsite.org">My email</a>
--
<a href="mailto:me@mywebsite.org">My email</a>
<a href="/path/to/a/local/link">path/to/a/local/link</a>
<a href="/path/to/a/local/link">path/to/a/local/link</a>
<a href="/path/to/a/local/link">Link caption</a>
<a href="/path/to/a/local/link">Link caption</a>
<a href="/path/to/a/local/link">Link caption</a>
--
<a href="/path/to/a/local/link">Link caption</a></p>
ANS
testjmu

# Text before a horizontal rule
# ---
# Text after a horizontal rule
exec 3<<TEST
Text before a horizontal rule
---
Text after a horizontal rule
TEST
exec 4<<ANS
<p>Text before a horizontal rule
<hr/>
Text after a horizontal rule</p>
ANS
testjmu

# ```sh
# 	echo "A multi line code text"
# ```
exec 3<<"TEST"
```sh
echo "A multi
line

code text"
```
```
echo "A multi
line

code text"
```
TEST
exec 4<<ANS
<pre><code class="language-sh">echo "A multi
line

code text"
</code></pre>
<pre><code>echo "A multi
line

code text"</code></pre>
ANS
testjmu

# A --- (long dash) character
exec 3<<TEST
A --- (long dash) character
TEST
exec 4<<ANS
<p>A &ndash; (long dash) character</p>
ANS
testjmu

# # TODO
# NOTE: A note block.
#
# # TODO
# NOTE:
# 	Also a multi line
# 	Note block (until the end of the paragraph)
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
# # TODO
# A :smile: face emoji
#

echo "Tests done successfully"
