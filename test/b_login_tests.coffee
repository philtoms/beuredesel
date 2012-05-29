vows = require 'vows'
assert = require 'assert'

#mock fakes =
vows
  .describe('login tests')
  .addBatch

    'browse to the main page':
      topic: -> 
        debugger
        browser.get '/', this.callback.bind(this,null)
        return
        
      'Type magic keys'  :
        topic: (res,$) -> 
          debugger
          evt = {type:'click',altKey:true}
          $('#scrapbook').trigger evt

        'and the login dialog should appear': (topic) ->
          assert.equal topic,2

  .run()
  