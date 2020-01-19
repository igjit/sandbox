throw IllegalArgumentException("Value must be positive")

fun divideOrZero(numerator: Int, denominator: Int): Int {
    return try {
        numerator / denominator
    } catch (e: ArithmeticException) {
        0
    }
}

divideOrZero(6, 2)
divideOrZero(1, 0)
