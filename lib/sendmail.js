var nodemailer = require('nodemailer/lib/nodemailer');

module.exports.send = function(req, email){
// Set up SMTP server settings
var smtpTransport = nodemailer.createTransport("SMTP",{
    service: "Gmail",
    auth: {
        user: email.user,
        pass: email.pwd
    }
});

var mailOptions = {
    from: req.body.name +"<"+req.body.replyto+">", // sender address
    to: email.user, // list of receivers
    subject: req.body.subject,
    text: 'Email enquiry from ' + req.body.name +'\n\r' +
         'Reply to: ' + req.body.replyto +'\n\r' +
         'message: ' + req.body.text,
    html:'<p><b>Email enquiry from ' + req.body.name +'</b></p>' +
         '<p>Reply to: <a href="mailto:' + req.body.replyto + '">'+req.body.replyto+'</a></p>' +
         '<p>' + req.body.text + '</p>'
};

smtpTransport.sendMail(mailOptions, function(error, response){
    if(error){
        console.log(error);
    }else{
        console.log("Message sent: " + response.message);
    }

    // if you don't want to use this transport object anymore, uncomment following line
    //smtpTransport.close(); // shut down the connection pool, no more messages
});
}