import os
from RISC_V_Assembler import assemble_from_text, load_labels
from pathlib import Path

def read_multiple_files_from_folder(label_map, folder_path):
    """
    Reads all .txt files corresponding to labels and associates them with their respective memory addresses.
    """
    files_info = []
    for label, addr in label_map.items():
        filename = os.path.join(folder_path, f"{label}.txt")
        if not os.path.exists(filename):
            print(f"[WARNING] File for label '{label}' not found: {filename}")
            continue
        try:
            with open(filename, "r") as f:
                asm_text = f.read()
            files_info.append((label, asm_text, addr))
        except Exception as e:
            print(f"[ERROR] Could not read '{filename}': {e}")
    return files_info


def main():
    print("=== RISC-V Assembly Compilation Wrapper ===")
    


    asm_folder = input("Enter the folder containing assembly .txt files: ").strip()
    while not os.path.isdir(asm_folder):
        print("Invalid directory. Please try again.")
        asm_folder = input("Enter the folder containing assembly .txt files: ").strip()

    output_folder = input("Enter the folder where .tv output files will be saved: ").strip()
    Path(output_folder).mkdir(parents=True, exist_ok=True)  # create folder if it doesn't exist

    #2# Load label-to-address map
    print("Choose label input method:")
    print("1 - Enter labels manually")
    print("2 - Provide path to labels.txt file")
    
    choice = input("Your choice [1 or 2]: ").strip()
    while choice not in {"1", "2"}:
        choice = input("Invalid choice. Please enter 1 or 2: ").strip()
        
    labels_path = input("Enter the path to(Whether we writing or Reading ) 'labels.txt': ").strip()
    while not os.path.isfile(labels_path):
        print("Invalid path. Please try again.")
        labels_path = input("Enter the path to (Whether we writing or Reading ) 'labels.txt': ").strip()
            
    if choice == "1":
        labels = {}

        print("Enter label names and addresses. Press ENTER with no input to stop.")

        while True:
            name = input("Label name: ").strip()
            if name == "":
                break
            addr = input(f"Address for label '{name}': ").strip()
            if addr == "":
                print("Address cannot be empty. Try again.")
                continue
            labels[name] = addr
        label_map = labels
            # Write to file
        with open("labels.txt", "w") as f: # should be labels
            for label, addr in labels.items():
                f.write(f"{label} {addr}\n")
    else:
        label_map = load_labels(labels_path)

    print(f"[INFO] Loaded labels: {label_map}")

    
    
    label_map = load_labels(labels_path)
    print(f"[INFO] Loaded labels: {label_map}")

    # Step 3: Load assembly files
    files_info = read_multiple_files_from_folder(label_map, asm_folder)

    # Step 4: Assemble and write outputs
    for label, asm_text, addr in files_info:
        print(f"\n[INFO] Assembling '{label}.txt' at address {addr}")
        bin_lines = assemble_from_text(asm_text, int(addr), label_map)
        
        output_file = os.path.join(output_folder, f"{label}.tv")
        with open(output_file, "w") as f:
            for line in bin_lines:
                f.write(line + "\n")
        print(f"[SUCCESS] Output written to '{output_file}'")

    print("\n[✔] All files compiled successfully.")

if __name__ == "__main__":
    main()
