#Task 1
INSTRUCTION_REGEXP = /mul\(\d{1,3},\d{1,3}\)/
METHOD_REGEXP = /\((\d{1,3}),(\d{1,3})\)/

#Task 2

INSTRUCTION_REGEXP_WITH_CONDITIONALS = /mul\(\d{0,3},\d{0,3}\)|do\(\)|don\'t\(\)/


instructions = File.readlines("input", chomp: true)

#Task 1
values = instructions
  .map { |instruction| instruction.scan(INSTRUCTION_REGEXP)  }
  .map do |instruction|
    instruction.map do |mul_str| 
      mul_str.scan(METHOD_REGEXP).flatten.map(&:to_i).inject(:*)
    end.sum
  end.sum

#Task 2

total_from_instructions = 0
parsed_instructions = instructions
  .map { |instruction| instruction.scan(INSTRUCTION_REGEXP_WITH_CONDITIONALS)  }

mult_flag = true
parsed_instructions.each do |instruction|
  instruction.each do |inst|
    if inst == "do()"
      mult_flag = true 
    elsif inst == "don't()"
      mult_flag = false 
    elsif mult_flag
      numbers = inst.scan(METHOD_REGEXP).flatten.map(&:to_i)
      total_from_instructions += numbers.inject(:*)
    end
  end
end

p total_from_instructions

