@title = "Contact me"
@longtitle = "Contact me at beuredesel"
@description = "Contact dettails and a little be about mw and my website."
@script = inline:'''
$(function(){
});
'''
@style = '''
  .content {padding:0 50px;}
  label,input,textarea {display:block;}
'''

email = {error:''}

article ->
  text "Hi, my name is Susie. This is my blog, my website, where I 
  can share my passions for life and rant about the things that make me mad. I 
  would be so very happy to read your comments on the web pages, but if you would 
  like to contact me directly, just fill in the form below and I will get back to 
  you as soon as possible."

  p email.error.message
  form class:'form', action:'/sendform', method:'post', ->
    input name:'nospam', type:'hidden'
    label for:'name', ->
      text 'Name:'
      span class:'error', -> email.error.name
    input id:'name', name:'name', type:'text', value:email.name
    label for:'email', ->
      text 'Email:'
      span class:'error', -> email.error.replyto
    input id:'email', name:'replyto', type:'text', value:email.replyto
    label for:'subject', ->
      text 'Subject:'
      span class:'error', -> email.error?.subject
    input id:'subject', name:'subject', type:'text', value:email.subject
    label for:'text', ->
      text 'Message:'
      span class:'error', -> email.error.text
    textarea id:'text', cols:'55', rows:'7', name:'text', -> email.text
    br class:'clear'
    div class:'form-buttons', ->
      input type:'submit', value:'Send'