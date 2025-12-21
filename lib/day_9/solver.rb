# frozen_string_literal: true

require_relative "../commons/map"

Point = Data.define(:x_coord, :y_coord)
class Solver
  attr_reader :map

  def self.edge_length(first_point, second_point)
    x_delta = first_point.x_coord - second_point.x_coord
    y_delta = first_point.y_coord - second_point.y_coord

    # we don't really need the square root for comparison
    Math.sqrt((x_delta**2) + (y_delta**2)) + 1
  end

  def initialize(file)
    @file = file
    @red_tiles_points = []
    process_file
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
        puts "Measuring distance for #{point_to_s(left_point)} - #{point_to_s(right_point)}"
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
      @red_tiles_points << Point.new(x_coord: x_coord, y_coord: y_coord)
    end

    @red_tiles_points = @red_tiles_points.sort_by(&:x_coord)
  end

  def point_to_s(point)
    "#{point.x_coord}, #{point.y_coord}"
  end
end
