var fs = require('fs')

fs.readFile('6.in', (error, data) => {
    if (error) {
        console.log('Could not open file due to ' + error)
    } else {
        console.log(data.toString('utf8'))
    }
})