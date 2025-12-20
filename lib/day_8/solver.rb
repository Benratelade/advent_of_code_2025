# frozen_string_literal: true

require_relative "junction_box"
require_relative "three_d_tree"

class Solver
  attr_reader :junction_boxes, :three_d_tree

  def initialize(file)
    @file = file
    @circuits = {}

    process_file
  end

  def solve_part_1
    @distances = []
    unique_pairs = {}
    @three_d_tree.points_hash.each_key do |junction_box|
      distance_hash = @three_d_tree.find_nearest_neighbour_for(point: junction_box, root_node: @three_d_tree.root)
      distance_hash_signature = [distance_hash[:point].to_s, distance_hash[:node].value.to_s].sort
      next if unique_pairs[distance_hash_signature]
      
      unique_pairs[distance_hash_signature] = true
      @distances << distance_hash
    end

    @distances.sort_by! do |distance|
      distance[:distance]
    end
 
    @distances.each do |distance|
     puts "#{distance[:point]} - #{distance[:node].value}: #{distance[:distance]}"
    end
    # processed_pairs = {}
    10.times do |index|
      first_junction_box = @distances[index][:point]

      second_junction_box = @distances[index][:node].value
      first_circuit = first_junction_box.circuit
      second_circuit = second_junction_box.circuit
      # pair = { first_junction_box => true, second_junction_box => true }

      # next if processed_pairs[pair]

      if first_circuit == second_circuit
        # processed_pairs[pair] = true
        next
      end

      new_circuit = Circuit.new
      new_circuit.junction_boxes = first_circuit.junction_boxes + second_circuit.junction_boxes
      new_circuit.junction_boxes += [first_junction_box, second_junction_box]
      new_circuit.junction_boxes = new_circuit.junction_boxes.uniq
      new_circuit.junction_boxes.each { |junction_box| junction_box.circuit = new_circuit }
      # processed_pairs[pair] = true
      circuits_count = @junction_boxes.map(&:circuit).uniq.count
      puts "There are currently #{circuits_count} circuits"
    end

    circuits_sorted_by_size = @junction_boxes.map(&:circuit).uniq.sort_by do |circuit|
      circuit.junction_boxes.count
    end.reverse!

    circuits_sorted_by_size[0..2].inject(1) { |accumulator, circuit| accumulator * circuit.junction_boxes.count }
  end

  def solve_part_2; end

  private

  def process_file
    @junction_boxes = File.readlines(@file).map do |line|
      x_coord, y_coord, z_coord = line.split(",").map(&:to_i)
      JunctionBox.new(x_coord: x_coord, y_coord: y_coord, z_coord: z_coord)
    end

    @three_d_tree = ThreeDTree.new(@junction_boxes)
  end
end
