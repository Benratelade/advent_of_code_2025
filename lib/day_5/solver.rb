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

  def solve_part_2; end

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
