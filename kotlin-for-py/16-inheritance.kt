// Subclassing

open class MotorVehicle(val maxSpeed: Double, val horsepowers: Int)
class Car(val seatCount: Int, maxSpeed: Double) : MotorVehicle(maxSpeed, 100)

val car = Car(4, 120.0)

// Overriding

open class MotorVehicle(val maxSpeed: Double, val horsepowers: Int) {
    open fun drive() = "$horsepowers HP motor vehicle driving at $maxSpeed MPH"
}

class Car(val seatCount: Int, maxSpeed: Double) : MotorVehicle(maxSpeed, 100) {
    override fun drive() = super.drive() + " with $seatCount seats"
}

MotorVehicle(200.0, 100).drive()
Car(4, 200.0).drive()

// Interfaces

interface Driveable {
    val maxSpeed: Double
    fun drive(): String
}

open class MotorVehicle(override val maxSpeed: Double, val wheelCount: Int) : Driveable {
    override fun drive() = "Wroom!"
}

// Polymorphism

fun boast(mv: MotorVehicle) =
    "My ${mv.wheelCount} wheel vehicle can drive at ${mv.maxSpeed} MPH!"

fun ride(d: Driveable) =
    "I'm riding my ${d.drive()}"

val mv = MotorVehicle(200.0, 100)
boast(mv)
ride(mv)

// Delegation

interface PowerSource {
    val horsepowers: Int
}

class Engine(override val horsepowers: Int) : PowerSource

open class MotorVehicle(val engine: Engine): PowerSource by engine

MotorVehicle(Engine(100)).horsepowers
