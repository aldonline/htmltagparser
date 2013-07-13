


lookup_map = null # lazy

 # returns true if a tag is valid. false otherwise
module.exports = ( tag ) ->
  ( lookup_map ?= build_lookup_map() )[ tag.toLowerCase() ] is true

build_lookup_map = ->

  # Valid HTML 5 elements requiring a closing tag.
  regular = 'a abbr address article aside audio b bdi bdo blockquote body button
 canvas caption cite code colgroup datalist dd del details dfn div dl dt em
 fieldset figcaption figure footer form h1 h2 h3 h4 h5 h6 head header hgroup
 html i iframe ins kbd label legend li map mark menu meter nav noscript object
 ol optgroup option output p pre progress q rp rt ruby s samp script section
 select small span strong style sub summary sup table tbody td textarea tfoot
 th thead time title tr u ul var video'

  # Valid self-closing HTML 5 elements.
  self_closing = 'area base br col command embed hr img input keygen link meta param
 source track wbr'

  obsolete = 'applet acronym bgsound dir frameset noframes isindex listing
 nextid noembed plaintext rb strike xmp big blink center font marquee multicol
 nobr spacer tt'

  obsolete_self_closing = 'basefont frame'

  all = [ regular, self_closing, obsolete, obsolete_self_closing ].join(' ').split ' '

  # a map will be faster for lookups
  map = {}
  map[k.trim()] = yes for k in all when k isnt ' '

  map
