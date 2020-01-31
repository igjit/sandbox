fun Byte.toUnsigned(): Int {
    return if (this < 0) this + 256 else this.toInt()
}

val x: Byte = -1
x.toUnsigned()

val Byte.unsigned: Int get() = if (this < 0) this + 256 else this.toInt()

x.unsigned
