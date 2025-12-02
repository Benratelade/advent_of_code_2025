# frozen_string_literal: true

class Solver
  attr_reader :ranges

  def initialize(file)
    @file = file
    @ranges = process_file
    @invalid_ids = []
    @invalid_ids_for_part_2 = []
  end

  def solve_part_1
    @ranges.each do |range|
      @invalid_ids += get_invalid_ids_from_range(range)
    end
    @invalid_ids.sum
  end

  def solve_part_2
    @ranges.each do |range|
      @invalid_ids_for_part_2 += get_invalid_ids_from_range_for_part_2(range)
    end
    @invalid_ids_for_part_2.sum
  end

  def process_file
    File.read(@file).split(",").map do |range_as_string|
      range_start, range_end = range_as_string.split("-")
      (range_start.to_i..range_end.to_i)
    end
  end

  def get_invalid_ids_from_range(range)
    invalid_ids = []
    range.each do |number|
      stringified_number = number.to_s
      next unless stringified_number.length.even?

      middle_point = stringified_number.length / 2
      first_half = stringified_number[0...middle_point]
      second_half = stringified_number[middle_point..]

      invalid_ids << number if first_half == second_half
    end

    invalid_ids
  end

  def get_invalid_ids_from_range_for_part_2(range)
    invalid_ids = []
    range.each do |number|
      stringified_number = number.to_s

      invalid_ids << number if stringified_number.match?(/^(.+)\1+$/)
    end

    invalid_ids
  end
end
