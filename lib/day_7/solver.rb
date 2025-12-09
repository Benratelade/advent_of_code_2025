# frozen_string_literal: true

require_relative "../commons/map"

class Solver
  attr_reader :map, :starting_point

  def initialize(file)
    @file = file
    @part_1_split_count = 0
    @duplicate_paths_count = 0
    @all_visited_nodes = {}

    process_input
  end

  def solve_part_1
    (@map.height - 1).times do
      advance_beam
    end

    @part_1_split_count
  end

  def solve_part_2
    (@map.height - 1).times do
      advance_beam
    end

    @all_visited_nodes.each do |level, visited_nodes|
      next unless visited_nodes.all? do |_node, count|
        count.nil?
      end

      visited_nodes.each_key do |visited_node|
        if visited_node[:value] == "S"
          visited_nodes[visited_node] = 1
          next
        end

        sources_for_node = find_possible_sources(level - 1, visited_node)

        visited_nodes[visited_node] = sources_for_node.map do |source_node|
          @all_visited_nodes[level - 1][source_node]
        end.sum
      end
    end

    @all_visited_nodes[@map.height - 1].sum { |_node, value| value }
  end

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
    @beam_coordinates = [@starting_point]
    record_visited_nodes
  end

  def record_visited_nodes
    current_row = @beam_coordinates.map { |nodes| nodes[:y_coord] }.uniq.first
    @all_visited_nodes[current_row] = {}

    @beam_coordinates.each do |node|
      @all_visited_nodes[current_row][node] = nil
    end
  end

  def advance_beam
    new_beam_coordinates = []

    @beam_coordinates.each do |coordinates|
      destination = @map.down(coordinates[:x_coord], coordinates[:y_coord])

      if destination[:value] == "."
        new_beam_coordinates << destination
        next
      else
        @part_1_split_count += 1
        new_beam_coordinates << @map.left(destination[:x_coord], destination[:y_coord])
        new_beam_coordinates << @map.right(destination[:x_coord], destination[:y_coord])
      end
    end

    @duplicate_paths_count += new_beam_coordinates.count - new_beam_coordinates.uniq.count
    @beam_coordinates = new_beam_coordinates.uniq
    record_visited_nodes
  end

  def find_possible_sources(level, visited_node)
    candidates = []
    left_node = @map.left(visited_node[:x_coord], visited_node[:y_coord])
    right_node = @map.right(visited_node[:x_coord], visited_node[:y_coord])
    candidates << @map.up(visited_node[:x_coord], visited_node[:y_coord])
    if left_node && left_node[:value] == "^"
      above_left_node = @map.up(left_node[:x_coord], left_node[:y_coord])
      candidates << above_left_node
    end

    if right_node && right_node[:value] == "^"
      above_right_node = @map.up(right_node[:x_coord], right_node[:y_coord])
      candidates << above_right_node
    end

    candidates.select do |candidate|
      @all_visited_nodes[level][candidate]
    end
  end
end
