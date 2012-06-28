@title = 'Cookery - Beure de sel'
@description = 'Cookery musings and a whole lot of recepies'
@stylesheets = [
  {inline:"
    header {background-image:url(../images/header/#{@data.headerImg}.jpg);}
  "}
]
section id:'articles', ->
  for x in @data.articles
    article id:x.key.replace(/\//g,'-'), ->
      text x.article
      if x.comments
        a href:'', -> 
          text x.comments.length
          text ' comment'
          if x.comments.length > 1
            text 's'

aside id:'notes', ->
  header -> h2 -> "Favourites"
  text @data.notes.article if @data.notes
