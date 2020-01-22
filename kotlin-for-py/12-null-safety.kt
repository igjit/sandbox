// Working with nulls

fun test(a: String, b: String?) {
    if (b != null) {
        println(b.length)
    }
}

test("a", "b")
test("a", null)

// Safe call operator

var x = "a"
x?.length

// Elvis operator

x ?: "foo"

// Not-null assertion operator

val x: String? = null
val y: String = x!!

val y: String = x ?: throw Exception("Useful message")
