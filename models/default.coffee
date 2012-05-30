ctx =
  sort: ( s1,s2) -> Date.parse(s2.date) - Date.parse(s1.date)
  filter: (key) -> key.indexOf(page)==0

defaultModel = (view, ctx, render) ->

  page = 'page/'+view.name
  
  pageSort = ( s1,s2) -> Date.parse(s2.date) - Date.parse(s1.date)
  pageFilter = (key) -> key.indexOf(page)==0 

  defaultHeaderImg = 
    cookery:'peppers'
    gardening:'gardenwall'
    
  ctx.store.find pageFilter, (e,d) ->
  
    pageData = new ctx.data d, pageSort
    
    id=page+'/'+view.params.id
    head=(pageData.first (f) -> f.key==id) || {}
    headerImg = head.headerImg ?= defaultHeaderImg[view.name] ?='chutney'

    view.data = 
      headerImg: headerImg
      articles: pageData.find (f) -> f.key.indexOf(page+"/topten")<0
      notes: pageData.first (f) -> f.key==page+"/topten"

    render()

bind = (id) ->
  return (r, v) ->
    try
      model = require './'+id
    catch err
      model = defaultModel

    model v[id],ctx, -> r v
    
module.exports.build = (s) ->
  
  ctx.store = s
  ctx.data = require('../lib/data')

  return bind