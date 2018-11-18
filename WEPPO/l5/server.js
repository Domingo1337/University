var http = require('http')

var server = http.createServer(
    (req, res) => {
        // fajnosc
        res.end(`kuchar ty dzbanie jest ${new Date()}`)
    }
)

server.listen(3000)

console.log('start')
