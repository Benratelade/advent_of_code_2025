# frozen_string_literal: true

class Solver
  attr_reader :battery_banks

  def initialize(file)
    @file = file
    @battery_banks = []
    assign_battery_banks
  end

  def solve_part_1
    battery_banks.sum do |battery_bank|
      extract_joltage_from_battery_bank(battery_bank)
    end
  end

  def solve_part_2
    all_joltages = []
    threads = @battery_banks.map do |battery_bank|
      threads << Thread.new do
        all_joltages << extract_joltage_from_battery_bank_for_part_2(battery_bank)
      end
    end

    threads.each(&:join)
    all_joltages.sum
  end

  def assign_battery_banks
    File.readlines(@file).each do |line|
      @battery_banks << line.strip.chars.map(&:to_i)
    end
  end

  def extract_joltage_from_battery_bank(battery_bank)
    all_maxes = []

    battery_bank.length.times do |index|
      all_maxes << "#{battery_bank[0...index].max}#{battery_bank[index..].max}".to_i
    end

    all_maxes.max
  end

  def extract_joltage_from_battery_bank_for_part_2(battery_bank)
    first_available_index = 0
    last_used_index = battery_bank.length - 12
    max_array = battery_bank[last_used_index..]

    (0...12).each do |position|
      new_positions_to_consider = battery_bank[first_available_index...last_used_index]
      new_max_for_position = new_positions_to_consider.max
      index_of_new_max = new_positions_to_consider.index(new_max_for_position) + first_available_index

      if new_max_for_position > max_array[position]
        max_array[position] = new_max_for_position
        first_available_index = index_of_new_max + 1
        last_used_index += 1
      elsif new_max_for_position == max_array[position]
        last_used_index += 1
      elsif new_max_for_position < max_array[position]
        break
      end
    end

    max_array.join.to_i
  end
end
