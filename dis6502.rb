# Experimental disassembler for 6502 code

def disasm(base_addr, program, prog_size=-1)
  prog_size = program.size if prog_size < 0 or size > program.size
  i = 0

  puts "Address  Hexdump   Dissassembly"
  puts "-------------------------------"

  while i < prog_size do

    case program[i]
    when 0xa2
      comment = "load literal value $%.2x into register X"
      instr = "LDA #$%.2x"
      operands = [program[i+1]]
      size = 2
    when 0xa9
      comment = "load literal value $%.2x into register A"
      instr = "LDA #$%.2x"
      operands = [program[i+1]]
      size = 2
    when 0x38
      comment = "set carry flag"
      instr = "SEC"
      operands = []
      size = 1 
    when 0x65
      comment = "add value at address $%.2x to register A"
      instr = "ADC $%.2x"
      operands = [program[i+1]]
      size = 2
    when 0x69
      comment = "add value $%.2x to register A"
      instr = "ADC #$%.2x"
      operands = [program[i+1]]
      size = 2
    when 0x6d
      comment = "add value at address $%.4x to register A"
      instr = "ADC $%.4x"
      operands = [program[i+1] + program[i+2] * 0x100]
      size = 3
    when 0x85
      comment = "store register A to address $%.2x"
      instr = "STA $%.2x"
      operands = [program[i+1]]
      size = 2
    when 0x8d
      comment = "store register A to address $%.4x"
      instr = "STA $%.4x"
      operands = [program[i+1] + program[i+2] * 0x100]
      size = 3
    when 0x8e
      comment = "store register X to address $%.4x"
      instr = "STA $%.4x"
      operands = [program[i+1] + program[i+2] * 0x100]
      size = 3
    when 0xaa
      comment = "transfer A to X"
      instr = "TAX"
      operands = []
      size = 1
    when 0xa8
      comment = "transfer A to Y"
      instr = "TAY"
      operands = []
      size = 1
    when 0xe0
      comment = "compare X to the value $%.2x and flag Z=1 if equal"
      instr = "CPX #$%.2x"
      operands = [program[i+1]]
      size = 2
    when 0xd0
      comment = "branch to address $%.4x on not-equal (flag Z=0)"
      instr = "BNE $%.4x"
      offset = program[i+1]
      offset -= 256 if offset > 127
      size = 2
      operands = [base_addr + i + + size + offset]
    when 0x90
      comment = "branch to address $%.4x on carry clear (flag C=0)"
      instr = "BCC $%.4x"
      offset = program[i+1]
      offset -= 256 if offset > 127
      size = 2
      operands = [base_addr + i + + size + offset]
    when 0xb0
      comment = "branch to address $%.4x on carry set (flag C=1)"
      instr = "BCS $%.4x"
      offset = program[i+1]
      offset -= 256 if offset > 127
      size = 2
      operands = [base_addr + i + + size + offset]
    when 0xf0
      comment = "branch to address $%.4x on equal (flag Z=1)"
      instr = "BEQ $%.4x"
      offset = program[i+1]
      offset -= 256 if offset > 127
      size = 2
      operands = [base_addr + i + + size + offset]
    when 0x4c
      comment = "jump to address $%.4x"
      instr = "JMP $%.4x"
      size = 3
      operands = [program[i+1] + program[i+2] * 0x100]
    when 0xe5
      comment = "subtract from A the value at address $%.2x"
      instr = "SBC $%.2x"
      operands = [program[i+1]]
      size = 2
    when 0x98
      comment = "transfer Y to A"
      instr = "TYA"
      operands = []
      size = 1
    when 0x8a
      comment = "transfer X to A"
      instr = "TXA"
      operands = []
      size = 1
    when 0xe8
      comment = "increment X"
      instr = "INX"
      operands = []
      size = 1
    when 0xc8
      comment = "increment Y"
      instr = "INY"
      operands = []
      size = 1
    when 0xca
      comment = "decrement X"
      instr = "DEX"
      operands = []
      size = 1
    when 0x00
      comment = "break"
      instr = "BRK"
      operands = []
      size = 1
    else
      instr = "???"
      size = 1
      comment = "???"
    end

    if size == 1 then
      print "$%.4x    %.2x        " % [base_addr + i, program[i]]
    elsif size == 2 then
      print "$%.4x    %.2x %.2x     " % [base_addr + i, program[i], program[i+1]]
    elsif size == 3 then
      print "$%.4x    %.2x %.2x %.2x  " % [base_addr + i, program[i], program[i+1], program[i+2]]
    else
      print "XXXXXX"
    end

    fmt_code = instr % operands
    fmt_comment = comment % operands
    puts "%-10s ; %s" % [fmt_code, fmt_comment]

    i += size
  end
end

def hex2data(hex_string)
  hex_string.split(' ').map { |d| "0x#{d}".to_i(16) }
end

base_addr = 0x600
#disasm(base_addr, hex2data("a9 c0 aa e8 69 c4 00"))
#disasm(base_addr, hex2data("a9 00 8d 00 02 a9 01 8d 01 02 8d ff 05"))
#disasm(base_addr, hex2data("a9 80 85 01 65 01 a9 f1 aa a9 f2 a8 a9 00 98 8a"))
#disasm(base_addr, hex2data("a9 03 85 00 a9 09 38 e5 00 85 01 "))
#disasm(base_addr, hex2data("a2 08 ca 8e 00 02 e0 03 f0 03 4c 02 06 8e 01 02"))
#disasm(base_addr, hex2data("a2 08 ca 8e 00 02 e0 03 d0 f8 8e 01 02 00"))
disasm(base_addr, hex2data("a2 02 8e 00 02 a9 f0 6d 00 02 90 fb 8e 01 02 00 "))