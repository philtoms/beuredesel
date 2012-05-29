module.exports = (view, ctx, render) ->

  pageFilter = (k) -> k.indexOf('page/')==0 # filter all pages

  ctx.store.find pageFilter, (e,d) => 
    
    pageData = new ctx.data d, ctx.sort
    
    view.data = 
      headerImg: 'chutney'
      articles: pageData.find (f) -> f.key.indexOf("/topten")<0
      notes: pageData.first (f) -> f.key.indexOf("/topten")>0

    render()