@title = "LJS - Any questions?"
@longtitle = "Any questions?"
@description = "Frequently asked questions about our services and our service policies"
@introtext = "Some of the more frequently asked questions about our services are answered here."
@script = inline:'''
$(function(){
  $(".answer").hide();
  $(".question").click(function(evt){
   $(evt.target).next().toggle();
  });
});
'''
@style = '''
  section {width:600px;font-size:1.3em;}
  article {padding-top:20px;color:#AB4F0A}
  .question{color:gray;font-style:italic;cursor:pointer;}

  form {padding-top:20px;}
  #subject,textarea{width:460px;}
  label,input,textarea {display:block;}
'''
@iehack = '''
'''

article ->
  p class:'question', -> 'How long have you been been in business?'
  p class:'answer', -> 'I have been professionally servicing vehicles for over 15 years. However, our door to door service is a relatively new venture.'
article ->
  p class:'question', -> 'What form of payment do you accept?'
  p class:'answer', -> 'We can only accept cash or cheque at the present, but we hope to be able to accept all major credit cards very soon.'
article ->
  p class:'question', -> 'Are there any cars that you do not service?'
  p class:'answer', -> 'We service all makes and models.'
article ->
  p class:'question', -> 'What kind of guarantee do you provide?'
  p class:'answer', -> 'We offer 12 months manufacturers warranty on all parts fitted. We also guarantee to beat any confirmed quote from any of our local competitors.'
article ->
  p class:'question'
  p class:'answer'

p "If you have any other questions you would like us to answer, just enter a few details about the nature 
  of your query together with an email address or a telephone number and we will get back to you asap."

partial 'emailform'