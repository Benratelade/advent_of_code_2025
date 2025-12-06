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

  def solve_part_2; end

  class Operation
    attr_reader :operand, :inputs

    def initialize(operand:, inputs:)
      @operand = operand
      @inputs = inputs
    end

    def result
      eval(@inputs.join(@operand)) # rubocop:disable Security/Eval
    end
  end

  private

  def process_file
    operations = {}

    File.readlines(@file).each do |line|
      line.strip.split.each_with_index do |operation_input, index|
        operations[index] ||= { operand: nil, inputs: [] }

        if operation_input.match?(/\d+/)
          operations[index][:inputs] << operation_input.to_i
        else
          operations[index][:operand] = operation_input
        end
      end
    end

    @operations = operations.values.map do |operation_hash|
      Operation.new(**operation_hash)
    end
  end
end
