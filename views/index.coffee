@title = 'Beurre de Sel - Personal Scrapbook'
@description = 'My scrapbook blog about food, cooking, gardening and things of note'
#@stylesheets = [
#  {inline:"
#    l-header {background-image:url(../images/header/#{@data.headerImg}.jpg);}
#  "}
#]

section id:'articles', class:'l-mytitle', ->
  for x in @data.articles[0..10]
    article id:x.key.replace(/\//g,'-'), ->
      x.article

aside id:'piclinks', ->
  header -> h2 -> "Favourites"
  div ->
    for x in @data.notes.piclinks
      a href:x.link, ->
        img src:x.src, alt:x.title