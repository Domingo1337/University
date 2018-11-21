var Tree = function (left, value, right) {
    return {
        left: left,
        value: value,
        right: right,
        [Symbol.iterator]: function* () {
            function* iter_tree(tree) {
                if (tree.left != null)
                    yield* iter_tree(tree.left)

                yield tree.value

                if (tree.right != null)
                    yield* iter_tree(tree.right)
            }
            yield* iter_tree(this)
        }
    }
}

var root = new Tree(new Tree(new Tree(null, 1, null), 2, null), 3, new Tree(null, 4, null))

console.log(root)

for (v of root)
    console.log(v)