var http = require('http');
var express = require('express');
var cookieParser = require('cookie-parser');
var app = express();

app.set('view engine', 'ejs');
app.set('views', './views');
app.use(cookieParser());


app.use("/deletecookie", (req, res) => {
    if (req.cookies.cookie) {
        res.clearCookie('cookie');
    }
    res.render("nocookie", { cookieValue: req.cookies.cookie });
});

app.use("/", (req, res) => {
    var cookieValue;
    if (!req.cookies.cookie) {
        cookieValue = new Date().toString();
        res.cookie('cookie', cookieValue);
    } else {
        cookieValue = req.cookies.cookie;
    }
    res.render("cookieindex", { cookieValue: cookieValue });
});


http.createServer(app).listen(3000);
