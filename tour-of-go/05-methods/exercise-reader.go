package main

import "golang.org/x/tour/reader"

type MyReader struct{}

func (r MyReader) Read(rb []byte) (n int, e error) {
	e = nil
	for n = 0; n < len(rb); n++ {
		rb[n] = 'A'
	}
	return
}

func main() {
	reader.Validate(MyReader{})
}
