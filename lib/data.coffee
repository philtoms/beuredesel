data = (d,s) ->
  toArray = (d) ->
    if typeof d is "object"
      for k,v of d
        v= if typeof v isnt "object" then new Object(v) else v 
        v.key=k
        v
    else d #already array
  
  @slice = (x,y) -> 
    [].slice.apply this, [x,y]

  @find = (fn) -> 
     return ([].filter.call this, fn)

  @first = (fn) -> 
     return @find(fn)[0] ?=null

  # convert this to array, sorted if available
  d = toArray d
  if s? then d = [].sort.call d, s 
  [].push.apply this, d
  return this

  #note return syntax required for injectr
return module.exports = data