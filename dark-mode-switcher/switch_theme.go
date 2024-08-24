package main

import (
	"fmt"
	"os"
	"os/exec"
)

func main() {
	// Check if exactly one argument is provided
	if len(os.Args) != 2 {
		fmt.Println("Error: Exactly one argument ('light' or 'dark') is required.")
		os.Exit(1)
	}

	// Get the argument
	arg := os.Args[1]

	// Determine which command to run based on the argument
	var cmd *exec.Cmd
	switch arg {
	case "light":
		// Run the command for light mode
		cmd = exec.Command("/opt/homebrew/bin/kitten", "themes", "--reload-in=all", "dayfox")
	case "dark":
		// Run the command for dark mode
		cmd = exec.Command("/opt/homebrew/bin/kitten", "themes", "--reload-in=all", "Tokyo Night")
	default:
		// Invalid argument
		fmt.Println("Error: Invalid argument. Please use 'light' or 'dark'.")
		os.Exit(1)
	}

	// Execute the command and capture output
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	if err := cmd.Run(); err != nil {
		fmt.Println("Error running command:", err)
		os.Exit(1)
	}
}
