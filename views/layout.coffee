doctype 5
html lang:'en', ->
  head ->
    meta charset:'utf-8'
    meta name:'description', content:@description
    meta name:'keywords', content:@keywords
    #meta name:'viewport', content:'user-scalable=no'
    meta name:'google-site-verification', content:'XP3TLQI7dFpP_gMFBgpGcs0Xamm4ETkYNURfh7OPHwg'
    title @title if @title
    script src:'/scripts/head.js'
    script "googleId='#{@appData.google}'; issueNo=#{@appData.issueNo};"
    script @viewsync()
    if @scripts
      for s in @scripts
        if typeof s is 'object'
            text "<script>#{s.inline}</script>" 
        else  
          script(src: s + '.js')
    if @script
      if typeof @script is 'object'
          text "<script>#{@script.inline}</script>" 
      else  
        script(src: @script + '.js')
    link rel: 'stylesheet', href:' http://fonts.googleapis.com/css?family=Homemade+Apple'
    link rel: 'stylesheet', href: 'http://fonts.googleapis.com/css?family=Amatic+SC' 
    link rel: 'stylesheet', href: 'http://fonts.googleapis.com/css?family=Averia+Libre'
    link rel: 'stylesheet', href: '/style/basestyle.css'
#    link rel: 'stylesheet', href: '/scripts/uploadify/uploadify.css'
    if @stylesheets
      for s in @stylesheets
        if typeof s is 'object'
          style s.inline 
        else  
          link rel: 'stylesheet', href: s + '.css'
    link(rel: 'stylesheet', href: @stylesheet + '.css') if @stylesheet
    style @style if @style
    if @iehack
      text '<!--[if lt IE 9]>'
      style @iehack
      text '<![endif]-->'

  body id:@route, ->
    div id:'main', ->
      header ->
        h1 "Beurre De Sel"
        h2 "Passionate tales from my kitchen and beyond"
      nav ->
        ul ->
          for r in @routes
            li -> 
              a href:r.route, -> r.title
              
      text @body
      footer id:'scrapbook', -> 'Scrapbook &copy; 2012 Pts'
