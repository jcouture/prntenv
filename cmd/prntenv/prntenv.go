package main

import (
	"flag"
	"fmt"
	"os"
	"sort"

	"github.com/fatih/color"
	"github.com/jcouture/prntenv/internal/env"
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

	vars := env.ExtractVariables(os.Environ())
	names := env.ExtractNames(vars)

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
