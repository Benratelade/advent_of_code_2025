# frozen_string_literal: true

class Solver
  attr_reader :operations

  def initialize(file)
    @file = file

    process_file
  end

  def solve_part_1
    @operations.sum(&:result)
  end

  def solve_part_2
    @operations.sum(&:cephalopod_result)
  end

  class Operation
    attr_reader :operand, :raw_inputs, :inputs, :cephalopod_inputs

    def initialize(operand:, raw_inputs:)
      @operand = operand
      @raw_inputs = raw_inputs
      @inputs = process_inputs
      @cephalopod_inputs = process_cephalopod_inputs
    end

    def result
      eval(@inputs.join(@operand)) # rubocop:disable Security/Eval
    end

    def cephalopod_result
      eval(@cephalopod_inputs.join(@operand)) # rubocop:disable Security/Eval
    end

    private

    def process_inputs
      @inputs = @raw_inputs.map {|characters| characters.join.to_i}
    end

    def process_cephalopod_inputs; end
  end

  private

  def process_file
    operations = {}

    lines = File.read(@file).split("\n")
    operation_matches = lines.last.to_enum(:scan, /[\*\+]/).map { Regexp.last_match }
    operation_matches.each_with_index do |match_data, index|
      operations[index] = { raw_inputs: [], operand: nil }
      operations[index][:operand] = match_data.match(0)
    end
    operation_indexes = operation_matches.map { |match| match.begin(0) - 1 }

    lines.each do |line|
      next if line.match?(/\*/)

      puts "processing line: #{line}"

      line_input = []
      input = []
      line.each_char.with_index do |char, index|
        if operation_indexes.include?(index)
          line_input << input
          input = []
          next
        end

        if index == (line.length - 1)
          input << char
          line_input << input
          input = []
        end

        input << char

      end
      line_input.each_with_index { |raw_input, index| operations[index][:raw_inputs] << raw_input }
    end

    @operations = operations.values.map do |operation_hash|
      Operation.new(**operation_hash)
    end
  end
end
