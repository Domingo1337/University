// 1
var Tree = function (left, value, right) {
    this.left = left
    this.value = value
    this.right = right
}
var root = new Tree(new Tree(new Tree(null, 1, null), 2, null), 5, null)

console.log(root)

// 2
function* iter_tree(tree) {
    if (tree.left != null)
        yield* iter_tree(tree.left)

    yield tree.value

    if (tree.right != null)
        yield* iter_tree(tree.right)

}

for (v of iter_tree(root))
    console.log(v)