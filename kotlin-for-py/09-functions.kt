fun happyBirthday(name: String, age: Int): String {
    return "Happy ${age}th birthday, $name!"
}

fun square(number: Int) = number * number

happyBirthday("Anne", 32)

fun square(number: Int) = number * number
fun square(number: Double) = number * number

square(4)
square(3.14)

fun countAndPrintArgs(vararg numbers: Int) {
    println(numbers.size)
    for (number in numbers) println(number)
}

countAndPrintArgs(1, 2, 3)

val numbers = listOf(1, 2, 3)
countAndPrintArgs(*numbers.toIntArray())
