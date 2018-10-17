for (var n = 2; n < 100000; n++) {
    var k = 2;
    var is_prime = true;
    while (k <= Math.sqrt(n) && is_prime) {
        if (n % k == 0) {
            is_prime = false;
        }
        k++
    }
    if (is_prime) {
        console.log(n)
    }
}
