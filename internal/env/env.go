package env

import "strings"

func ExtractVariables(env []string) map[string]string {
	vars := make(map[string]string)

	for _, line := range env {
		result := strings.Split(line, "=")
		if len(result) >= 2 {
			n := result[0]
			v := strings.Join(result[1:], "=")
			vars[n] = v
		}
	}

	return vars
}

func ExtractNames(vars map[string]string) []string {
	names := make([]string, 0)

	for n := range vars {
		names = append(names, n)
	}

	return names
}
