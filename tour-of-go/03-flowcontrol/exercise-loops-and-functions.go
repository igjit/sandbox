package main

import (
	"fmt"
	"math"
)

const Tolerance = 1e-10

func Sqrt(x float64) (float64, int) {
	z := 1.0
	i := 0
	for ; ; i += 1 {
		diff := z*z - x
		if math.Abs(diff) < Tolerance {
			break
		}
		z -= diff / (2*z)
	}
	return z, i
}

func main() {
	fmt.Println(Sqrt(2))
	fmt.Println(Sqrt(3))
	fmt.Println(Sqrt(4))
}
