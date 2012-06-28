module.exports = (view, ctx, render) ->

  key = ctx.page+"/"+view.params.id
  filter = (k) -> k.indexOf(key)==0 

  ctx.store.find filter, (e,d) => 

    view.pagescript = ctx.comments
    view.data = 
      id: key.replace(/\//g,'-')
      headerImg: 'chutney'
      article: d[key].article
      comments: new ctx.data d[key].comments, ctx.sort 

    render()