var http = require('http');
var express = require('express');
var app = express();
var multer = require('multer');

var upload = multer({ dest: 'uploads/' });

app.set('view engine', 'ejs');
app.set('views', './views');

app.use(express.urlencoded({ extended: true }));

app.use('/uploads/', express.static('uploads'));

app.get('/', (req, res) => {
    res.render('upload');
});

app.post('/uploaded', upload.single('filename'), function (req, res, next) {
    res.end(`Your file was preserved on ${req.file.path}`);
})

http.createServer(app).listen(3000);
