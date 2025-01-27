import subprocess
import sys
import time

retries = 3
cmd = [arg for arg in sys.argv[1:] if arg and arg != '""']
delay = 2

for attempt in range(retries):
    try:
        subprocess.run(cmd, check=True)
        sys.exit(0)
    except subprocess.CalledProcessError as e:
        print(f"Command failed (attempt {attempt + 1}/{retries}):")
        print(f"  Return code: {e.returncode}")
        print(f"  stdout: {e.stdout.decode() if e.stdout else '<empty>'}")
        print(f"  stderr: {e.stderr.decode() if e.stderr else '<empty>'}")

        if attempt < retries - 1:
            print(f"Retrying in {delay} seconds...")
            time.sleep(delay)
            delay *= 2
        else:
            print("Command failed after multiple retries.")
            sys.exit(1)
