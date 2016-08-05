'use strict';

var mongoose = require('mongoose');
mongoose.connect(process.env.MONGOHQ_URL);
//const mongooseConnection = mongoose.c(process.env.MONGOHQ_URL);

var express = require('express');
var favicon = require('serve-favicon');
var logger = require('morgan');
var cookieParser = require('cookie-parser');
var bodyParser = require('body-parser');
var app = express();
var compression = require('compression');

app.use(compression({threshold: 0}));

app.use(favicon(__dirname + '/public/img/favicon.ico'));
app.use(logger('dev'));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded());
app.use(cookieParser());

var passport = require('passport');
//http://code.tutsplus.com/tutorials/authenticating-nodejs-applications-with-passport--cms-21619

var session = require('express-session');
var MongoStore = require('connect-mongo')(session);
app.use(session({
    secret: 'mySecretKey',
    maxAge: new Date(Date.now() + 3600000),
    store: new MongoStore({ mongooseConnection: mongoose.connection })
}));

app.use(express.static(__dirname + '/public'));

app.set('views', __dirname + '/app/ui/views');
app.set('view engine', 'ejs');

app.use(passport.initialize());
app.use(passport.session());

// Using the flash middleware provided by connect-flash to store messages in session
// and displaying in templates
var flash = require('connect-flash');
app.use(flash());

app.use('/api', require('./app/api'));
// Initialize Passport
var initPassport = require('./app/passport/init');
initPassport(passport);

var routes = require('./app/ui/routes')(passport);
app.use('/', routes);

app.use(function (req, res) {
    res.send(404);
});

/*jshint unused:false */
app.use(function (err, req, res, next) {
    res.send(500, {
        err: err.stack
    });
});
/*jshint unused:true */
module.exports = app;
