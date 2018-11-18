function createFs(n) {
    var fs = []

    for (var i = 0; i < n; i++) {
        fs[i] = function () {
            return i
        }
    }
    return fs
}

function createFs_2(n){
    var fs = []

    function addF(i) {
        fs[i] = function () {
            return i
        }
    }

    for (var i = 0; i < n; i++) {
        addF(i)
    }
    return fs
}

var myfs = createFs_2(10)
console.log(myfs[0]()) // zerowa funkcja miała zwrócić 0
console.log(myfs[2]()) // druga miała zwrócić 2
console.log(myfs[7]())
