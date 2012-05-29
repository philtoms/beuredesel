@title = "LJS - Low Cost Services"
@longtitle = 'Check out our service prices '
@description = 'The lowest service prices in the area - guaranteed'
@introtext='Come rain or shine, we service your car right outside your front door, or in your workplace car park.'
@style='''
  td.price {
   padding:5px 15px 5px 5px;
   background-color:#FFD800;
   border:solid 2px yellow;
   font-size:2em;
   padding-left:40px;
   color:red;
   text-shadow:2px 2px 2px white, -2px -2px 2px white, -2px 2px 2px white, 2px -2px 2px white;
  }
  td p {font-size:0.5em;}
'''
table ->
  thead ->
    tr ->
      th ".service", -> 'Service'
      th ".price", -> 'Price from'
  tbody ->
    tr ->
      td ".service", ->
        text 'Interim Service'
        p 'Front brake check wheels off, Lights check - all levels, Oil change and oil filter, Anti freeze check for strength, Visual safety check, Service light reset, Stamp service book'
      td ".price", -> '&pound;39'
    tr ->
      td ".service", -> 
        text 'Full Service'
        p 'All of the above plus: Air filter, Spark plugs (if required), Rear brakes checked cleaned and adjusted, Pollen filter checked (extra charge for replacement)'
      td ".price", -> '&pound;89'
    tr ->
      td ".service", -> 'Brakes'
      td ".price", -> '&pound;39'
    tr ->
      td ".service", -> 'Cam Belts'
      td ".price", -> '&pound;99'
    tr ->
      td ".service", -> 
        text 'Diagnostics Code Read'
        p 'covers abs, air bag, engine warning lamp'
      td ".price", -> '&pound;20'
