# frozen_string_literal: true

class Solver
  attr_reader :battery_banks

  def initialize(file)
    @file = file
    @battery_banks = []
    assign_battery_banks
  end

  def solve_part_1
    @battery_banks.sum do |battery_bank|
      extract_joltage_from_battery_bank(battery_bank)
    end
  end

  def solve_part_2
    all_joltages = []

    threads = @battery_banks.map do |battery_bank|
      Thread.new do
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

  def extract_joltage_from_battery_bank_for_part_2(battery_bank) # rubocop:disable Metrics/AbcSize
    puts "battery bank at start: #{battery_bank.join}"
    max_array_hash = {}
    12.times do |index|
      index_in_battery_bank = battery_bank.length - 12 + index
      max_array_hash[index] = {
        position: index_in_battery_bank,
        value: battery_bank[index_in_battery_bank],
      }
    end
    puts "Max array at start: #{max_array_hash.values.map { |item| item[:value] }.join}"
    puts "Max array positions at start: #{max_array_hash.values.map { |item| item[:position] }.join(',')}"

    first_available_index = 0
    last_used_index = battery_bank.length - 12

    (0...12).each do |position|
      puts
      puts ">>>>> beginning of step: #{position}"
      puts "Max array: #{max_array_hash.values.map { |item| item[:value] }.join}"
      puts "Max array positions: #{max_array_hash.values.map { |item| item[:position] }.join(',')}"
      new_positions_to_consider = battery_bank[first_available_index...last_used_index]
      new_max_for_position = new_positions_to_consider.max
      puts "Looking for a new max for position: #{position}, current_value: #{max_array_hash[position][:value]}"
      puts "Finding new max between start: #{first_available_index} and end #{last_used_index} (excluded)"
      puts "It looks like #{new_positions_to_consider.join}"
      index_of_new_max = new_positions_to_consider.index(new_max_for_position) + first_available_index
      puts "new max candidate: #{new_max_for_position} at position: #{index_of_new_max}"

      if new_max_for_position > max_array_hash[position][:value]
        max_array_hash[position] = {
          position: index_of_new_max,
          value: new_max_for_position,
        }
        first_available_index = index_of_new_max + 1
        last_used_index = max_array_hash[position + 1] ? max_array_hash[position + 1][:position] : nil
      elsif new_max_for_position == max_array_hash[position][:value]
        first_available_index = index_of_new_max + 1
        last_used_index = max_array_hash[position + 1] ? max_array_hash[position + 1][:position] : nil
      elsif new_max_for_position < max_array_hash[position][:value]
        break
      end
    end

    puts "final max array: #{max_array_hash.values.map { |item| item[:value] }.join.to_i}"
    max_array_hash.values.map { |item| item[:value] }.join.to_i
  end
end
