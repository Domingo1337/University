function createGenerator(stop) {
    return () => {
        var _state = 0
        return {
            next: function () {
                return {
                    value: _state,
                    done: _state++ >= stop
                }
            }
        }
    }
}
var foo = {
    [Symbol.iterator]: createGenerator(5)
}

for (f of foo)
    console.log(f)