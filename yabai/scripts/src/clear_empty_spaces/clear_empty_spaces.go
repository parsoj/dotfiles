package main

import (

	// "os"
	"encoding/json"
	"fmt"
	"os"
	"os/exec"
	"strings"

	"github.com/sanity-io/litter"
)

func main() {
	spaces_count_str := cmd("yabai -m query --spaces")
	var spaces []interface{}
	err := json.Unmarshal([]byte(spaces_count_str), &spaces)
	if err != nil {
		print("unmarshall error: ", err)
	}
	litter.Dump(len(spaces))
	spaces_count := len(spaces)

	windows_str := cmd("yabai -m query --windows")

	var windows []interface{}
	err = json.Unmarshal([]byte(windows_str), &windows)
	if err != nil {
		print("unmarshall error: ", err)
	}

	seen_spaces := make(map[int]bool)
	for i := 0; i < len(windows); i++ {
		window := windows[i]
		space := int(window.(map[string]interface{})["space"].(float64))
		seen_spaces[space] = true

	}

	for i := spaces_count; i >= 1; i-- {
		if _, ok := seen_spaces[i]; !ok {

			print("deleting space: ", fmt.Sprint(i), "\n")
			cmd("yabai -m space --destroy " + fmt.Sprint(i))
		}
	}

}

func cmd(command string) string {
	fields := strings.Fields(command)

	out, err := exec.Command(fields[0], fields[1:]...).Output()

	if err != nil {
		print("cmd error: ")
		fmt.Println(err)
		fmt.Println(string(out))
		os.Exit(1)
	}

	return string(out)

}

// # # loop though SPACES_LIST in reverse
// # # that way when we delete spaces the indexes don't change/shift
// # for i in (seq (count $SPACES_LIST) -1 1)
// #     set space = (echo $SPACES_LIST | jq -r '.[$i]')
// #     echo $space
// #     exit

// #     set index (echo $space | jq -r '.index')
// #     set windows (echo $space | jq -r '.windows')

// #     # if the space is empty, delete it
// #     if test (count $windows) -eq 0
// #         echo "Deleting space $index"
// #         # yabai -m space $index --destroy
// #     end
// # end
