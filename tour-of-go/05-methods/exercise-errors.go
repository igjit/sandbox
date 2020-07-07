package main

import (
	"fmt"
	"math"
)

const Tolerance = 1e-10

type ErrNegativeSqrt float64

func (e ErrNegativeSqrt) Error() string {
	return fmt.Sprintf("cannot Sqrt negative number: %v", float64(e))
}

func Sqrt(x float64) (float64, error) {
	z := 1.0
	if x < 0 {
		return 0, ErrNegativeSqrt(x)
	}
	for i := 0; ; i += 1 {
		diff := z*z - x
		if math.Abs(diff) < Tolerance {
			break
		}
		z -= diff / (2 * z)
	}
	return z, nil
}

func main() {
	fmt.Println(Sqrt(2))
	fmt.Println(Sqrt(-2))
}
