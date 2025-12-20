# frozen_string_literal: true

class ThreeDTree
  attr_accessor :root, :points_hash

  AXES = %i[x_coord y_coord z_coord].freeze

  def self.unsquare_rooted_distance_between(first_point:, second_point:)
    x_delta = first_point.x_coord - second_point.x_coord
    y_delta = first_point.y_coord - second_point.y_coord
    z_delta = first_point.z_coord - second_point.z_coord

    # we don't really need the square root for comparison
    (x_delta**2) + (y_delta**2) + (z_delta**2)
  end

  def self.calculate_distance_between(first_point:, second_point:)
    Math.sqrt(unsquare_rooted_distance_between(first_point: first_point, second_point: second_point))
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
    new_root = Node.new(value: median_point, axis: axis)
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

  def find_nearest_neighbour_for(point:, root_node:, nearest_node_candidate: { point: point })
    return if root_node.nil?

    distance = ThreeDTree.unsquare_rooted_distance_between(first_point: point, second_point: root_node.value)
    if (nearest_node_candidate[:distance].nil? || distance < nearest_node_candidate[:distance]) && distance != 0
      nearest_node_candidate[:node] = root_node
      nearest_node_candidate[:distance] = distance
    end

    axis = root_node.axis
    next_node, other_node = nil
    if point.public_send(axis) < root_node.value.public_send(axis)
      next_node = root_node.left_child
      other_node = root_node.right_child
    else
      next_node = root_node.right_child
      other_node = root_node.left_child
    end

    find_nearest_neighbour_for(
      root_node: next_node,
      point: point,
      nearest_node_candidate: nearest_node_candidate,
    )

    distance_to_other_plane = (root_node.value.public_send(axis) - point.public_send(axis))**2
    if nearest_node_candidate[:distance] > (distance_to_other_plane)
      find_nearest_neighbour_for(
        root_node: other_node,
        point: point,
        nearest_node_candidate: nearest_node_candidate,
      )
    end

    nearest_node_candidate

    # We are doing a special case of nearest neighbour:
    # the point we are trying to find a close neighbour for is
    # already in the tree. We don't need to start from root?
    # compare the correct axis
    # follow tree until you reach point?
  end

  private

  def descend_tree_from(start_node:, target_point:)
    return start_node if start_node.children.count.zero?

    axis = start_node.axis

    if target_point.public_send(axis) < start_node.value.public_send(axis)
      descend_tree_from(start_node: start_node.left_child, target_point: target_point)
    else
      descend_tree_from(start_node: start_node.right_child, target_point: target_point)
    end
  end

  class Node
    attr_accessor :value, :children, :axis

    def initialize(value:, axis:)
      @value = value
      @axis = axis
      @children = []
    end

    def left_child
      @children[0]
    end

    def right_child
      @children[1]
    end
  end
end
