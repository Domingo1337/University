var http = require('http');
var express = require('express');
var app = express();

app.set('view engine', 'ejs');
app.set('views', './views');

app.use(express.urlencoded({extended:true}));

app.get('/', (req, res) => {
    res.render('index', { imie: '', nazwisko: '', przedmiot: '', zadania: ['', '', '', '', '', '', '', '', '', ''] });
});

app.post('/', (req, res) => {
    var imie = req.body.imie;
    var nazwisko = req.body.nazwisko;
    var przedmiot = req.body.przedmiot;
    var zadania = req.body.zadania;
    if (imie != '' && nazwisko != '' && przedmiot != '') {
        res.render('print', { imie: imie, nazwisko: nazwisko, przedmiot: przedmiot, zadania: zadania.map(e => e == '' ? '0' : e) });
    } else {
        res.render('index', { imie: imie, nazwisko: nazwisko, przedmiot: przedmiot, zadania: zadania });
    }
});

http.createServer(app).listen(3000);
