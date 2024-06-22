import psutil
import subprocess


def list_chrome_processes():
    chrome_processes = []
    for proc in psutil.process_iter(['pid', 'name']):
        if proc.info['name'] == 'Google Chrome':
            chrome_processes.append(proc.info['pid'])
    return chrome_processes


def count_open_windows(process_id):
    applescript = f"""
    on run {{processID}}
        set windowCount to 0
        tell application "System Events"
            set allProcesses to every process whose unix id is processID
            if (count of allProcesses) > 0 then
                set theProcess to first item of allProcesses
                set windowCount to count of windows of theProcess
            end if
        end tell
        return windowCount
    end run
    """
    cmd = ['osascript', '-e', applescript, str(process_id)]
    result = subprocess.run(cmd, capture_output=True, text=True)
    if result.returncode == 0:
        return int(result.stdout.strip())
    else:
        raise Exception(f"AppleScript error: {result.stderr}")


def kill_process(pid):
    try:
        process = psutil.Process(pid)
        process.terminate()  # or process.kill()
        process.wait(timeout=3)  # Wait for the process to terminate
        print(f"Process {pid} terminated successfully.")
    except psutil.NoSuchProcess:
        print(f"No such process with PID {pid}.")
    except psutil.AccessDenied:
        print(f"Access denied to terminate process with PID {pid}.")
    except psutil.TimeoutExpired:
        print(
            f"Timeout expired while trying to terminate process with PID {pid}."
        )
    except Exception as e:
        print(f"An error occurred: {e}")


def chrome_gc():
    # List Chrome processes
    chrome_pids = list_chrome_processes()
    print(f"Chrome processes: {chrome_pids}")

    # Count windows for a specific Chrome process
    if chrome_pids:
        # Replace chrome_pids[0] with the specific PID you're interested in
        # pid = chrome_pids[0]
        for pid in chrome_pids:
            # windows_count = count_chrome_windows(pid)
            windows_count = count_open_windows(pid)
            print(
                f"Number of windows for Chrome process {pid}: {windows_count}")
            if int(windows_count) <= 0:
                print(
                    f'Chrome process {pid} has no open windows. killing it...')
                kill_process(pid)

    else:
        print("No Chrome processes found.")


# if __name__ == "__main__":
#     chrome_gc()
