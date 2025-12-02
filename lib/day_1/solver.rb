# frozen_string_literal: true

class Solver
  attr_reader :dial_position

  DIAL_MAXIMUM = 99
  DIAL_MINIMUM = 0

  def self.extract_instructions(instructions)
    direction = instructions[0] == "R" ? :right : :left
    {
      direction: direction,
      amount: instructions[1..].to_i,
    }
  end

  def initialize(file)
    @file = file
    @dial_position = 50
    @total_length = (DIAL_MINIMUM..DIAL_MAXIMUM).count
    @final_zero_counts = 0
    @zero_counts_in_passing = 0
    @input = process_input
    build_dial
  end

  def process_input
    File.readlines(@file).map do |line|
      Solver.extract_instructions(line.strip)
    end
  end

  def build_dial
    @dial = {}
    (DIAL_MINIMUM..DIAL_MAXIMUM).each do |position|
      @dial[position] = Node.new(position: position)
    end
    @dial[DIAL_MINIMUM].left_node = @dial[DIAL_MAXIMUM]
    @dial[DIAL_MAXIMUM].right_node = @dial[DIAL_MINIMUM]

    @dial.each do |position, node|
      node.left_node = @dial[position - 1] unless node.left_node
      node.right_node = @dial[position + 1] unless node.right_node
    end
  end

  def solve_part_1
    @input.each do |instructions|
      rotate(**instructions)
    end

    @final_zero_counts
  end

  def solve_part_2
    @input.each do |instructions|
      rotate_dial(**instructions)
    end

    @zero_counts_in_passing
  end

  def rotate(direction:, amount:)
    remainder = amount % @total_length
    full_circles = amount / @total_length
    @zero_counts_in_passing += full_circles
    initial_position_was_zero = @dial_position.zero?

    if direction == :left
      if remainder <= @dial_position
        @dial_position -= remainder
      else
        @dial_position = DIAL_MAXIMUM + 1 - (remainder - @dial_position)
        @zero_counts_in_passing += 1 unless @dial_position.zero? || initial_position_was_zero
      end
    else
      remaining_ticks = DIAL_MAXIMUM - @dial_position
      if remainder <= remaining_ticks
        @dial_position += remainder
      else
        @dial_position = DIAL_MINIMUM + (remainder - remaining_ticks) - 1
        @zero_counts_in_passing += 1 unless @dial_position.zero? || initial_position_was_zero
      end
    end

    @final_zero_counts += 1 if @dial_position.zero?
  end

  def rotate_dial(direction:, amount:)
    full_circles = amount / @total_length
    @zero_counts_in_passing += full_circles
    remainder = amount % @total_length

    remainder.times do
      @dial_position = @dial[@dial_position].next(direction: direction).position
      @zero_counts_in_passing += 1 if @dial_position.zero?
    end
  end

  class Node
    attr_accessor :right_node, :left_node, :position

    def initialize(position:)
      @position = position
    end

    def next(direction:)
      return @left_node if direction == :left

      @right_node if direction == :right
    end
  end
end
