function fib(n) {
    if (n == 0) return 0
    if (n == 1) return 1
    return fib(n - 2) + fib(n - 1)
}

function memoize(f) {
    var cache = {}

    return function (n) {
        if (n in cache) {
            return cache[n]
        } else {
            cache[n] = f(n)
            return cache[n]
        }
    }
}

function fib_cached(n) {
    if (typeof fib_cached.cache == 'undefined')
        fib_cached.cache = {
            0: 0,
            1: 1
        }

    if (n in fib_cached.cache) {
        return fib_cached.cache[n]
    } else {
        fib_cached.cache[n] = fib_cached(n - 2) + fib_cached(n - 1)
        return fib_cached.cache[n]
    }

}

var fib_memed = memoize(fib)

function measure_time(n) {
    console.log('Time for fib(' + n + ')')
    console.time('memoized')
    var m = fib_memed(n)
    console.timeEnd('memoized')
    console.time('cached')
    var c = fib_cached(n)
    console.timeEnd('cached')
    console.time('fib')
    var f = fib(n)
    console.timeEnd('fib')
    if (m != f || c != f)
        console.error('wrong values returned')
    else console.log()
}

measure_time(30)
measure_time(31)
measure_time(31)
measure_time(32)