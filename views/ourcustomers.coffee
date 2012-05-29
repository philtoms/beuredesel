@title = 'LJS - Satisfied Customers'
@longtitle = 'Comments from our customers'
@description = 'A selection of recommendations from our satisfied customer base in and around Swadlincote'
@introtext = 'LJS has only been operating a couple of months, but in that time we have already received several warm letters of appreciation of our services.'

@style = '''
  section {width:600px;font-size:1.3em;}
  .quote {color:gray;font-style:italic;padding-top:20px;}
  .customer {text-align:right;}
'''

p 'With the kind permission of our customers, we are proud to present a selection of our recommendations here.'
for x of @data
  article id:x.split('/')[1], ->
    @data[x].article