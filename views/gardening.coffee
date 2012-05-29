@title = 'Gardening - Susieflooz '
@description = 'A day in the life of my garden, mainly pics'
@stylesheets = [
  {inline:"
    header {background-image:url(../images/header/#{@data.headerImg}.jpg);}
  "}
]

section id:'articles', ->
  for x in @data.articles
    article id:x.key.replace(/\//g,'-'), ->
      x.article

aside id:'notes', ->
  h2 -> "Things of note"
  text @data.notes.article if @data.notes
