import json
import subprocess

def main():
    spaces_count_str = cmd("yabai -m query --spaces")
    spaces = json.loads(spaces_count_str)
    print(len(spaces))
    spaces_count = len(spaces)

    windows_str = cmd("yabai -m query --windows")
    windows = json.loads(windows_str)

    seen_spaces = set()
    for window in windows:
        space = int(window["space"])
        seen_spaces.add(space)

    for i in range(spaces_count, 0, -1):
        if i not in seen_spaces:
            print(f"deleting space: {i}")
            cmd(f"yabai -m space --destroy {i}")

def cmd(command):
    try:
        result = subprocess.run(command.split(), capture_output=True, check=True, text=True)
        return result.stdout
    except subprocess.CalledProcessError as e:
        print("cmd error: ", e)
        print(e.stdout)
        exit(1)

if __name__ == "__main__":
    main()
