import subprocess

def run(cmd):
    return subprocess.run(["powershell", "-Command", cmd], capture_output=True, text=True)

if __name__ == "__main__":
    full_cmd = (
        "(& opam env) -split '\r?\n' | ForEach-Object { Invoke-Expression $_ }; "
        "dune build; "
        "dune exec ./src/main.exe -- expr.txt"
    )
    r = run(full_cmd)

    print("Return code:", r.returncode)