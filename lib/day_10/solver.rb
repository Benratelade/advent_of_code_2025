# frozen_string_literal: true

require_relative "machine"
class Solver
  def initialize(file)
    @file = file
    process_file
  end

  def solve_part_1; end

  def solve_part_2; end

  private

  def process_file
    File.readlines(@file).each do |line|
      indicator_lights = line.match(/(\[.*\])/)[1]
      buttons = line.to_enum(:scan, /(\([\d,]+\))+/).map { Regexp.last_match[1] }
      joltage_requirements = line.match(/(\{[\d,]+})/)[1]

      Machine.new(
        indicator_lights: indicator_lights,
        buttons: buttons,
        joltage_requirements: joltage_requirements,
      )
    end
  end
end
