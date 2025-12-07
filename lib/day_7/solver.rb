# frozen_string_literal: true

require_relative "../commons/map"

class Solver
  attr_reader :map, :starting_point

  def initialize(file)
    @file = file
    @part_1_split_counts = 0

    process_input
  end

  def solve_part_1
    (@map.height - 1).times do
      advance_beam
    end

    @part_1_split_counts
  end

  def solve_part_2; end

  private

  def process_input
    map_array = File.readlines(@file).map do |line|
      line.strip.chars
    end

    @map = Commons::Map.new(map_array)

    @map.each do |cell_value, x_coord, y_coord|
      if cell_value == "S"
        @starting_point = { value: cell_value, x_coord: x_coord, y_coord: y_coord }
        break
      end
    end
  end

  def advance_beam
    @beam_coordinates ||= [@starting_point]
    new_beam_coordinates = []

    @beam_coordinates.each do |coordinates|
      destination = @map.down(coordinates[:x_coord], coordinates[:y_coord])
      # next unless destination

      if destination[:value] == "."
        new_beam_coordinates << destination
        next
      else
        @part_1_split_counts += 1
        new_beam_coordinates << @map.left(destination[:x_coord], destination[:y_coord])
        new_beam_coordinates << @map.right(destination[:x_coord], destination[:y_coord])
      end
    end

    @beam_coordinates = new_beam_coordinates.uniq
  end
end
