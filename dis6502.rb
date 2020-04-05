# Experimental disassembler for 6502 code

class Asm6502
  def initialize
    init_opcodes
    init_mnemonics
    init_modes
  end

  def init_opcodes
    @opcode = Array.new(256)
    @opcode[0x69] = {mnemonic: 'ADC', length: 2, mode: :imm}
    @opcode[0x65] = {mnemonic: 'ADC', length: 2, mode: :zp}
    @opcode[0x75] = {mnemonic: 'ADC', length: 2, mode: :zp_x}
    @opcode[0x6D] = {mnemonic: 'ADC', length: 3, mode: :abs}
    @opcode[0x7D] = {mnemonic: 'ADC', length: 3, mode: :abs_x}
    @opcode[0x79] = {mnemonic: 'ADC', length: 3, mode: :abs_y}
    @opcode[0x61] = {mnemonic: 'ADC', length: 2, mode: :ind_x}
    @opcode[0x71] = {mnemonic: 'ADC', length: 2, mode: :ind_y}
    @opcode[0x29] = {mnemonic: 'AND', length: 2, mode: :imm}
    @opcode[0x25] = {mnemonic: 'AND', length: 2, mode: :zp}
    @opcode[0x35] = {mnemonic: 'AND', length: 2, mode: :zp_x}
    @opcode[0x2D] = {mnemonic: 'AND', length: 3, mode: :abs}
    @opcode[0x3D] = {mnemonic: 'AND', length: 3, mode: :abs_x}
    @opcode[0x39] = {mnemonic: 'AND', length: 3, mode: :abs_y}
    @opcode[0x21] = {mnemonic: 'AND', length: 2, mode: :ind_x}
    @opcode[0x31] = {mnemonic: 'AND', length: 2, mode: :ind_y}
    @opcode[0x0A] = {mnemonic: 'ASL', length: 1, mode: :acc}
    @opcode[0x06] = {mnemonic: 'ASL', length: 2, mode: :zp}
    @opcode[0x16] = {mnemonic: 'ASL', length: 2, mode: :zp_x}
    @opcode[0x0E] = {mnemonic: 'ASL', length: 3, mode: :abs}
    @opcode[0x1E] = {mnemonic: 'ASL', length: 3, mode: :abs_x}
    @opcode[0x24] = {mnemonic: 'BIT', length: 2, mode: :zp}
    @opcode[0x2C] = {mnemonic: 'BIT', length: 3, mode: :abs}
    @opcode[0x00] = {mnemonic: 'BRK', length: 1, mode: :imp}
    @opcode[0xC9] = {mnemonic: 'CMP', length: 2, mode: :imm}
    @opcode[0xC5] = {mnemonic: 'CMP', length: 2, mode: :zp}
    @opcode[0xD5] = {mnemonic: 'CMP', length: 2, mode: :zp_x}
    @opcode[0xCD] = {mnemonic: 'CMP', length: 3, mode: :abs}
    @opcode[0xDD] = {mnemonic: 'CMP', length: 3, mode: :abs_x}
    @opcode[0xD9] = {mnemonic: 'CMP', length: 3, mode: :abs_y}
    @opcode[0xC1] = {mnemonic: 'CMP', length: 2, mode: :ind_x}
    @opcode[0xD1] = {mnemonic: 'CMP', length: 2, mode: :ind_y}
    @opcode[0xE0] = {mnemonic: 'CPX', length: 2, mode: :imm}
    @opcode[0xE4] = {mnemonic: 'CPX', length: 2, mode: :zp}
    @opcode[0xEC] = {mnemonic: 'CPX', length: 3, mode: :abs}
    @opcode[0xC0] = {mnemonic: 'CPY', length: 2, mode: :imm}
    @opcode[0xC4] = {mnemonic: 'CPY', length: 2, mode: :zp}
    @opcode[0xCC] = {mnemonic: 'CPY', length: 3, mode: :abs}
    @opcode[0xC6] = {mnemonic: 'DEC', length: 2, mode: :zp}
    @opcode[0xD6] = {mnemonic: 'DEC', length: 2, mode: :zp_x}
    @opcode[0xCE] = {mnemonic: 'DEC', length: 3, mode: :abs}
    @opcode[0xDE] = {mnemonic: 'DEC', length: 3, mode: :abs_x}
    @opcode[0x49] = {mnemonic: 'EOR', length: 2, mode: :imm}
    @opcode[0x45] = {mnemonic: 'EOR', length: 2, mode: :zp}
    @opcode[0x55] = {mnemonic: 'EOR', length: 2, mode: :zp_x}
    @opcode[0x4D] = {mnemonic: 'EOR', length: 3, mode: :abs}
    @opcode[0x5D] = {mnemonic: 'EOR', length: 3, mode: :abs_x}
    @opcode[0x59] = {mnemonic: 'EOR', length: 3, mode: :abs_y}
    @opcode[0x41] = {mnemonic: 'EOR', length: 2, mode: :ind_x}
    @opcode[0x51] = {mnemonic: 'EOR', length: 2, mode: :ind_y}
    @opcode[0xE6] = {mnemonic: 'INC', length: 2, mode: :zp}
    @opcode[0xF6] = {mnemonic: 'INC', length: 2, mode: :zp_x}
    @opcode[0xEE] = {mnemonic: 'INC', length: 3, mode: :abs}
    @opcode[0xFE] = {mnemonic: 'INC', length: 3, mode: :abs_x}
    @opcode[0x4C] = {mnemonic: 'JMP', length: 3, mode: :abs}
    @opcode[0x6C] = {mnemonic: 'JMP', length: 3, mode: :ind}
    @opcode[0x20] = {mnemonic: 'JSR', length: 3, mode: :abs}
    @opcode[0xA9] = {mnemonic: 'LDA', length: 2, mode: :imm}
    @opcode[0xA5] = {mnemonic: 'LDA', length: 2, mode: :zp}
    @opcode[0xB5] = {mnemonic: 'LDA', length: 2, mode: :zp_x}
    @opcode[0xAD] = {mnemonic: 'LDA', length: 3, mode: :abs}
    @opcode[0xBD] = {mnemonic: 'LDA', length: 3, mode: :abs_x}
    @opcode[0xB9] = {mnemonic: 'LDA', length: 3, mode: :abs_y}
    @opcode[0xA1] = {mnemonic: 'LDA', length: 2, mode: :ind_x}
    @opcode[0xB1] = {mnemonic: 'LDA', length: 2, mode: :ind_y}
    @opcode[0xA2] = {mnemonic: 'LDX', length: 2, mode: :imm}
    @opcode[0xA6] = {mnemonic: 'LDX', length: 2, mode: :zp}
    @opcode[0xB6] = {mnemonic: 'LDX', length: 2, mode: :zp_y}
    @opcode[0xAE] = {mnemonic: 'LDX', length: 3, mode: :abs}
    @opcode[0xBE] = {mnemonic: 'LDX', length: 3, mode: :abs_y}
    @opcode[0xA0] = {mnemonic: 'LDY', length: 2, mode: :imm}
    @opcode[0xA4] = {mnemonic: 'LDY', length: 2, mode: :zp}
    @opcode[0xB4] = {mnemonic: 'LDY', length: 2, mode: :zp_x}
    @opcode[0xAC] = {mnemonic: 'LDY', length: 3, mode: :abs}
    @opcode[0xBC] = {mnemonic: 'LDY', length: 3, mode: :abs_x}
    @opcode[0x4A] = {mnemonic: 'LSR', length: 1, mode: :acc}
    @opcode[0x46] = {mnemonic: 'LSR', length: 2, mode: :zp}
    @opcode[0x56] = {mnemonic: 'LSR', length: 2, mode: :zp_x}
    @opcode[0x4E] = {mnemonic: 'LSR', length: 3, mode: :abs}
    @opcode[0x5E] = {mnemonic: 'LSR', length: 3, mode: :abs_x}
    @opcode[0xEA] = {mnemonic: 'NOP', length: 1, mode: :imp}
    @opcode[0x09] = {mnemonic: 'ORA', length: 2, mode: :imm}
    @opcode[0x05] = {mnemonic: 'ORA', length: 2, mode: :zp}
    @opcode[0x15] = {mnemonic: 'ORA', length: 2, mode: :zp_x}
    @opcode[0x0D] = {mnemonic: 'ORA', length: 3, mode: :abs}
    @opcode[0x1D] = {mnemonic: 'ORA', length: 3, mode: :abs_x}
    @opcode[0x19] = {mnemonic: 'ORA', length: 3, mode: :abs_y}
    @opcode[0x01] = {mnemonic: 'ORA', length: 2, mode: :ind_x}
    @opcode[0x11] = {mnemonic: 'ORA', length: 2, mode: :ind_y}
    @opcode[0x2A] = {mnemonic: 'ROL', length: 1, mode: :acc}
    @opcode[0x26] = {mnemonic: 'ROL', length: 2, mode: :zp}
    @opcode[0x36] = {mnemonic: 'ROL', length: 2, mode: :zp_x}
    @opcode[0x2E] = {mnemonic: 'ROL', length: 3, mode: :abs}
    @opcode[0x3E] = {mnemonic: 'ROL', length: 3, mode: :abs_x}
    @opcode[0x6A] = {mnemonic: 'ROR', length: 1, mode: :acc}
    @opcode[0x66] = {mnemonic: 'ROR', length: 2, mode: :zp}
    @opcode[0x76] = {mnemonic: 'ROR', length: 2, mode: :zp_x}
    @opcode[0x6E] = {mnemonic: 'ROR', length: 3, mode: :abs}
    @opcode[0x7E] = {mnemonic: 'ROR', length: 3, mode: :abs_x}
    @opcode[0x40] = {mnemonic: 'RTI', length: 1, mode: :imp}
    @opcode[0x60] = {mnemonic: 'RTS', length: 1, mode: :imp}
    @opcode[0xE9] = {mnemonic: 'SBC', length: 2, mode: :imm}
    @opcode[0xE5] = {mnemonic: 'SBC', length: 2, mode: :zp}
    @opcode[0xF5] = {mnemonic: 'SBC', length: 2, mode: :zp_x}
    @opcode[0xED] = {mnemonic: 'SBC', length: 3, mode: :abs}
    @opcode[0xFD] = {mnemonic: 'SBC', length: 3, mode: :abs_x}
    @opcode[0xF9] = {mnemonic: 'SBC', length: 3, mode: :abs_y}
    @opcode[0xE1] = {mnemonic: 'SBC', length: 2, mode: :ind_x}
    @opcode[0xF1] = {mnemonic: 'SBC', length: 2, mode: :ind_y}
    @opcode[0x85] = {mnemonic: 'STA', length: 2, mode: :zp}
    @opcode[0x95] = {mnemonic: 'STA', length: 2, mode: :zp_x}
    @opcode[0x8D] = {mnemonic: 'STA', length: 3, mode: :abs}
    @opcode[0x9D] = {mnemonic: 'STA', length: 3, mode: :abs_x}
    @opcode[0x99] = {mnemonic: 'STA', length: 3, mode: :abs_y}
    @opcode[0x81] = {mnemonic: 'STA', length: 2, mode: :ind_x}
    @opcode[0x91] = {mnemonic: 'STA', length: 2, mode: :ind_y}
    @opcode[0x86] = {mnemonic: 'STX', length: 2, mode: :zp}
    @opcode[0x96] = {mnemonic: 'STX', length: 2, mode: :zp_y}
    @opcode[0x8E] = {mnemonic: 'STX', length: 3, mode: :abs}
    @opcode[0x84] = {mnemonic: 'STY', length: 2, mode: :zp}
    @opcode[0x94] = {mnemonic: 'STY', length: 2, mode: :zp_x}
    @opcode[0x8C] = {mnemonic: 'STY', length: 3, mode: :abs}
    @opcode[0x10] = {mnemonic: 'BPL', length: 2, mode: :rel}
    @opcode[0x30] = {mnemonic: 'BMI', length: 2, mode: :rel}
    @opcode[0x50] = {mnemonic: 'BVC', length: 2, mode: :rel}
    @opcode[0x70] = {mnemonic: 'BVS', length: 2, mode: :rel}
    @opcode[0x90] = {mnemonic: 'BCC', length: 2, mode: :rel}
    @opcode[0xB0] = {mnemonic: 'BCS', length: 2, mode: :rel}
    @opcode[0xD0] = {mnemonic: 'BNE', length: 2, mode: :rel}
    @opcode[0xF0] = {mnemonic: 'BEQ', length: 2, mode: :rel}
    @opcode[0xAA] = {mnemonic: 'TAX', length: 1, mode: :imp}
    @opcode[0x8A] = {mnemonic: 'TXA', length: 1, mode: :imp}
    @opcode[0xCA] = {mnemonic: 'DEX', length: 1, mode: :imp}
    @opcode[0xE8] = {mnemonic: 'INX', length: 1, mode: :imp}
    @opcode[0xA8] = {mnemonic: 'TAY', length: 1, mode: :imp}
    @opcode[0x98] = {mnemonic: 'TYA', length: 1, mode: :imp}
    @opcode[0x88] = {mnemonic: 'DEY', length: 1, mode: :imp}
    @opcode[0xC8] = {mnemonic: 'INY', length: 1, mode: :imp}
    @opcode[0x18] = {mnemonic: 'CLC', length: 1, mode: :imp}
    @opcode[0x38] = {mnemonic: 'SEC', length: 1, mode: :imp}
    @opcode[0x58] = {mnemonic: 'CLI', length: 1, mode: :imp}
    @opcode[0x78] = {mnemonic: 'SEI', length: 1, mode: :imp}
    @opcode[0xB8] = {mnemonic: 'CLV', length: 1, mode: :imp}
    @opcode[0xD8] = {mnemonic: 'CLD', length: 1, mode: :imp}
    @opcode[0xF8] = {mnemonic: 'SED', length: 1, mode: :imp}
    @opcode[0x9A] = {mnemonic: 'TXS', length: 1, mode: :imp}
    @opcode[0xBA] = {mnemonic: 'TSX', length: 1, mode: :imp}
    @opcode[0x48] = {mnemonic: 'PHA', length: 1, mode: :imp}
    @opcode[0x68] = {mnemonic: 'PLA', length: 1, mode: :imp}
    @opcode[0x08] = {mnemonic: 'PHP', length: 1, mode: :imp}
    @opcode[0x28] = {mnemonic: 'PLP', length: 1, mode: :imp}
  end

  def init_mnemonics
    @mnemonic = {}
    @mnemonic['ADC'] = 'ADd with Carry'
    @mnemonic['AND'] = 'bitwise AND with accumulator'
    @mnemonic['ASL'] = 'Arithmetic Shift Left'
    @mnemonic['BIT'] = 'test BITs'
    @mnemonic['BRK'] = 'BReaK'
    @mnemonic['CMP'] = 'CoMPare accumulator'
    @mnemonic['CPX'] = 'ComPare X register'
    @mnemonic['CPY'] = 'ComPare Y register'
    @mnemonic['DEC'] = 'DECrement memory'
    @mnemonic['EOR'] = 'bitwise Exclusive OR'
    @mnemonic['INC'] = 'INCrement memory'
    @mnemonic['JMP'] = 'JuMP'
    @mnemonic['JSR'] = 'Jump to SubRoutine'
    @mnemonic['LDA'] = 'LoaD Accumulator'
    @mnemonic['LDX'] = 'LoaD X register'
    @mnemonic['LDY'] = 'LoaD Y register'
    @mnemonic['LSR'] = 'Logical Shift Right'
    @mnemonic['NOP'] = 'No OPeration'
    @mnemonic['ORA'] = 'bitwise OR with Accumulator'
    @mnemonic['ROL'] = 'ROtate Left'
    @mnemonic['ROR'] = 'ROtate Right'
    @mnemonic['RTI'] = 'ReTurn from Interrupt'
    @mnemonic['RTS'] = 'ReTurn from Subroutine'
    @mnemonic['SBC'] = 'SuBtract with Carry'
    @mnemonic['STA'] = 'STore Accumulator'
    @mnemonic['STX'] = 'STore X register'
    @mnemonic['STY'] = 'STore Y register'
    @mnemonic['BPL'] = 'Branch on PLus'
    @mnemonic['BMI'] = 'Branch on MInus'
    @mnemonic['BVC'] = 'Branch on oVerflow Clear'
    @mnemonic['BVS'] = 'Branch on oVerflow Set'
    @mnemonic['BCC'] = 'Branch on Carry Clear'
    @mnemonic['BCS'] = 'Branch on Carry Set'
    @mnemonic['BNE'] = 'Branch on Not Equal'
    @mnemonic['BEQ'] = 'Branch on EQual'
    @mnemonic['TAX'] = 'Transfer A to X'
    @mnemonic['TXA'] = 'Transfer X to A'
    @mnemonic['DEX'] = 'DEcrement X'
    @mnemonic['INX'] = 'INcrement X'
    @mnemonic['TAY'] = 'Transfer A to Y'
    @mnemonic['TYA'] = 'Transfer Y to A'
    @mnemonic['DEY'] = 'DEcrement Y'
    @mnemonic['INY'] = 'INcrement Y'
    @mnemonic['CLC'] = 'CLear Carry'
    @mnemonic['SEC'] = 'SEt Carry'
    @mnemonic['CLI'] = 'CLear Interrupt'
    @mnemonic['SEI'] = 'SEt Interrupt'
    @mnemonic['CLV'] = 'CLear oVerflow'
    @mnemonic['CLD'] = 'CLear Decimal'
    @mnemonic['SED'] = 'SEt Decimal'
    @mnemonic['TXS'] = 'Transfer X to Stack ptr'
    @mnemonic['TSX'] = 'Transfer Stack ptr to X'
    @mnemonic['PHA'] = 'PusH Accumulator'
    @mnemonic['PLA'] = 'PuLl Accumulator'
    @mnemonic['PHP'] = 'PusH Processor status'
    @mnemonic['PLP'] = 'PuLl Processor status'
  end

  def init_modes
    @mode = {}
    @mode[:abs] = {comment: 'Absolute', syntax: '$%.4x'}
    @mode[:abs_x] = {comment: 'Absolute,X', syntax: '$%.4x,X'}
    @mode[:abs_y] = {comment: 'Absolute,Y', syntax: '$%.4x,Y'}
    @mode[:acc] = {comment: 'Accumulator', syntax: 'A'}
    @mode[:imm] = {comment: 'Immediate', syntax: '#$%.2x'}
    @mode[:imp] = {comment: 'Implied', syntax: ''}
    @mode[:ind] = {comment: 'Indirect', syntax: '($%.4x)'}
    @mode[:ind_x] = {comment: 'Indirect,X', syntax: '($%.2x,X)'}
    @mode[:ind_y] = {comment: 'Indirect,Y', syntax: '($%.2x),Y'}
    @mode[:rel] = {comment: 'Relative', syntax: '$%.4x'}
    @mode[:zp] = {comment: 'Zero Page', syntax: '$%.2x'}
    @mode[:zp_x] = {comment: 'Zero Page,X', syntax: '$%.2x,X'}
    @mode[:zp_y] = {comment: 'Zero Page,Y', syntax: '$%.2x,Y'}
  end

  def disasm(base_addr, program, prog_size=-1)
    prog_size = program.size if prog_size < 0 or size > program.size
    i = 0

    puts "Address  Hexdump   Dissassembly"
    puts "-------------------------------"

    while i < prog_size do

      op = @opcode[program[i]]

      if (op)
        size = op[:length]
        mode = op[:mode]
        syntax = '%s ' + @mode[mode][:syntax]
        mnemonic = op[:mnemonic]
   
        case mode
        when :acc, :impl
          operand = 0
        when :ind_x, :ind_y, :zp, :zp_x, :zp_y, :imm
          operand = program[i+1]        
        when :abs, :abs_x, :abs_y, :ind
          operand = program[i+1] + program[i+2] * 0x100
        when :rel
          offset = program[i+1]
          offset -= 256 if offset > 127
          size = 2
          operand = base_addr + i + size + offset
        end

        #puts mode, syntax, mnemonic, operand
        fmt_code = syntax % [mnemonic, operand]
        fmt_comment = @mnemonic[mnemonic]
        case size
        when 1
          print "$%.4x    %.2x        " % [base_addr + i, program[i]]
        when 2
          print "$%.4x    %.2x %.2x     " % [base_addr + i, program[i], program[i+1]]
        when 3
          print "$%.4x    %.2x %.2x %.2x  " % [base_addr + i, program[i], program[i+1], program[i+2]]
        end
        puts "%-12s ; %s" % [fmt_code, fmt_comment]

        i += size
      else
        print "$%.4x    %.2x        " % [base_addr + i, program[i]]
        puts "%-12s ; UNKNOWN OP %.2x" % ['??', program[i]]
        i += 1
      end
    end
  end

  def hex2data(hex_string)
    hex_string.split(' ').map { |d| "0x#{d}".to_i(16) }
  end
end

#hex = "a9 c0 aa e8 69 c4 00"
#hex = "a9 00 8d 00 02 a9 01 8d 01 02 8d ff 05"
#hex = "a9 80 85 01 65 01 a9 f1 aa a9 f2 a8 a9 00 98 8a"
#hex = "a9 03 85 00 a9 09 38 e5 00 85 01 "
#hex = "a2 08 ca 8e 00 02 e0 03 f0 03 4c 02 06 8e 01 02"
#hex = "a2 08 ca 8e 00 02 e0 03 d0 f8 8e 01 02 00 ff"
#hex = "a2 02 8e 00 02 a9 f0 6d 00 02 90 fb 8e 01 02 00 "
#hex = "a2 00 a0 00 8a 99 00 02 48 e8 c8 c0 10 d0 f5 68 99 00 02 c8 c0 20 d0 f7"
#hex = "20 09 06 20 0c 06 20 12 06 a2 00 60 e8 e0 05 d0 fb 60 00"
#hex = "20 06 06 20 38 06 20 0d 06 20 2a 06 60 a9 02 85 02 a9 04 85 03 a9 11 85 10 a9 10 85 12 a9 0f 85 14 a9 04 85 11 85 13 85 15 60 a5 fe 85 00 a5 fe 29 03 18 69 02 85 01 60 20 4d 06 20 8d 06 20 c3 06 20 19 07 20 20 07 20 2d 07 4c 38 06 a5 ff c9 77 f0 0d c9 64 f0 14 c9 73 f0 1b c9 61 f0 22 60 a9 04 24 02 d0 26 a9 01 85 02 60 a9 08 24 02 d0 1b a9 02 85 02 60 a9 01 24 02 d0 10 a9 04 85 02 60 a9 02 24 02 d0 05 a9 08 85 02 60 60 20 94 06 20 a8 06 60 a5 00 c5 10 d0 0d a5 01 c5 11 d0 07 e6 03 e6 03 20 2a 06 60 a2 02 b5 10 c5 10 d0 06 b5 11 c5 11 f0 09 e8 e8 e4 03 f0 06 4c aa 06 4c 35 07 60 a6 03 ca 8a b5 10 95 12 ca 10 f9 a5 02 4a b0 09 4a b0 19 4a b0 1f 4a b0 2f a5 10 38 e9 20 85 10 90 01 60 c6 11 a9 01 c5 11 f0 28 60 e6 10 a9 1f 24 10 f0 1f 60 a5 10 18 69 20 85 10 b0 01 60 e6 11 a9 06 c5 11 f0 0c 60 c6 10 a5 10 29 1f c9 1f f0 01 60 4c 35 07 a0 00 a5 fe 91 00 60 a6 03 a9 00 81 10 a2 00 a9 01 81 10 60 a2 00 ea ea ca d0 fb 60"
hex = "20 06 06 20 37 06 20 0d 06 20 2a 06 60 a9 02 85 02 a9 04 85 03 a9 11 85 10 a9 10 85 12 a9 0f 85 14 a9 04 85 11 85 13 85 15 60 a5 fe 85 00 a5 fe 29 03 18 69 02 85 01 20 57 06 20 43 06 20 4a 06 4c 37 06 a0 00 a5 fe 91 00 60 a6 03 a9 00 81 10 a2 00 a9 01 81 10 60 a6 03 ca 8a b5 10 95 12 ca 10 f9 a5 02 4a b0 09 4a b0 19 4a b0 1f 4a b0 2f a5 10 38 e9 20 85 10 90 01 60 c6 11 a9 01 c5 11 f0 26 60 e6 10 a9 1f 24 10 f0 1d 60 a5 10 18 69 20 85 10 b0 01 60 e6 11 a9 06 c5 11 f0 0a 60 c6 10 a9 1f 25 10 f0 01 60 4c ab 06"
asm = Asm6502.new
asm.disasm(0x600, asm.hex2data(hex))
