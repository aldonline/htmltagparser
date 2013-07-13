

module.exports = syntax_parser = ( tag ) ->
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