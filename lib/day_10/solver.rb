# frozen_string_literal: true

require_relative "machine"
class Solver
  def initialize(file)
    @file = file
    process_file
  end

  def solve_part_1
    minimum_count = @machines.map do |machine|
      press_all_buttons_for_machine(machine)
    end

    minimum_count.sum
  end

  def solve_part_2
    minimum_counts = []
    slice_size = @machines.count / 3
    @machines.each_slice(slice_size).to_a.each_with_index do |slice, slice_index|
      # threads << Thread.new do
      slice.each_with_index do |machine, index|
        puts "processing joltage for machine number #{index + (slice_index * slice_size)}"
        minimum_counts << process_joltages_for_machine(machine)
        puts "processed #{minimum_counts.count} machines, minimum count: #{minimum_counts}"
      end
      # end
    end

    # threads.each(&:join)
    minimum_counts.sum
  end

  private

  def process_file
    @machines = []

    File.readlines(@file).each do |line|
      indicator_lights = line.match(/(\[.*\])/)[1]
      buttons = line.to_enum(:scan, /(\([\d,]+\))+/).map { Regexp.last_match[1] }
      joltage_requirements = line.match(/(\{[\d,]+})/)[1]

      @machines << Machine.new(
        indicator_lights_string: indicator_lights,
        buttons_string: buttons,
        joltage_requirements_string: joltage_requirements,
      )
    end
  end

  def press_all_buttons_for_machine(machine)
    count = 0
    cached_patterns = { machine.starting_indicator_lights => true }
    results = [machine.starting_indicator_lights]
    loop do
      count += 1
      new_results = []

      results.each do |result|
        machine.buttons.each do |button|
          temp_result = machine.press_button(button, result)
          new_results << temp_result unless cached_patterns[temp_result]
          cached_patterns[temp_result] ||= true
        end
      end

      break if new_results.any? { |new_result| new_result == machine.target_indicator_lights }

      results = new_results
    end

    count
  end

  def process_joltages_for_machine(machine)
    puts "Machine target: #{machine.target_joltage}"
    # reduce joltage to all even numbers
    reduced_machine_summary = reduce_machine_to_even_numbers(machine)

    halved_brute_force_result = brute_force_half_of(reduced_machine_summary[:starting_joltage], machine)
    reduced_machine_summary[:count] + halved_brute_force_result
  end

  def reduce_machine_to_even_numbers(machine)
    starting_joltages = [machine.target_joltage]
    count = 0
    even_joltage = nil
    loop do
      even_joltage = starting_joltages.find { |joltage| joltage.all?(&:even?) }
      break unless even_joltage.nil?

      new_starting_joltages = []
      starting_joltages.each do |starting_joltage|
        machine.buttons.each do |button|
          new_starting_joltages << (starting_joltage - button.joltage_vector)
        end
        count += 1
      end
      starting_joltages = new_starting_joltages
    end

    { starting_joltage: even_joltage, count: count }
  end

  def brute_force_half_of(joltage, machine)
    multiplier = 0
    halved_joltage = joltage

    loop do
      halved_joltage = joltage / 2
      multiplier += 2

      break unless halved_joltage.all?(&:even?)
    end

    counter = 0
    joltages_after_pressing_buttons = [halved_joltage]
    loop do
      break if joltages_after_pressing_buttons.any?(&:zero?)

      new_joltages = []
      joltages_after_pressing_buttons.each do |joltage_after_pressing_button|
        machine.buttons.each do |button|
          new_joltages << (joltage_after_pressing_button - button.joltage_vector)
        end
      end
      counter += 1
      joltages_after_pressing_buttons = new_joltages
    end

    counter * multiplier
  end

  def all_joltages_after_reaching_zero_for_position(
    position:,
    starting_joltages_vector:,
    buttons:,
    machine:,
    current_count:,
    current_buttons_to_exclude:
  )
    starting_joltages = [starting_joltages_vector]
    minimum_joltage = starting_joltages_vector[position]

    minimum_joltage.times do
      new_visited_joltages = []

      starting_joltages.each do |starting_joltage|
        buttons.each do |button|
          new_joltage = machine.reverse_press_joltage_button(button, starting_joltage)

          new_visited_joltages << new_joltage
        end
      end
      starting_joltages = new_visited_joltages.uniq
    end

    results = {}
    starting_joltages.each do |joltage|
      results[joltage] = {
        "count" => minimum_joltage + current_count,
        "current_buttons_to_exclude" => current_buttons_to_exclude + buttons,
      }
    end
    results
  end
end
