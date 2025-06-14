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
with open("labels.txt", "w") as f: # should be labels
    for label, addr in labels.items():
        f.write(f"{label} {addr}\n")