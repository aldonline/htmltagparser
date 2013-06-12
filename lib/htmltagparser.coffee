# Private HTML element reference.
# Please mind the gap (1 space at the beginning of each subsequent line).
tags =
  # Valid HTML 5 elements requiring a closing tag.
  regular: 'a abbr address article aside audio b bdi bdo blockquote body button
 canvas caption cite code colgroup datalist dd del details dfn div dl dt em
 fieldset figcaption figure footer form h1 h2 h3 h4 h5 h6 head header hgroup
 html i iframe ins kbd label legend li map mark menu meter nav noscript object
 ol optgroup option output p pre progress q rp rt ruby s samp script section
 select small span strong style sub summary sup table tbody td textarea tfoot
 th thead time title tr u ul var video'

  # Valid self-closing HTML 5 elements.
  void: 'area base br col command embed hr img input keygen link meta param
 source track wbr'

  obsolete: 'applet acronym bgsound dir frameset noframes isindex listing
 nextid noembed plaintext rb strike xmp big blink center font marquee multicol
 nobr spacer tt'

  obsolete_void: 'basefont frame'

tags.list = [tags.regular,tags.void,tags.obsolete,tags.obsolete_void].join(' ').split ' '

html_tag_re = ///
^
  ([\w\-]+)?          # optional tag name
  ( [#] ([\w\-]+) )?  # optional ID
  (( \. [\w\-]+ )*)   # optional classes
$   
///i

# in most browsers regular expression matching groups
# are set to undefined/null when they don't match.
# Internet explorer, however, sets them to the empty string.
# thus we need a smarter 'null' check than ( str? )
str_ok = (s) -> s? and ( 'string' is typeof s ) and ( s isnt '' )

low_level_html_tag_parser = ( tag ) ->
  ###
[ 'p#id.class1.class2',  #0
  'p',                   #1
  '#id',                 #2
  'id',                  #3
  '.class1.class2',      #4
  '.class2',             #5
  index: 0,
  input: 'p#id.class1.class2' ]
  ###
  [_,name,_,id,classes] = tag.trim().match html_tag_re
  tag     : if str_ok(name) then name else 'div'
  id      : id
  classes : if str_ok( classes ) then classes.split('.')[1..] else []

parse_html_tag = ( str ) ->
  throw new ParseError '(empty string)' if str.length is 0
  throw new ParseError tag unless ( t = low_level_html_tag_parser str )?
  throw new UnknownTagError t.tag unless t.tag in tags.list
  new HTMLTag t.tag, t.id, t.classes

###
@tag      the type of tag ( div, input, etc )
@id       optional ID string ( '#my-form' --> 'my-form' )
@classes  array of strings containing classes
###
class HTMLTag
  constructor:( @tag, @id, @classes ) ->

class ParseError extends Error
  constructor: ( tag ) ->
    @message = "[htmltagparser] Can't parse HTML tag: '#{tag}'"

class UnknownTagError extends Error
  constructor: ( tag ) ->
    @message = "[htmltagparser] Unknown HTML tag: '#{tag}'"


parse_html_tag.ParseError
parse_html_tag.UnknownTagError

# parse string into an HTMLTag object with "tag, id, classes"
module.exports = parse_html_tag
