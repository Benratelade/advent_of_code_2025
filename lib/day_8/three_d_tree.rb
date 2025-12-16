# frozen_string_literal: true

class ThreeDTree
  attr_accessor :root

  AXES = %i[x_coord y_coord z_coord].freeze

  def self.calculate_distance_between(first_point:, second_point:)
    x_delta = first_point.x_coord - second_point.x_coord
    y_delta = first_point.y_coord - second_point.y_coord
    z_delta = first_point.z_coord - second_point.z_coord

    Math.sqrt(
      (x_delta**2) +
        (y_delta**2) +
        (z_delta**2),
    )
  end

  def initialize(points)
    @points_hash = {}
    build_tree(root_node: nil, points: points, axis_index: 0)
  end

  def build_tree(root_node:, points:, axis_index:)
    return if points.count.zero?

    axis = AXES[axis_index % 3]
    sorted_points = points.sort_by { |item| item.public_send(axis) }
    median_index = sorted_points.length / 2

    median_point = sorted_points[median_index]
    new_root = Node.new(value: median_point)
    @points_hash[median_point] = new_root
    @root = new_root if root_node.nil?
    root_node.children << new_root unless root_node.nil?

    left_points = sorted_points[0...median_index]
    right_points = sorted_points[(median_index + 1)..]

    [left_points, right_points].each do |child_points|
      build_tree(
        root_node: new_root,
        points: child_points,
        axis_index: axis_index + 1,
      )
    end
  end

  def [](point)
    @points_hash[point]
  end

  def find_nearest_neighbour_for(point:)
    
  end

  class Node
    attr_accessor :value, :children

    def initialize(value:)
      @value = value
      @children = []
    end
  end
end
