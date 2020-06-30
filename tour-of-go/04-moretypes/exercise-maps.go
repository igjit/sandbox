package main

import (
	"golang.org/x/tour/wc"
	"strings"
)

func WordCount(s string) map[string]int {
	m := make(map[string]int)
	for _, key := range strings.Fields(s) {
		m[key] += 1
	}
	return m
}

func main() {
	wc.Test(WordCount)
}
