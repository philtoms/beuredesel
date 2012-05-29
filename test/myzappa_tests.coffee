vows = require 'vows'
assert = require 'assert'

capture = {}

mock fakes =
  zappa : (port,fn) -> new -> 
    capture={}
    capture.app = this
    capture.port = port
    capture.routeHandler=[]
    
    @include = ->
    @use = ->
    @app = {}
    @params = {}
    @express =
      bodyParser: -> 
    @get = (rh) ->
      capture.app.params.id=1
      for r of rh
        capture.routeHandler.push rh
        rh[r].call(this)
    @render = (v) ->
      capture.view = v
    fn.call(this)

  './lib/data': -> {}

  nstore: -> fakes['./lib/nstore']
  './lib/nstore' : 
      extend : -> fakes.nstore()
      new : (db, fn) -> 
        process.nextTick -> fn()
        fakes.nstore()
      get : (key, fn) ->
        fn()
      find : (q,fn) -> 
        fn()
  
  './lib/nstore/query' : ->
  
vows
  .describe('myZappa')
  .addBatch

    'Given that an app is created on port 123 with access to data at db':
      topic: ->
        cb=this.callback
        require('../myZappa.coffee') 123,"db",-> 
          @nav ['ATest:index']
          cb()
        
      'the app should be listening on port 123': ->
        assert.equal capture.port, 123

      'a shared data store object should be available': ->
        assert.isFunction capture.app.store.find
        assert.isFunction capture.app.store.get
        assert.isFunction capture.app.store.data

      'the route should be registered with a handler':  ->
        for r of capture.routeHandler[0]
          assert.equal r, '/:id([0-9]+)?'
          assert.isFunction capture.routeHandler[0][r]

      'the route viewmodel should be created': ->
        assert.equal capture.view.index.route, "index"
        assert.equal capture.view.index.routes[0].route, '/'
        assert.equal capture.view.index.params.id, 1
            
      'the route title should be Capitalised with spaces': (topic) ->
        assert.equal capture.view.index.routes[0].title, 'A test'

  .addBatch

    'Given that an app is created with a range of routes':
      topic:  ->
        cb=this.callback
        require('../myZappa.coffee') 123,"db",-> 
          @nav [
            'A'
            'B:index'
            'C'
          ]
          cb()
        
      'all routes should be registered with a handler':  ->
        for rh in capture.routeHandler
          for r of rh
            assert.isFunction rh[r]

      'B should be the index route': ->
        assert.equal capture.view.c.routes[1].route, '/'
  
  .run()
  