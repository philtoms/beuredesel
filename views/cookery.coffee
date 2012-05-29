@title = 'Cookery - Susieflooz'
@description = 'Cookery musings and a whole lot of recepies'
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
