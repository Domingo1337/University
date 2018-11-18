function sum(... args){
    let s = 0
    for (x of args)
        s+=x
    return s
}

console.log(sum(1,2,3))
console.log(sum(1,1,1,1,1,1,1))
console.log(sum())