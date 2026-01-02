# frozen_string_literal: true

require_relative "../commons/map"
require "matrix"

Point = Data.define(:x_coord, :y_coord)
CompressedPoint = Data.define(:x_coord, :y_coord, :source_point)
class Solver
  attr_reader :map, :polygon

  def self.edge_length(first_point, second_point)
    x_delta = first_point.x_coord - second_point.x_coord
    y_delta = first_point.y_coord - second_point.y_coord

    # we don't really need the square root for comparison
    Math.sqrt((x_delta**2) + (y_delta**2)) + 1
  end

  def initialize(file)
    @file = file
    @red_tiles_points = []
    @compressed_points = []
    @points_dictionary = {
      x_coords: {},
      y_coords: {},
    }
    @compressed_points_dictionary = {
      x_coords: {},
      y_coords: {},
    }
    process_file
    build_map
    build_polygon_from_compressed_points
  end

  def solve_part_1
    min_x = @red_tiles_points.first.x_coord
    max_x = @red_tiles_points.last.x_coord
    middle_x = (min_x + max_x) / 2

    leftmost_points = @red_tiles_points.filter { |point| point.x_coord <= middle_x }
    rightmost_points = @red_tiles_points.filter { |point| point.x_coord > middle_x }

    unless leftmost_points.count + rightmost_points.count == @red_tiles_points.count
      raise "Split the points the wrong way!"
    end

    leftmost_points.each do |left_point|
      rightmost_points.each do |right_point|
        corner_point = if left_point.y_coord <= right_point.y_coord
                         # find top-right corner
                         Point.new(x_coord: left_point.x_coord, y_coord: right_point.y_coord)
                       else
                         # find bottom-right corner
                         Point.new(x_coord: right_point.x_coord, y_coord: left_point.y_coord)
                       end

        area = calculate_area(left_point, right_point, corner_point)

        @areas ||= {}
        @areas[[left_point, right_point]] = area
      end
    end

    @areas.max { |pair_1, pair_2| pair_1[1] <=> pair_2[1] }[1]
  end

  def solve_part_2; end

  private

  def calculate_area(left_point, right_point, corner_point)
    width = Solver.edge_length(left_point, corner_point)
    height = Solver.edge_length(right_point, corner_point)

    width * height
  end

  def process_file
    File.readlines(@file).map do |line|
      x_coord, y_coord = line.strip.split(",").map(&:to_i)
      new_point = Point.new(x_coord: x_coord, y_coord: y_coord)
      @red_tiles_points << new_point
      @points_dictionary[:x_coords][x_coord] ||= []
      @points_dictionary[:x_coords][x_coord] << new_point

      @points_dictionary[:y_coords][y_coord] ||= []
      @points_dictionary[:y_coords][y_coord] << new_point
    end

    @red_tiles_points = @red_tiles_points.sort_by(&:x_coord)
  end

  def point_to_s(point)
    "#{point.x_coord}, #{point.y_coord}"
  end

  def build_map
    sorted_x_coords = @red_tiles_points.map(&:x_coord).sort.uniq
    sorted_y_coords = @red_tiles_points.map(&:y_coord).sort.uniq

    @compressed_points = @red_tiles_points.map do |point|
      compressed_x_coord = sorted_x_coords.index(point.x_coord)
      compressed_y_coord = sorted_y_coords.index(point.y_coord)

      new_point = CompressedPoint.new(
        x_coord: compressed_x_coord,
        y_coord: compressed_y_coord,
        source_point: point,
      )

      @compressed_points_dictionary[:x_coords][compressed_x_coord] ||= []
      @compressed_points_dictionary[:x_coords][compressed_x_coord] << new_point

      @compressed_points_dictionary[:y_coords][compressed_y_coord] ||= []
      @compressed_points_dictionary[:y_coords][compressed_y_coord] << new_point

      new_point
    end

    max_compressed_x = @compressed_points.max_by(&:x_coord).x_coord
    max_compressed_y = @compressed_points.max_by(&:y_coord).y_coord

    map_array = []
    (0..max_compressed_y).each do |row_index|
      row = []
      (0..max_compressed_x).each do |column_index|
        new_point = @compressed_points.find { |point| point.x_coord == column_index && point.y_coord == row_index }
        row << (new_point ? "#" : ".")
      end
      map_array << row
    end

    @map = Commons::Map.new(map_array)
  end

  def build_polygon_from_compressed_points
    @polygon = Polygon.new

    # Keep a reference to the very first point, to ensure we closed the loop
    # First point is lowest by :x_coord
    root_point = @compressed_points.first
    start_point = root_point
    previous_side_orientation = :vertical
    loop do
      end_point = find_next_point(start_point, previous_side_orientation: previous_side_orientation)
      previous_side_orientation = previous_side_orientation == :vertical ? :horizontal : :vertical
      @polygon.sides << [start_point, end_point]

      break if end_point == root_point

      start_point = end_point
    end
  end

  def find_next_point(start_point, previous_side_orientation:)
    return find_compressed_horizontal_neighbour(start_point) if previous_side_orientation == :vertical

    find_compressed_vertical_neighbour(start_point)
  end

  def find_compressed_horizontal_neighbour(point)
    side_end = @compressed_points_dictionary[:y_coords][point.y_coord].find do |neighbour_point|
      neighbour_point.x_coord < point.x_coord
    end
    side_end ||= @compressed_points_dictionary[:y_coords][point.y_coord].find do |neighbour_point|
      neighbour_point.x_coord > point.x_coord
    end

    side_end
  end

  def find_compressed_vertical_neighbour(point)
    side_end = @compressed_points_dictionary[:x_coords][point.x_coord].find do |neighbour_point|
      neighbour_point.y_coord < point.y_coord
    end
    side_end ||= @compressed_points_dictionary[:x_coords][point.x_coord].find do |neighbour_point|
      neighbour_point.y_coord > point.y_coord
    end

    side_end
  end

  class Polygon
    attr_reader :sides

    def initialize
      @sides = []
    end
  end
end
