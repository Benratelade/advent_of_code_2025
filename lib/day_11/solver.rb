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
    # this builds the cache. We know dac comes last
    count_paths_after_dac = recurse_count_all_paths_between("dac", "out")
    # this builds the cache. We know fft comes firt
    count_paths_after_fft = recurse_count_all_paths_between("fft", "out")
    binding.irb
    recurse_count_all_paths_between("svr", "out")[:came_through_both]
  end

  def find_all_path_starts_between(end_address:, start_address: "svr")
    paths = []

    incomplete_reverse_paths = { end_address => end_address }

    loop do
      break if incomplete_reverse_paths.empty?

      new_incomplete_paths = {}
      incomplete_reverse_paths.each do |incomplete_path, previous_inputs|
        @reverse_devices[previous_inputs].each do |previous_3_chars|
          new_path = [previous_3_chars, incomplete_path].join(" ")
          if previous_3_chars == start_address || previous_3_chars == "svr"
            paths << new_path
          else
            new_incomplete_paths[new_path] = previous_3_chars
          end
        end
      end
      incomplete_reverse_paths = new_incomplete_paths
    end

    paths
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

    puts paths.uniq
    paths.uniq
  end

  def recurse_count_all_paths_between(path_start, end_address, visited_fft = false, visited_dac = false)
    if path_start == end_address || path_start == "out"
      return {
        total: 1,
        came_through_fft: visited_fft ? 1 : 0,
        came_through_dac: visited_dac ? 1 : 0,
        came_through_both: visited_fft && visited_dac ? 1 : 0,
      }
    end

    # binding.irb if @cache[path_start]
    return @cache[path_start] if @cache[path_start]

    paths_from_here = @devices[path_start]

    visited_fft ||= path_start == "fft"
    visited_dac ||= path_start == "dac"
    paths_summaries = paths_from_here.map do |path_from_here|
      recurse_count_all_paths_between(path_from_here, end_address, visited_fft, visited_dac)
    end

    new_summary = {
      total: paths_summaries.sum { |summary| summary[:total] },
      came_through_fft: paths_summaries.sum { |summary| summary[:came_through_fft] },
      came_through_dac: paths_summaries.sum { |summary| summary[:came_through_dac] },
      came_through_both: paths_summaries.sum { |summary| summary[:came_through_both] },
    }

    @cache[path_start] ||= new_summary
    new_summary
  end

  def follow_all_paths_between_and_stop_when_found(start_address, end_address)
    paths = []

    start = start_address
    end_address_reached = false
    incomplete_paths = { start => start }
    loop do
      break if end_address_reached

      new_incomplete_paths = {}
      incomplete_paths.each do |incomplete_path, next_output|
        @devices[next_output].each do |next_3_chars|
          new_path = incomplete_path + next_3_chars
          if next_3_chars == end_address
            paths << new_path
            end_address_reached = true
            break
          else
            new_incomplete_paths[new_path] = next_3_chars
          end
        end
      end
      incomplete_paths = new_incomplete_paths
    end

    puts paths.uniq
    paths.uniq
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
