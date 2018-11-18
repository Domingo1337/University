const readline = require('readline');
const fs = require('fs');

// source: http://www.almhuette-raith.at/apache-log/access.log
const rl = readline.createInterface({
    input: fs.createReadStream('access.log'),
});

var IPs = new Map()

rl.on('line', (line) => {
    let ip = line.split(" ")[0]
    if (ip in IPs) {
        IPs[ip]++
    } else {
        IPs[ip] = 1
    }
})

rl.on('close', () => {
    arr = Object.entries(IPs).sort(
        ([k1, v1], [k2, v2]) => {
            if (v1 == v2) return 0
            if (v1 > v2) return -1
            else return 1
        })
    for (let i = 0; i < 3; i++) {
        console.log(arr[i])
    }
})
