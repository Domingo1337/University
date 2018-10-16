function fib_rec(n) {
    if (n == 0) return 0
    if (n == 1) return 1
    return fib_rec(n - 1) + fib_rec(n - 2)
}

function fib_iter(n) {
    if (n == 0) return 0
    if (n == 1) return 1
    var f_2 = 0
    var f_1 = 1
    for (i = 2; i < n; i++) {
        var temp = f_1
        f_1 = f_1 + f_2
        f_2 = temp
    }
    return f_1 + f_2
}

for (i = 0; i < 15; i++) {
    console.log(i)
    console.time("rec")
    fib_rec(i)
    console.timeEnd("rec")
    console.time("iter")
    fib_iter(i)
    console.timeEnd("iter")
}