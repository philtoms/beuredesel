@email = @app.params.email

p @email.error.message
form class:'form', action:'/sendform', method:'post', ->
  input name:'nospam', type:'hidden'
  label for:'name', ->
    text 'Name:'
    span class:'error', -> @email.error.name
  input id:'name', name:'name', type:'text', value:@email.name
  label for:'email', ->
    text 'Email:'
    span class:'error', ->@email.error.replyto
  input id:'email', name:'replyto', type:'text', value:@email.replyto
  label for:'subject', ->
    text 'Subject:'
    span class:'error', ->@email.error.subject
  input id:'subject', name:'subject', type:'text', value:@email.subject
  label for:'text', ->
    text 'Message:'
    span class:'error', ->@email.error.text
  textarea id:'text', cols:'55', rows:'7', name:'text', -> @email.text
  br class:'clear'
  div class:'form-buttons', ->
    input type:'submit', value:'Send Inquiry Now'