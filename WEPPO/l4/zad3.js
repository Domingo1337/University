var Foo = function () {
    console.log('Foo')
}

Foo.prototype.Bar = function () {
    function Qux() {
        console.log('Qux')
    }
    Qux()
    console.log('Bar')
}

var f = new Foo()
f.Bar()

// nie da sie
// f.Qux()