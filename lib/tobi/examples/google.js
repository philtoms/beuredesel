/**
 * Module dependencies.
 */

var tobi = require('../')
//  , should = require('should')
  , browser = tobi.createBrowser(80, 'http://173.194.67.99');

browser.get('/', function(res){
  res.should.have.status(200);
  browser.click("input[name=btnG]", function(res, $){
    $('title').should.have.text('Google');
  });
});