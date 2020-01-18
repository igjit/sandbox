class Empty

val empty = Empty()

empty.toString()
empty.equals(0)
empty.hashCode()

class Person {
    var name = "Anne"
    var age = 32
}

val a = Person()
val b = Person()

"${a.age} ${b.age}"
a.age = 42
"${a.age} ${b.age}"

class Person(firstName: String, lastName: String, yearOfBirth: Int) {
    val fullName = "$firstName $lastName"
    var age: Int

    init {
        age = 2018 - yearOfBirth
    }
}

class Person(val name: String, var age: Int) {
    constructor(name: String) : this(name, 0)
    constructor(yearOfBirth: Int, name: String)
        : this(name, 2018 - yearOfBirth)
}

val a = Person("Jaime", 35)
val b = Person("Jack")
val c = Person(1995, "Lynne")

class Person(age: Int) {
    var age = 0
        set(value) {
            if (value < 0) throw IllegalArgumentException(
                "Age cannot be negative")
            field = value
        }

    val isNewborn
        get() = age == 0

    init {
        this.age = age
    }
}

val baby = Person(0)
baby.isNewborn

class Person(val name: String) {
    fun present() {
        println("Hello, I'm $name!")
    }
}

Person("Claire").present()

// Lateinit

class Person() {
    lateinit var name: String
}

val p = Person()
p.name = "foo"

// Infix functions

class Person(val name: String) {
    infix fun marry(spouse: Person) {
        println("$name and ${spouse.name} are getting married!")
    }
}

val lisa = Person("Lisa")
val anne = Person("Anne")
lisa marry anne

// Operators

class Person(val name: String) {
    operator fun plus(spouse: Person) {
        println("$name and ${spouse.name} are getting married!")
    }
}

val lisa = Person("Lisa")
val anne = Person("Anne")
lisa + anne

// Enum classes

enum class ContentKind(val kind: String) {
    TOPIC("Topic"),
    ARTICLE("Article"),
    EXERCISE("Exercise"),
    VIDEO("Video"),
    ;

    override fun toString(): String {
        return kind
    }
}

ContentKind.TOPIC
ContentKind.TOPIC.toString()

// Data classes

data class ContentDescriptor(val kind: ContentKind, val id: String) {
    override fun toString(): String {
        return kind.toString() + ":" + id
    }
}

ContentDescriptor(ContentKind.TOPIC, "abcd").toString()
