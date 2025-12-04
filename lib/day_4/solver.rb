# frozen_string_literal: true

require_relative "../commons/map"
class Solver
  attr_reader :map

  def initialize(file)
    @file = file

    process_file
  end

  def solve_part_1
    valid_cells_count = 0
    @map.each do |value, x_index, y_index|
      next unless value == "@"

      surrounded_by_rolls_count = 0
      @map.surrounding_values_for(x_index, y_index).each do |surrounding_value|
        surrounded_by_rolls_count += 1 if surrounding_value[:value] == "@"
      end
      valid_cells_count += 1 if surrounded_by_rolls_count < 4
    end

    valid_cells_count
  end

  def solve_part_2;end

  private

  def process_file
    map_array = File.readlines(@file).map do |line|
      line.strip.chars
    end

    @map = Commons::Map.new(map_array)
  end
end
