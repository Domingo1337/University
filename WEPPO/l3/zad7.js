function fib() {
    let f_1 = 0
    let f_2 = 1

    return {
        next: function () {
            [f_1, f_2] = [f_1 + f_2, f_1]
            return {
                value: f_1,
                done: f_1 > 100
            }
        }
    }
}

function* fibo() {
    let f_1 = 1
    let f_2 = 0
    yield f_1
    while (true) {
        [f_1, f_2] = [f_1 + f_2, f_1]
        yield f_1
    }
}

var foo = {
    [Symbol.iterator]: fib
}

for (f of foo)
  console.log(f)

// NIE
// for (n of fib())
    // console.log(n)

// TAK
// for (n of fibo())
    // console.log(n)

function* take(it, top) {
    for (i = 0; i < top; i++)
        yield it.next().value
}

for (n of take(fib(), 7))
    console.log(n)
