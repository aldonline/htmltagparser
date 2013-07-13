valid_html_tags = require './valid_html_tags'
syntax_parser   = require './syntax_parser'

###
parse string into an object with "tag, id, classes"
throws ParseError, UnknownTagError

returns:
@tag      the type/name of tag ( div, input, etc )
@id       optional ID string ( '#my-form' --> 'my-form' ) ( null if no ID )
@classes  array of strings containing classes ( empty if no classes )
###
module.exports = main = ( str ) ->

  # 1. sanity
  unless typeof str is 'string'
    throw new ParseError '(undefined)'
  if str.length is 0
    throw new ParseError '(empty string)'

  # 2. syntax
  unless ( t = syntax_parser str )?
    throw new ParseError str 

  # 3. semantics
  { tag, id, classes } = t
  tag = tag.toLowerCase()

  unless valid_html_tags tag
    throw new UnknownTagError tag 
  
  { tag, id, classes }


main.ParseError = class ParseError extends Error
  constructor: ( tag ) ->
    @message = "[htmltagparser] Can't parse HTML tag: '#{tag}'"

UnknownTagError = class UnknownTagError extends Error
  constructor: ( tag ) ->
    @message = "[htmltagparser] Unknown HTML tag: '#{tag}'"