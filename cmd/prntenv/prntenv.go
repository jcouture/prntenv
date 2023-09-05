// Copyright 2023 Jean-Philippe Couture
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

package main

import (
	"flag"
	"fmt"
	"sort"

	"github.com/fatih/color"
	"github.com/jcouture/env"
	"github.com/lithammer/fuzzysearch/fuzzy"
)

var flagNoColor bool
var flagSort bool

func init() {
	flag.Usage = func() {
		w := flag.CommandLine.Output()

		fmt.Fprintf(w, "Utility to print out the names and values of the variables in the environment\n")
		fmt.Fprintf(w, "\nUsage:\n  prntenv [flag] [name]\n")

		fmt.Fprintf(w, "\nFlags:\n")
		flag.PrintDefaults()
	}

	flag.BoolVar(&flagNoColor, "no-color", false, "Disable color output")
	flag.BoolVar(&flagSort, "sort", false, "Sort alphabetically by name")
}

func main() {
	flag.Parse()

	if flagNoColor {
		color.NoColor = true
	}

	vars := env.Getvars()
	names := env.Getnames(vars)

	if flagSort {
		sort.Strings(names)
	}

	name := flag.Arg(0)

	if name != "" {
		matches := fuzzy.FindFold(name, names)
		printVars(matches, vars)
	} else {
		printVars(names, vars)
	}
}

func printVar(n, v string) {
	fmt.Printf("%v=%v\n", color.HiGreenString(n), color.HiBlueString(v))
}

func printVars(names []string, vars map[string]string) {
	for _, n := range names {
		printVar(n, vars[n])
	}
}
