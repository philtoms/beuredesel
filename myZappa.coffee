myZappa = (port,db,app) -> 

 # wrap zappa with extras, then run app in 'myZappa' context

 #helpers to convert a route to text, and then from camelCase to spaced words
 toRoute = (r) -> if (s=r.toLowerCase().split(':')).length==1 
                    '/'+s[0]+'/' 
                  else 
                    if s[1]=='index' then '/' else '/'+s[1]+'/'
 toName  = (r) -> if (s=r.toLowerCase().split(':')).length==1 then s[0] else s[1]
 toTitle = (r) -> r.split(':')[0].replace(/([A-Z])/g, (m)->' '+m.toLowerCase())
                                 .replace(/^../, (m)->m.substr(1).toUpperCase())

 store = require('./lib/nstore').extend(require('./lib/nstore/query')()).new db, ->
  
  zappa.run port, -> # passes this fn to zappa.run
        
    @root = __dirname
    @data = null
    appData = null
    viewsync = null
    defaultModel = (require './models/default').build(store)
      
    store.get 'app', (err,data) =>
      if (err) then console.log err.toString()
      @data = appData = data
      @include './lib/viewsync' 
      viewsync = @viewsync
  
    @nav = (routes) ->
      for t,i in routes
        routes[i] = 
          route: toRoute t
          name:  toName t
          title: toTitle t

        r=routes[i]
        do(r) =>
          model = defaultModel r.name
        
          #use this syntax to get a variable into a key
          routeHandler = {} 
          routeHandler[r.route+':id([0-9]+)?'] = ->

            view = {}
            view[r.name] =
              params: @params
              name: r.name
              routes: routes
              appData: appData
              viewsync: viewsync

            model @render, view
            
          @get routeHandler
           
    # apply 'zappa' context here
    app.apply(this)
    
zappa = require('zappa')
return module.exports = myZappa