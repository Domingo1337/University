for (var n = 1; n < 100000; n++) {
    var d = n
    var divides = true
    var digits = 0
    while (d > 0 && divides) {
        if (n % (d % 10) == 0) {
            digits += d % 10
            d = Math.floor(d / 10)
        } else {
            divides = false;
        }
    }
    if (divides && n % digits == 0) {
        console.log(n)
    }
}
