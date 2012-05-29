var nodemailer = require('nodemailer/lib/mail');

module.exports.send = function(req, email){
// Set up SMTP server settings
nodemailer.SMTP = {
    host: 'smtp.gmail.com',
    port: 465,
    use_authentication: true,
    ssl: true,
    user: email.user,
    pass: email.pwd,
    debug: true
};

// unique cid value for the embedded image
var cid = Date.now() + '.image.png';

// Message object
var message = {
    sender: 'LJS Website <ljsmobileautoservices@gmail.com>',
    to: 'pip.squeek@hotmail.co.uk',
    subject: req.body.subject,

    body: 'Email enquiry from ' + req.body.name +'\n\r' +
         'Reply to: ' + req.body.replyto +'\n\r' +
         'message: ' + req.body.text,
    html:'<p><b>Email enquiry from ' + req.body.name +'</b></p>' +
         '<p>Reply to: <a href="mailto:' + req.body.replyto + '">'+req.body.replyto+'</a></p>' +
         '<p>' + req.body.text + '</p>'
};

// Callback to be run after the sending is completed
var callback = function(error, success){
    if(error){
        console.log('Error occured');
        console.log(error.message);
        return;
    }
    if(success){
        console.log('Message sent successfully!');
    }else{
        console.log('Message failed, reschedule!');
    }
};

// Catch uncaught errors
process.on('uncaughtException', function(e){
    console.log('Uncaught Exception', e.stack);
});

// Send the e-mail
var mail;
try{
    mail = nodemailer.send_mail(message, callback);
}catch(e) {
    console.log('Caught Exception',e);
}

var oldemit = mail.emit;
mail.emit = function(){
    console.log('Mail.emit', arguments);
    oldemit.apply(mail, arguments);
};
}