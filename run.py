import subprocess

def run(cmd):
    return subprocess.run(["powershell", "-Command", cmd], capture_output=True, text=True)

def write(file):
    file = file.split(".")[0]

    try:
        with open(f"data/{file}.txt") as _:
            pass
    except:
        pass
    else:
        while True: 
            match input("File already exits [1: Cancel, 0: Overwrite]: "):
                case "1":
                    return
                case "0":
                    break
            
    with open(f"data/{file}.txt", "w", encoding="utf-8") as f:
        f.write(str( input("[Enter expression]: ")
))

def ocaml(file):
    full_cmd = ""
    if file:
        file = file.split(".")[0]
        
        try:
            with open(f"data/{file}.txt") as f:
                print(f"AST: {f.read()}")
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

    print(r.stdout)

def menu():
    print("______________________")
    print("---= Jonas's CatML --- ")
    print()
    while True:
        match input("[1: Read file in OCaml, 2: Create new file, 3: Run test cases, 0: Exit]: "):
            case "1":
                choice2 = input("[Enter file name, 0: exit]: ")

                if choice2 != "0": ocaml(choice2)
            case "2":
                choice2 = input("[Enter file name, 0: exit]: ")

                write(choice2)
            case "3":
                ocaml("")
                
            case "0":
                break
    print("Goodbye!")
if __name__ == "__main__":
    menu()

