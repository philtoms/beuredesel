store=null
data=null
viewsync=null
comments=null

defaultModel = (view, ctx, render) ->
  
  defaultHeaderImg = 
    cookery:'peppers'
    gardening:'gardenwall'

  ctx.store.find ctx.filter, (e,d) ->
  
    pageData = new ctx.data d, ctx.sort
    
    id=ctx.page+'/'+view.params.id
    head=(pageData.first (f) -> f.key==id) || {}
    headerImg = head.headerImg ?= defaultHeaderImg[view.name] ?='chutney'

    view.pagescript = viewsync
    view.data = 
      headerImg: headerImg
      articles: pageData.find (f) -> f.key.indexOf(ctx.page+"/topten")<0
      notes: pageData.first (f) -> f.key==ctx.page+"/topten"

    render()

bind = (id) ->
  
  return (render,view) ->
  
    view = view[id]
    
    # direct to single page?
    mId=id
    if view.params.id
        mId="article"
    
    try
      model = require './'+mId
    catch err
      model = defaultModel

    ctx =
      store: store
      data: data
      viewsync: viewsync
      comments: comments
      sort: ( s1,s2) -> Date.parse(s2.date) - Date.parse(s1.date)
      filter: (key) -> key.indexOf(ctx.page)==0
      page: 'page/'+view.name

    model view,ctx, -> 
      modelView = []
      modelView[mId] = view
      render modelView
    
module.exports.build = (s, v, c) ->
  
  store = s
  viewsync = v
  comments = c
  data = require('../lib/data')

  return bind