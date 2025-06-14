# label_input.py

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

# Write to file
with open("llabels.txt", "w") as f:
    for label, addr in labels.items():
        f.write(f"{label} {addr}\n")

def load_labels(filename="labels.txt"):
    labels = {}
    with open(filename, "r") as f:
        for line in f:
            if line.strip():
                name, addr = line.strip().split()
                labels[name] = int(addr)
    return labels

labels = load_labels()

# Convert to a list of (name, address) tuples
label_list = list(labels.items())

# Access by index
for i in range(len(label_list)):
    name, addr = label_list[i]
    print(f"Label {i}: {name} -> {addr}")
