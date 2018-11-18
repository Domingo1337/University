var human = {
    name: "",
    say_hi: () =>
        console.log(`hi im ${this.name}`)

}

human.age = 100

human.speak = () => console.log(`hi im ${human.name} im ${human.age} years old`)

Object.defineProperty(human, "name", {
    get: () => this.name,
    set: (name) => this.name = name
}
)

human.say_hi()

human.name = "wiktor"
human.say_hi()
human.speak()
