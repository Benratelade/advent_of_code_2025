# frozen_string_literal: true

class Solver
  attr_reader :devices

  def initialize(file)
    @file = file

    process_devices
  end

  def solve_part_1
    paths = []

    start = "you"
    incomplete_paths = { start => "you" }
    loop do
      break if incomplete_paths.empty?

      new_incomplete_paths = {}
      incomplete_paths.each do |incomplete_path, next_output|
        devices[next_output].each do |next_3_chars|
          new_path = incomplete_path + next_3_chars
          if next_3_chars == "out"
            paths << new_path
          else
            new_incomplete_paths[new_path] = next_3_chars
          end
        end
      end
      incomplete_paths = new_incomplete_paths
    end

    paths.uniq.count
  end

  def solve_part_2; end

  private

  def process_devices
    @devices = {}
    File.readlines(@file).each do |line|
      input = line.match(/(\w{3}):/)[1]
      outputs = line[4..].split
      @devices[input] = outputs
    end
  end
end
