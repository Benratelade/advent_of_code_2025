# frozen_string_literal: true

require_relative "junction_box"
require_relative "three_d_tree"

class Solver
  attr_reader :junction_boxes, :three_d_tree

  def initialize(file)
    @file = file

    process_file
  end

  def solve_part_1
  end

  def solve_part_2
  end

  private

  def process_file
    @junction_boxes = File.readlines(@file).map do |line|
      x_coord, y_coord, z_coord = line.split(",").map(&:to_i)
      JunctionBox.new(x_coord: x_coord, y_coord: y_coord, z_coord: z_coord)
    end

    @three_d_tree = ThreeDTree.new(@junction_boxes)
  end
end
