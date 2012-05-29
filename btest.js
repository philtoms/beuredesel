require("coffee-script"); 
var tobi = require('./lib/tobi')
    ,injectr = require('./lib/injectr');
    
function test(file){
  injectr('test/'+file+'_tests.coffee',{context:{browser:browser}});
}

console.log("")

//  , should = require('should')
browser = tobi.createBrowser(3000, 'localhost', { external: true });

if (process.argv[2])
  injectr(process.argv[2]);

else {
  test('b_login');
}
