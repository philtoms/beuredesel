vows = require 'vows'
assert = require 'assert'

#mock fakes =
  
sut = require '../lib/data.coffee'

vows
  .describe('data tests')
  .addBatch

    'Create data from rray':
      topic: -> new sut [{a:'dataA'},{b:'dataB'}]
  
      'should return data array': (topic) ->
        assert.equal topic[0].a, 'dataA'

    'Create data from object':
      topic: -> new sut {1:{a:'dataA'},2:{b:'dataB'}}
  
      'should return data array': (topic) ->
        assert.equal topic[0].key, 1
        assert.equal topic[0].a, 'dataA'

    'Create sorted data from object':
      topic: -> new sut {2:{b:'dataB'},1:{a:'dataA'}}, (a,b) -> a.key - b.key
  
      'should return data array': (topic) ->
        assert.equal topic[0].key, 1
        assert.equal topic[0].a, 'dataA'

  .run()
  