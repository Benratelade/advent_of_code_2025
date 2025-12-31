# frozen_string_literal: true

class Solver
  attr_reader :devices, :reverse_devices

  def initialize(file)
    @file = file
    @cache = {}

    process_devices
  end

  def solve_part_1
    paths = follow_all_paths_between("you", "out")
    paths.uniq.count
  end

  def solve_part_2
    recurse_count_all_paths_between("svr", "out")
  end

  def follow_all_paths_between(start_address, end_address)
    paths = []

    start = start_address
    incomplete_paths = { start => start }
    loop do
      break if incomplete_paths.empty?

      new_incomplete_paths = {}
      incomplete_paths.each do |incomplete_path, next_output|
        @devices[next_output].each do |next_3_chars|
          new_path = incomplete_path + next_3_chars
          if next_3_chars == end_address || next_3_chars == "out"
            paths << new_path
          else
            new_incomplete_paths[new_path] = next_3_chars
          end
        end
      end
      incomplete_paths = new_incomplete_paths
    end

    paths.uniq
  end

  def recurse_count_all_paths_between(path_start, end_address, visited_fft: false, visited_dac: false)
    cache_signature = "#{path_start}-#{visited_fft}-#{visited_dac}"
    if path_start == end_address || path_start == "out"
      return 1 if visited_fft && visited_dac

      return 0
    end

    return @cache[cache_signature] if @cache[cache_signature]

    paths_from_here = @devices[path_start]

    visited_fft ||= path_start == "fft"
    visited_dac ||= path_start == "dac"
    total = paths_from_here.sum do |path_from_here|
      recurse_count_all_paths_between(path_from_here, end_address, visited_fft: visited_fft, visited_dac: visited_dac)
    end

    @cache[cache_signature] = total
    total
  end

  private

  def process_devices
    @devices = {}
    @reverse_devices = {}
    File.readlines(@file).each do |line|
      input = line.match(/(\w{3}):/)[1]
      outputs = line[4..].split
      @devices[input] = outputs
      outputs.each do |output|
        @reverse_devices[output] ||= []
        @reverse_devices[output] << input
      end
    end
  end
end
