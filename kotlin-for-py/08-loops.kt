val names = listOf("Anne", "Peter", "Jeff")
for (name in names) {
    println(name)
}

for (x in 0..10) println(x)

(0..9).toList()

for ((index, value) in names.withIndex()) {
    println("$index: $value")
}

var x = 0
while (x < 10) {
    println(x)
    x++ // Same as x += 1
}

outer@ for (n in 2..100) {
    for (d in 2 until n) {
        if (n % d == 0) continue@outer
    }
    println("$n is prime")
}
