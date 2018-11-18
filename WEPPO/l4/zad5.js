process.stdin.setEncoding('utf8')
process.stdin.on('readable', () => {
    let input = process.stdin.read()
    process.stdout.write('Witaj ' + input)
});