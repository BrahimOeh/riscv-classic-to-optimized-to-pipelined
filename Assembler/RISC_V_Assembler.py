import re

# Define opcodes, funct3, funct7, and register mappings for supported instructions
opcodes = {
    # R-type
    'add':   '0110011',
    'sub':   '0110011',
    'sll':   '0110011',
    'slt':   '0110011',
    'sltu':  '0110011',
    'xor':   '0110011',
    'srl':   '0110011',
    'sra':   '0110011',
    'or':    '0110011',
    'and':   '0110011',

    # I-type (immediates & loads)
    'addi':  '0010011',
    'slti':  '0010011',
    'sltiu': '0010011',
    'xori':  '0010011',
    'ori':   '0010011',
    'andi':  '0010011',
    'slli':  '0010011',
    'srli':  '0010011',
    'srai':  '0010011',

    'lb':    '0000011',
    'lh':    '0000011',
    'lw':    '0000011',
    'lbu':   '0000011',
    'lhu':   '0000011',

    'jalr':  '1100111',

    # S-type
    'sb':    '0100011',
    'sh':    '0100011',
    'sw':    '0100011',

    # B-type
    'beq':   '1100011',
    'bne':   '1100011',
    'blt':   '1100011',
    'bge':   '1100011',
    'bltu':  '1100011',
    'bgeu':  '1100011',

    # U-type
    'lui':   '0110111',
    'auipc': '0010111',

    # J-type
    'jal':   '1101111',
}

funct3 = {
    # R-type
    'add':   '000',
    'sub':   '000',
    'sll':   '001',
    'slt':   '010',
    'sltu':  '011',
    'xor':   '100',
    'srl':   '101',
    'sra':   '101',
    'or':    '110',
    'and':   '111',

    # I-type
    'addi':  '000',
    'slti':  '010',
    'sltiu': '011',
    'xori':  '100',
    'ori':   '110',
    'andi':  '111',
    'slli':  '001',
    'srli':  '101',
    'srai':  '101',

    'lb':    '000',
    'lh':    '001',
    'lw':    '010',
    'lbu':   '100',
    'lhu':   '101',

    'jalr':  '000',

    # S-type
    'sb':    '000',
    'sh':    '001',
    'sw':    '010',

    # B-type
    'beq':   '000',
    'bne':   '001',
    'blt':   '100',
    'bge':   '101',
    'bltu':  '110',
    'bgeu':  '111',
}

funct7 = {
    # R-type
    'add':  '0000000',
    'sub':  '0100000',
    'sll':  '0000000',
    'slt':  '0000000',
    'sltu': '0000000',
    'xor':  '0000000',
    'srl':  '0000000',
    'sra':  '0100000',
    'or':   '0000000',
    'and':  '0000000',

    # I-type shifts
    'slli': '0000000',
    'srli': '0000000',
    'srai': '0100000',
}

#this way the instruction set is extensible the only difference to watch out from are the jumping and branching logic where changing
#the PC is concerned

def load_labels(filename="labels.txt"):
    labels = {}
    with open(filename, "r") as f:
        for line in f:
            if line.strip():
                name, addr = line.strip().split()
                labels[name] = int(addr)
    return labels

labels = load_labels("labels.txt")
# Convert to a list of (name, address) tuples
label_list = list(labels.items())
#print(label_list)



reg_map = {f'x{i}': f'{i:05b}' for i in range(32)}

def parse_line(line):
    line = line.strip()
    if not line or line.startswith('#'):
        return None
    if ':' in line:
        label = line.replace(':', '').strip()
        return ('label', label)
    line = re.sub(r'#.*', '', line).strip()
    parts = line.split(',')
    mnemonic = parts[0].strip()
    operands = [p.strip() for p in parts[1:]]
    return ('inst', mnemonic, operands)

def get_type(mnemonic):
    if mnemonic in ['addi']: return 'I'
    if mnemonic in ['add']: return 'R'
    if mnemonic in ['sw']: return 'S'
    if mnemonic in ['lw']: return 'I'
    if mnemonic in ['beq']: return 'B'
    if mnemonic in ['jal']: return 'J'
    if mnemonic in ['jalr']: return 'I'
    return None

def imm_to_bin(val, bits):
    if val < 0:
        val = (1 << bits) + val
    return f'{val:0{bits}b}'[-bits:]

def encode(inst_type, mnemonic, operands, pc, label_map):
    if inst_type == 'R':
        rd, rs1, rs2 = operands
        return funct7[mnemonic] + reg_map[rs2] + reg_map[rs1] + funct3[mnemonic] + reg_map[rd] + opcodes[mnemonic]

    elif inst_type == 'I':
        if mnemonic == 'jalr':
            # Format: jalr rd, rs1, imm
            rd, rs1, imm = operands
            imm_bin = imm_to_bin(int(imm), 12)
            return imm_bin + reg_map[rs1] + funct3[mnemonic] + reg_map[rd] + opcodes[mnemonic]
    
        elif mnemonic in ['lw']:
            # Format: lw rd, imm(rs1)
            rd, addr = operands
            match = re.match(r'(-?\d+)\((x\d+)\)', addr)
            if not match:
                raise ValueError(f"Invalid I-type memory operand format: {addr}")
            imm, rs1 = match.groups()
            imm_bin = imm_to_bin(int(imm), 12)
            return imm_bin + reg_map[rs1] + funct3[mnemonic] + reg_map[rd] + opcodes[mnemonic]

        else:  # Arithmetic I-type like addi
            rd, rs1, imm = operands
            imm_bin = imm_to_bin(int(imm), 12)
            return imm_bin + reg_map[rs1] + funct3[mnemonic] + reg_map[rd] + opcodes[mnemonic]


    elif inst_type == 'S':
        rs2, addr = operands
        match = re.match(r'(-?\d+)\((x\d+)\)', addr)
        if not match:
            raise ValueError(f"Invalid S-type address format: {addr}")
        imm, rs1 = match.groups()
        imm_bin = imm_to_bin(int(imm), 12)
        imm_hi = imm_bin[:7]
        imm_lo = imm_bin[7:]
        return imm_hi + reg_map[rs2] + reg_map[rs1] + funct3[mnemonic] + imm_lo + opcodes[mnemonic]


    elif inst_type == 'B':
        rs1, rs2, label = operands
        print("in B")
        offset = label_map[label]*4 - pc
        if(int(input("1 :  Word addressable | 0 : byte addressable\n"))== 1) :
            print(label_map[label],pc//4)
            print(offset//4)
        else :
            print(label_map[label]*4,pc)
            print(offset)
        imm = imm_to_bin(offset, 13)
        return imm[0] + imm[2:8] + reg_map[rs2] + reg_map[rs1] + funct3[mnemonic] + imm[8:12] + imm[1] + opcodes[mnemonic]

    elif inst_type == 'J':
        rd, label = operands
        print("in j")
        print(label_map[label]*4,pc)
        offset = label_map[label]*4 - pc #no *4 for PC cause ist's already assesed to be byte addresable (line of pv+=4 {153})
        print(offset)
        imm = imm_to_bin(offset, 21)
        return imm[0] + imm[10:20] + imm[9] + imm[1:9] + reg_map[rd] + opcodes[mnemonic]

def assemble_from_text(asm_text,label_addr,label_map): #label_addr added
    lines = asm_text.strip().split('\n')
    #label_map = dict(label_list)
    #print(label_map)
    parsed = []
    pc = label_addr*4        #pass here the starting address of a certain program in the MemoryRV32 memory
                            #{eg. main at [0] and fib at [40] with the memory being word addressable}

    for line in lines:
        result = parse_line(line)
        if not result:
            continue
        if result[0] == 'label':
            label = result[1]
            if label in label_map:
                print(f"Warning: Label '{label}' already defined. Skipping it...")
                continue
            label_map[label] = pc//4  # assuming memory is word-addressable (look at lines 128 and 119)
        elif result[0] == 'inst':
            #print(result)
            parsed.append(result)
            pc += 4

    binary_lines = []
    pc = label_addr*4
    #print(parsed)
    for item in parsed:
        _, mnemonic, operands = item
        inst_type = get_type(mnemonic)
        #print(inst_type,mnemonic,operands)
        if not inst_type:
            continue
        try:
            #print(inst_type,mnemonic,operands,pc,label_map)
            print(label_map)
            bin_code = encode(inst_type, mnemonic, operands, pc, label_map)
            print("###################################")
            print(bin_code)
            binary_lines.append(bin_code)
            #print(binary_lines)
            #for i in range (2):
            print('\n')
        except Exception as e:
            #print(inst_type, mnemonic, operands, pc, label_map)
            #print(f'{inst_type}, {mnemonic}, {operands}, {pc}, {label_map}')
            #binary_lines.append(f'ERROR: {e}') #wasn't sufficient enough to determine the source of the error
            print(f'ERROR at PC={pc} ({mnemonic} {operands}): {e}')
            binary_lines.append(f'ERROR: {mnemonic} {operands} @ PC {pc} => {e}')
        pc += 4

    return binary_lines

#testing it with simple txt file that has RISC-V Assembly Code
#with open('fib.txt') as f:
    #lines = f.read()
#label_addr = int(input("Enter the label addr you want in memory :"))
#out = assemble_from_text(lines,label_addr)
#with open('output.txt', 'w') as f:
    #for bin_line in out:
        #f.write(bin_line + '\n')



def read_multiple_files():
    files_info = []
    for i in range(len(label_list)):
        name, addr = label_list[i]
        #filename = input("Enter filename (or press Enter to finish): ").strip()
        filename = name + ".txt"
        #print(filename)
        if not filename:
            break
        label_addr = addr
        try:
            #label_addr = int(input(f"Enter starting address for '{filename}': ").strip())
            
            with open(filename) as f:
                asm_text = f.read()
            files_info.append((asm_text, label_addr))
            #print(files_info)
        except Exception as e:
            print(f"Error: {e}")
    return files_info


def main():
    folder = "C:/Users/brahim/Desktop/BraRV32_DE2/rtl"
    filename = "output.txt"

    output_path = f"{folder}/{filename}"


    files_info = read_multiple_files()
    for asm_text, label_addr in files_info:
        bin_lines = assemble_from_text(asm_text, label_addr, labels)

        # Derive output file name from corresponding label (e.g., main -> main.tv)
        for label, addr in labels.items():
            if addr == label_addr:
                output_filename = f"{label}.txt"
                break
            else:
                output_filename = f"program_{label_addr}.txt"  # Fallback
        output_path = f"{folder}/{output_filename}"
        with open(output_path, 'w') as f:
            for line in bin_lines:
                f.write(line + '\n')

        print(f"Assembly complete for label '{label}'. Output written to '{output_filename}'.")
    #with open('C:/Users/brahim/Desktop/BraRV32/rtl/outt.tv', 'w') as f:
        #for line in all_binary_lines:
            
            #f.write(line + '\n')

    print("Assembly complete. Output written to 'output.tv'.")


if __name__ == "__main__":
    main()


