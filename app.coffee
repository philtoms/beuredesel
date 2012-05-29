susieflooz = (port, fn) ->
 require('./myZappa') port, 'blog.db', ->

  @use @express.bodyParser({uploadDir:'./public/uploads'}), @app.router, 'static', 'cookies'
 
  @io.set 'log level', 1
  app = this

  @nav [
      'Articles:index'
      'Cookery'
      'Gardening'
      'ContactMe'
    ]

  @post '/sendform' : ->
    require('./lib/sendmail').send.call(this, @request,app.data.email)
    @redirect '/'
 
  @js '/googlea.js': '''
      var _gaq = _gaq || [];
    _gaq.push(['_setAccount', googleId]);
    _gaq.push(['_trackPageview']);
  
    (function() {
      var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
      ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
      var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
    })();
  '''
  
  if fn then fn()
  
module.exports = susieflooz
