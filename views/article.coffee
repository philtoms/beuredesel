@title = 'Cookery - Beurre de sel'
@description = 'Cookery musings and a whole lot of recepies'
@stylesheets = [
  {inline:"
    #cmdbar {display:inline;}
    .l-header {background-image:url(../images/header/#{@data.headerImg}.jpg);}
  "}
]
section id:'articles', ->
  article id:@data.id, class:'l-mytitle', ->
    @data.article

section id:'commentry', ->
  div id:'cmdbar', -> 
    a href:'#add', -> "Comment on this article"
  div id:'comments', ->
    if @data.comments
      for x in @data.comments
        article ->
          header ->
            h3 x.name
            time x.date
          div class:'text edit', -> x.text

