# frozen_string_literal: true

require_relative "junction_box"
require_relative "three_d_tree"

class Solver
  attr_reader :junction_boxes, :three_d_tree

  def initialize(file, connections_count: 10)
    @file = file
    @circuits = {}
    @connections_count = connections_count

    process_file
    @distances = {}
    @junction_boxes.combination(2).each do |pair|
      @distances[pair] = ThreeDTree.unsquare_rooted_distance_between(first_point: pair[0], second_point: pair[1])
    end
    @distances = @distances.sort_by { |_key, value| value }
  end

  def solve_part_1
    @connections_count.times do |index|
      junction_box_pair = @distances[index][0]
      first_junction_box = junction_box_pair[0]

      second_junction_box = junction_box_pair[1]
      first_circuit = first_junction_box.circuit
      second_circuit = second_junction_box.circuit

      new_circuit = Circuit.new
      new_circuit.junction_boxes = first_circuit.junction_boxes + second_circuit.junction_boxes
      new_circuit.junction_boxes += [first_junction_box, second_junction_box]
      new_circuit.junction_boxes = new_circuit.junction_boxes.uniq
      new_circuit.junction_boxes.each { |junction_box| junction_box.circuit = new_circuit }
    end

    circuits_sorted_by_size = @junction_boxes.map(&:circuit).uniq.sort_by do |circuit|
      circuit.junction_boxes.count
    end.reverse!

    circuits_sorted_by_size[0..2].inject(1) { |accumulator, circuit| accumulator * circuit.junction_boxes.count }
  end

  def solve_part_2
    final_connection = nil
    count = 0
    circuits_count = @junction_boxes.map(&:circuit).uniq.count
    while circuits_count > 1
      junction_box_pair = @distances[count][0]
      first_junction_box = junction_box_pair[0]

      second_junction_box = junction_box_pair[1]
      first_circuit = first_junction_box.circuit
      second_circuit = second_junction_box.circuit

      new_circuit = Circuit.new
      new_circuit.junction_boxes = first_circuit.junction_boxes + second_circuit.junction_boxes
      new_circuit.junction_boxes += [first_junction_box, second_junction_box]
      new_circuit.junction_boxes = new_circuit.junction_boxes.uniq
      new_circuit.junction_boxes.each { |junction_box| junction_box.circuit = new_circuit }

      count += 1
      circuits_count = @junction_boxes.map(&:circuit).uniq.count
      if circuits_count == 1
        final_connection = [first_junction_box, second_junction_box]
        break
      end
    end

    final_connection[0].x_coord * final_connection[1].x_coord
  end

  private

  def process_file
    @junction_boxes = File.readlines(@file).map do |line|
      x_coord, y_coord, z_coord = line.split(",").map(&:to_i)
      JunctionBox.new(x_coord: x_coord, y_coord: y_coord, z_coord: z_coord)
    end
  end
end
