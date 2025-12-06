# frozen_string_literal: true

class Solver
  attr_reader :ingredient_ids, :ranges

  def initialize(file)
    @file = file
    @ingredient_ids = []
    @ranges = []

    process_file
  end

  def solve_part_1
    fresh_ingredients = @ingredient_ids.filter_map do |ingredient_id|
      fresh?(ingredient_id)
    end

    fresh_ingredients.count
  end

  def solve_part_2
    final_ranges = []
    removed_ranges = []

    @ranges.each do |range|
      next if removed_ranges.include?(range)

      # combine with all other ranges and repeat until the range does not get modified anymode
      accumulator_range = range
      accumulator_modified = true
      while accumulator_modified
        initial_accumulator_value = accumulator_range
        @ranges.each do |range_to_merge|
          next if removed_ranges.include?(range_to_merge)

          combined_ranges = Solver.combine_ranges(accumulator_range, range_to_merge)

          next unless combined_ranges

          accumulator_range = combined_ranges
          removed_ranges << range_to_merge
        end
        accumulator_modified = initial_accumulator_value != accumulator_range
      end
      final_ranges << accumulator_range
    end

    final_ranges.sum(&:count)
  end

  def self.combine_ranges(range_1, range_2)
    if range_1.overlap?(range_2)
      return (
        [range_1.first, range_2.first].min..([range_1.end, range_2.end].max)
      )
    end

    false
  end

  private

  def fresh?(ingredient_id)
    @ranges.each do |range|
      return true if range.include?(ingredient_id)
    end

    false
  end

  def process_file
    mode = :ranges

    File.readlines(@file).each do |line|
      if line.strip.empty?
        mode = :ingredient_ids
        next
      end

      if mode == :ranges
        range_start, range_end = line.strip.split("-").map(&:to_i)
        @ranges << (range_start..range_end)
      elsif mode == :ingredient_ids
        @ingredient_ids << line.strip.to_i
      end
    end
  end
end
