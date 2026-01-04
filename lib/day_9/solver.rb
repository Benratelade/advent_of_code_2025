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
    @point_in_polygon_cache = {}
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

    rectangles_count = 0
    leftmost_points.each do |left_point|
      rightmost_points.each do |right_point|
        rectangles_count += 1
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

    puts "total inspected rectangles: #{rectangles_count}"
    @areas.max { |pair_1, pair_2| pair_1[1] <=> pair_2[1] }[1]
  end

  def solve_part_2
    min_x = @compressed_points.first.x_coord
    max_x = @compressed_points.last.x_coord
    middle_x = (min_x + max_x) / 2

    leftmost_points = @compressed_points.filter { |point| point.x_coord <= middle_x }
    rightmost_points = @compressed_points.filter { |point| point.x_coord > middle_x }

    unless leftmost_points.count + rightmost_points.count == @compressed_points.count
      raise "Split the points the wrong way!"
    end

    rectangles_count = 0
    leftmost_points.each do |left_point|
      rightmost_points.each do |right_point|
        puts "inspected #{rectangles_count} so far" if (rectangles_count % 5000).zero?
        rectangles_count += 1
        corner_point = if left_point.y_coord <= right_point.y_coord
                         # find top-right corner
                         CompressedPoint.new(
                           x_coord: left_point.x_coord,
                           y_coord: right_point.y_coord,
                           source_point: Point.new(left_point.source_point.x_coord, right_point.source_point.y_coord),
                         )
                       else
                         # find bottom-right corner
                         CompressedPoint.new(
                           x_coord: right_point.x_coord,
                           y_coord: left_point.y_coord,
                           source_point: Point.new(right_point.source_point.x_coord, left_point.source_point.y_coord),
                         )
                       end

        # we need to check that all points within this rectangle belong in the polygon
        min_inner_y_coord = [left_point, right_point].min_by(&:y_coord).y_coord
        max_inner_y_coord = [left_point, right_point].max_by(&:y_coord).y_coord
        min_inner_x_coord = [left_point, right_point].min_by(&:x_coord).x_coord
        max_inner_x_coord = [left_point, right_point].max_by(&:x_coord).x_coord
        all_points_in_polygon = true
        (min_inner_y_coord..max_inner_y_coord).each do |y_coord|
          (min_inner_x_coord..max_inner_x_coord).each do |x_coord|
            point = Point.new(x_coord: x_coord, y_coord: y_coord)
            if @point_in_polygon_cache["#{x_coord};#{y_coord}"].nil?
              @point_in_polygon_cache["#{x_coord};#{y_coord}"] = point_is_in_polygon?(point)
            end
            all_points_in_polygon = false unless @point_in_polygon_cache["#{x_coord};#{y_coord}"]
          end
        end
        # binding.irb if right_point.x_coord == 217 && right_point.y_coord == 123 && left_point.y_coord == 133
        next unless all_points_in_polygon

        area = calculate_area(left_point.source_point, right_point.source_point, corner_point.source_point)

        @part_2_areas ||= {}
        @part_2_areas[[left_point.source_point, right_point.source_point]] = area
      end
    end

    puts "total inspected rectangles: #{rectangles_count}"
    @part_2_areas.max { |pair_1, pair_2| pair_1[1] <=> pair_2[1] }[1]
  end

  def point_is_in_polygon?(point)
    # binding.irb if point.x_coord == 7 && point.y_coord == 124
    # binding.irb if point.x_coord == 8 && point.y_coord == 124
    return true if point_is_on_an_edge?(point)

    sides_crossed = []
    # Ray casting algorithm: check how many edges are crossed to the right of the point
    sides_to_the_right = @polygon.sides.select do |side|
      point.x_coord <= side.max_x
    end
    sides_to_the_right.each do |side|
      point_traverses_side = (side.min_y..side.max_y).include?(point.y_coord)

      next unless point_traverses_side

      # never include a horizontal vertex
      next if side.min_y == side.max_y && side.min_y == point.y_coord
      # only include vertical vertex if min_y is less than point.y_coord
      if side.min_x == side.max_x && (side.min_y == point.y_coord || side.max_y == point.y_coord) && side.min_y >= point.y_coord
        next
      end

      sides_crossed << side
    end
    # binding.irb if point.x_coord == 7 && point.y_coord == 124
    return false if sides_crossed.empty?

    sides_crossed.count.odd?
  end

  def point_is_on_an_edge?(point)
    crosses_vertical_side = @polygon.vertical_sides.any? do |vertical_side|
      (vertical_side.min_y..vertical_side.max_y).include?(point.y_coord) && point.x_coord == vertical_side.min_x
    end

    crosses_horizontal_side = @polygon.horizontal_sides.any? do |horizontal_side|
      (horizontal_side.min_x..horizontal_side.max_x).include?(point.x_coord) && point.y_coord == horizontal_side.min_y
    end

    crosses_vertical_side || crosses_horizontal_side
  end

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
    previous_edge = nil
    loop do
      end_point = find_next_point(start_point, previous_side_orientation: previous_side_orientation)
      previous_side_orientation = previous_side_orientation == :vertical ? :horizontal : :vertical
      new_edge = Edge.new(start_point: start_point, end_point: end_point)
      unless previous_edge.nil?
        # previous_edge.add_adjacent_edge(new_edge)
        # new_edge.add_adjacent_edge(previous_edge)
      end

      @polygon.sides << new_edge
      previous_edge = new_edge

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

    def horizontal_sides
      @horizontal_sides ||= @sides.select { |side| side.min_y == side.max_y }
    end

    def vertical_sides
      @vertical_sides ||= @sides.select { |side| side.min_x == side.max_x }
    end
  end

  class Edge
    attr_reader :start_point, :end_point, :min_x, :max_x, :min_y, :max_y, :adjacent_edges

    def initialize(start_point:, end_point:)
      @start_point = start_point
      @end_point = end_point
      @min_x = [@start_point, @end_point].min_by(&:x_coord).x_coord
      @max_x = [@start_point, @end_point].max_by(&:x_coord).x_coord
      @min_y = [@start_point, @end_point].min_by(&:y_coord).y_coord
      @max_y = [@start_point, @end_point].max_by(&:y_coord).y_coord

      @adjacent_edges = []
    end

    def points
      [start_point, end_point]
    end

    def add_adjacent_edge(edge)
      @adjacent_edges << edge
    end
  end
end
