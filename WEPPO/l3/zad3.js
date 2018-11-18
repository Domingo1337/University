function forEach(a, f) {
    for (let i = 0; i < a.length; i++)
        f(a[i])
}

function map(a, f) {
    array = []
    forEach(a, x => array.push(f(x)))

    return array
}

function filter(a, f) {
    array = []
    forEach(a, x => {
        if (f(x))
            array.push(x)
    })

    return array
}

console.log(map([1, 0, 3, 4, 5], (x) => x * x * x))

console.log([1, 2, 3, 4].filter(e => e % 2).map(e => e * e))

forEach([100, 200, 300], (x) => console.log(x / 100))