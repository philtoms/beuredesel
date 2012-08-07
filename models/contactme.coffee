module.exports = (view, ctx, render) ->

  view.pagescript = ctx.comments
  view.layout = false
  view.data = 
    headerImg: 'chutney'

  render()