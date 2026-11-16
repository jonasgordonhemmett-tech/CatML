import subprocess

def run(cmd):
    return subprocess.run(["powershell", "-Command", cmd], capture_output=True, text=True)

def write(file, text):
    with open(f"data/{file}.txt", "w", encoding="utf-8") as f:
        f.write(str(text))

def ocaml(file):
    full_cmd = ""
    if file:
        try:
            with open(f"data/{file}.txt") as _:
                pass
        except:
            print(f"File {file} not found!")
        else:
            full_cmd = (
                "(& opam env) -split '\r?\n' | ForEach-Object { Invoke-Expression $_ }; "
                "dune build; "
                f"dune exec ./src/main.exe -- data/{file}.txt"
            )
    else:
        full_cmd = (
            "(& opam env) -split '\r?\n' | ForEach-Object { Invoke-Expression $_ }; "
            "dune build; "
            f"dune exec ./src/main.exe --"
        )

    r = run(full_cmd)

    print("Return code:", r.returncode)
    print("STDOUT:", r.stdout)

def menu():
    while True:
        choice = input("[1: Read file in OCaml, 2: Create new file, 3: Run test cases, 0: Exit]: ")

        match choice:
            case "1":
                choice2 = input("[Enter file name, 0: exit]: ")

                if choice2 != "0": ocaml(choice2)
            case "2":
                choice2 = input("[Enter file name, 0: exit]: ")

                choice3 = input("[Enter expression]: ")
                write(choice2, choice3)
            case "3":
                ocaml("")
                
            case "0":
                break
if __name__ == "__main__":
    menu()

