# frozen_string_literal: true

class Solver
  attr_reader :devices

  def initialize(file)
    @file = file

    process_devices
  end

  def solve_part_1
    minimum_count = @machines.map do |machine|
      press_all_buttons_for_machine(machine)
    end

    minimum_count.sum
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
