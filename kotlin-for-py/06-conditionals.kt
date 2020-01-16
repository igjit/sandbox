val age = 42
if (age < 10) {
    println("You're too young to watch this movie")
} else if (age < 13) {
    println("You can watch this movie with a parent")
} else {
    println("You can watch this movie")
}

val x = -1
if (x > 0) x else -x

1 == 1
1 != 2

1 == 1 && 1 != 2
!true

val x = 42
when (x) {
    0 -> "zero"
    in 1..9 -> "single digit"
    else -> "multiple digits"
}
