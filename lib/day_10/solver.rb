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

  def press_all_joltage_buttons_for_machine(machine)
    count = 0
    results = [machine.starting_joltage]
    cached_results = { machine.starting_joltage => 0 }
    loop do
      count += 1
      new_results = []

      results.each do |result|
        machine.buttons.each do |button|
          temp_result = machine.press_joltage_button(button, result)
          result_overshot_target = false
          temp_result.each_with_index do |light, index|
            result_overshot_target = light > machine.target_joltage[index]
          end

          next if result_overshot_target || cached_results[temp_result]

          cached_results[temp_result] ||= count
          new_results << temp_result
        end
      end

      break if new_results.any? { |new_result| new_result == machine.target_joltage }

      results = new_results.uniq
    end

    count
  end

  def process_joltages_for_machine_counting_down(machine)
    count = 0
    target_joltages = [machine.target_joltage]
    cached_results = { machine.target_joltage => 0 }
    loop do
      puts "Current count: #{count}"
      count += 1
      new_visited_joltages = []

      target_joltages.each do |target_joltage|
        machine.buttons.each do |button|
          temp_result = machine.reverse_press_joltage_button(button, target_joltage)
          result_overshot_start = false
          temp_result.each do |jolt|
            result_overshot_start = jolt.negative?
          end

          next if cached_results[temp_result] || result_overshot_start

          cached_results[temp_result] ||= count
          new_visited_joltages << temp_result
        end
      end

      break if new_visited_joltages.any? { |new_result| new_result == machine.starting_joltage }

      target_joltages = new_visited_joltages.uniq
    end

    count
  end

  def process_joltages_for_machine(machine)
    puts "Machine target: #{machine.target_joltage}"
    all_targets = {
      machine.target_joltage => {
        "count" => 0,
        "current_buttons_to_exclude" => [],
      },
    }
    cached_results = { machine.target_joltage => 0 }

    loop do
      break if all_targets.keys.any?(&:zero?)

      temp_targets = {}
      all_targets.each do |target, data|
        count_candidate = data["count"]
        current_buttons_to_exclude = data["current_buttons_to_exclude"]
        minimum_joltage = target.min(target.size).find { |element| !element.zero? }
        puts "Processing minimum: #{minimum_joltage} for target: #{target}"

        joltage_index = target.to_a.index(minimum_joltage)
        buttons = machine.buttons.select do |button|
          button.joltage_vector[joltage_index] == 1 && !current_buttons_to_exclude.include?(button)
        end

        new_joltages = all_joltages_after_reaching_zero_for_position(
          position: joltage_index,
          starting_joltages_vector: target,
          buttons: buttons,
          machine: machine,
          current_count: count_candidate,
          current_buttons_to_exclude: current_buttons_to_exclude,
        )

        new_joltages.each do |new_joltage, new_data|
          next if cached_results[new_joltage]

          cached_results[new_joltage] ||= true

          unless temp_targets[new_joltage] && temp_targets[new_joltage]["count"] < new_data["count"]
            temp_targets[new_joltage] = new_data
          end
        end
      end
      all_targets = temp_targets
    end

    all_targets.select { |key, _value| key.zero? }.values.first["count"]
  end

  def all_joltages_after_reaching_zero_for_position(position:, starting_joltages_vector:, buttons:, machine:,
                                                    current_count:, current_buttons_to_exclude:)
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
