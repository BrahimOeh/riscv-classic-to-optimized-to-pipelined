import os

def read_file_lines(filename):
    with open(filename, 'r') as f:
        return [line.strip() for line in f if line.strip()]

def write_mif(memory, filename, depth=1024, width=32):
    with open(filename, 'w') as f:
        f.write(f"DEPTH = {depth};\n")
        f.write(f"WIDTH = {width};\n")
        f.write("ADDRESS_RADIX = HEX;\n")
        f.write("DATA_RADIX = BIN;\n")
        f.write("CONTENT\n")
        f.write("BEGIN\n")
        for addr in range(depth):
            data = memory.get(addr, 0)
            f.write(f"{addr:03X} : {data:032b};\n")
        f.write("END;\n")

def write_flat_memory_txt(memory, filename, depth=128):
    with open(filename, 'w') as f:
        for addr in range(depth):
            data = memory.get(addr, 0)
            f.write(f"{data:032b}\n")

def parse_labels(label_file):
    labels = {}
    with open(label_file, 'r') as f:
        for line in f:
            parts = line.strip().split()
            if len(parts) == 2:
                label, addr = parts[0], int(parts[1])
                labels[label] = addr
    return labels

def load_bin_to_mem(filename, base_addr, memory):
    lines = read_file_lines(filename)
    for i, line in enumerate(lines):
        data = int(line, 2)
        memory[base_addr + i] = data

def main():
    print("=== Memory Combiner ===")
    
    base_folder = input("Enter the base folder path: ").strip()
    label_file_name = input("Enter the label file name (e.g., labels.txt): ").strip()
    output_name = input("Enter output file name (without extension): ").strip()
    extension = input("Enter output file extension [.tv or .mif]: ").strip().lower()
    depth = input("Enter memory depth (e.g., 512 or 1024) [default 512]: ").strip()
    
    if not depth.isdigit():
        depth = 512
    else:
        depth = int(depth)

    label_path = os.path.join(base_folder, label_file_name)
    if not os.path.isfile(label_path):
        print(f"Label file not found at {label_path}")
        return

    labels = parse_labels(label_path)
    file_map = {label: os.path.join(base_folder, f"{label}.tv") for label in labels.keys()}

    memory = {}
    for label, addr in labels.items():
        file_path = file_map[label]
        if os.path.exists(file_path):
            load_bin_to_mem(file_path, addr, memory)
        else:
            print(f"Warning: File for label '{label}' not found at {file_path}. Skipping.")

    output_path = os.path.join(base_folder, f"{output_name}{extension}")
    if extension == '.tv':
        write_flat_memory_txt(memory, output_path, depth)
    elif extension == '.mif':
        write_mif(memory, output_path, depth=depth)
    else:
        print("Unsupported file extension. Use .tv or .mif")
        return

    print(f"Memory written to {output_path} (depth={depth})")

if __name__ == '__main__':
    main()
