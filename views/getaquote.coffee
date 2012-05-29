@title = "LJS - Get a quote"
@longtitle = "Get a guaranteed price quote"
@description = "Get a guaranteed quote and compare our prices with others."
@introtext = "Just leave a few details about the make and model of your car and an email 
  address or telephone number and we will get back to you asap with a firm quote. If you 
  prefer, you can give us a ring on 
  #{ @app.params.mobile }.
  <p>Either way, you won\'t be disappointed. We guarantee to beat the competition!</p>
"
@script = inline:'''
$(function(){
});
'''
@style = '''
  .content {padding:0 50px;}
  label,input,textarea {display:block;}
'''
@iehack = '''
'''
partial 'emailform'
