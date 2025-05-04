#!/usr/bin/env python3
"""
verify_pa2_part3.py

This script simulates the single-cycle CPU defined in PA2.pdf Part 3,
using IM.dat, DM.dat, RF.dat as initial memories/registers, then
executes until instruction memory is exhausted, and compares the
resulting DM.out and RF.out to simulation outputs.
"""

import sys

def read_dat8(filename):
    vals = []
    with open(filename, 'r') as f:
        for line in f:
            line = line.strip()
            if not line or line.startswith('//'):
                continue
            token = line.split()[0]
            token = token.replace('_', '')
            vals.append(int(token, 16))
    return vals

def read_dat32(filename):
    vals = []
    with open(filename, 'r') as f:
        for line in f:
            line = line.strip()
            if not line or line.startswith('//'):
                continue
            token = line.split()[0]
            token = token.replace('_', '')
            vals.append(int(token, 16))
    return vals

def sign_extend_16(x):
    if x & 0x8000:
        return x | 0xFFFF0000
    return x & 0x0000FFFF

def combine_bytes_be(arr, addr):
    return ((arr[addr] << 24) | (arr[addr+1] << 16) |
            (arr[addr+2] << 8)  | arr[addr+3]) & 0xFFFFFFFF

def split_word_be(val):
    return [(val >> 24) & 0xFF,
            (val >> 16) & 0xFF,
            (val >> 8)  & 0xFF,
            val & 0xFF]

def simulate(im, regs, dm):
    pc = 0
    im_size = len(im)
    while pc + 3 < im_size:
        instr = combine_bytes_be(im, pc)
        next_pc = (pc + 4) & 0xFFFFFFFF
        opcode = (instr >> 26) & 0x3F

        if opcode == 0x00:  # R-type
            rs = (instr >> 21) & 0x1F
            rt = (instr >> 16) & 0x1F
            rd = (instr >> 11) & 0x1F
            shamt = (instr >> 6) & 0x1F
            funct = instr & 0x3F
            if funct == 0x21:  # addu
                regs[rd] = (regs[rs] + regs[rt]) & 0xFFFFFFFF
            elif funct == 0x23:  # subu
                regs[rd] = (regs[rs] - regs[rt]) & 0xFFFFFFFF
            elif funct == 0x00:  # sll
                regs[rd] = (regs[rs] << shamt) & 0xFFFFFFFF
            elif funct == 0x25:  # or
                regs[rd] = (regs[rs] | regs[rt]) & 0xFFFFFFFF
            else:
                break

        elif opcode == 0x09:  # addiu
            rs = (instr >> 21) & 0x1F
            rt = (instr >> 16) & 0x1F
            imm = sign_extend_16(instr & 0xFFFF)
            regs[rt] = (regs[rs] + imm) & 0xFFFFFFFF

        elif opcode == 0x23:  # lw
            rs = (instr >> 21) & 0x1F
            rt = (instr >> 16) & 0x1F
            imm = sign_extend_16(instr & 0xFFFF)
            addr = (regs[rs] + imm) & 0xFFFFFFFF
            regs[rt] = combine_bytes_be(dm, addr)

        elif opcode == 0x2B:  # sw
            rs = (instr >> 21) & 0x1F
            rt = (instr >> 16) & 0x1F
            imm = sign_extend_16(instr & 0xFFFF)
            addr = (regs[rs] + imm) & 0xFFFFFFFF
            bytes4 = split_word_be(regs[rt])
            for i in range(4):
                dm[addr + i] = bytes4[i]

        elif opcode == 0x0D:  # ori
            rs = (instr >> 21) & 0x1F
            rt = (instr >> 16) & 0x1F
            imm = instr & 0xFFFF
            regs[rt] = (regs[rs] | imm) & 0xFFFFFFFF

        elif opcode == 0x04:  # beq
            rs = (instr >> 21) & 0x1F
            rt = (instr >> 16) & 0x1F
            imm = sign_extend_16(instr & 0xFFFF)
            if regs[rs] == regs[rt]:
                next_pc = (next_pc + ((imm << 2) & 0xFFFFFFFF)) & 0xFFFFFFFF

        elif opcode == 0x02:  # j
            target = instr & 0x03FFFFFF
            next_pc = ((pc + 4) & 0xF0000000) | (target << 2)

        else:
            break

        pc = next_pc

    return regs, dm

def main():
    im = read_dat8('IM.dat')
    dm_init = read_dat8('DM.dat')
    rf_init = read_dat32('RF.dat')
    dm_out = read_dat8('DM.out')
    rf_out = read_dat32('RF.out')

    regs = rf_init.copy()
    dm = dm_init.copy()

    regs_final, dm_final = simulate(im, regs, dm)

    # Compare RF
    print("=== Register File Comparison ===")
    for i in range(len(rf_init)):
        exp = regs_final[i] & 0xFFFFFFFF
        got = rf_out[i] & 0xFFFFFFFF
        if exp != got:
            print(f"R[{i}]: expected {exp:08x}, got {got:08x}")

    # Compare DM
    print("=== Data Memory Comparison ===")
    for i in range(len(dm_init)):
        exp = dm_final[i] & 0xFF
        got = dm_out[i] & 0xFF
        if exp != got:
            print(f"DM[{i:#04x}]: expected {exp:02x}, got {got:02x}")

if __name__ == '__main__':
    main()
