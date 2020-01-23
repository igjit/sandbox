// Function types

fun safeDivide(numerator: Int, denominator: Int) =
    if (denominator == 0) 0.0 else numerator.toDouble() / denominator

safeDivide(1, 0)

val f = ::safeDivide

val quotient = f(3, 0)

// Function literals: lambda expressions and anonymous functions

val safeDivide = { numerator: Int, denominator: Int ->
    if (denominator == 0) 0.0 else numerator.toDouble() / denominator
}

fun callAndPrint(function: (Int, Int) -> Double) {
    println(function(2, 0))
}

callAndPrint({ numerator, denominator ->
    if (denominator == 0) 0.0 else numerator.toDouble() / denominator
})

val square: (Double) -> Double = { it * it }

fun callWithPi(function: (Double) -> Double) {
    println(function(3.14))
}

callWithPi(square)
callWithPi { it * it }
callWithPi(fun(x: Double) = x * x)

// Comprehensions

class Person(val name: String)
val people = listOf(Person("foo"), Person("bar"), Person("buzzzzzzzz"))

val shortGreetings = people.filter { it.name.length < 10 }.map { "Hello, ${it.name}!" }

// Receivers

class Car(val horsepowers: Int)

val boast: Car.() -> String = { "I'm a car with $horsepowers HP!" }

val car = Car(120)
car.boast()

class TreeNode(val name: String) {
    val children = mutableListOf<TreeNode>()

    fun node(name: String, initialize: (TreeNode.() -> Unit)? = null) {
        val child = TreeNode(name)
        children.add(child)
        if (initialize != null) {
            child.initialize()
        }
    }
}

fun tree(name: String, initialize: (TreeNode.() -> Unit)? = null): TreeNode {
    val root = TreeNode(name)
    if (initialize != null) {
        root.initialize()
    }
    return root
}

val t = tree("root") {
    node("math") {
        node("algebra")
        node("trigonometry")
    }
    node("science") {
        node("physics")
    }
}

// Nice utility functions

123?.run { toString() }

123?.let { it.toString() }

123?.apply { println(this * 2) }

123?.also { println(it * 2) }

50.takeIf { it >= 42 } ?. let { it * it }
