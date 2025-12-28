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
    threads = []
    slice_size = @machines.count / 3
    @machines.each_slice(slice_size).to_a.each_with_index do |slice, slice_index|
      threads << Thread.new do
        slice.each_with_index do |machine, index|
          puts "processing joltage for machine number #{index + (slice_index * slice_size)}"
          minimum_counts << process_joltages_for_machine(machine)
          puts "processed #{minimum_counts.count} machines, minimum count: #{minimum_counts}"
        end
      end
    end

    threads.each(&:join)
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
    puts "Machine slice: #{machine.reduced_joltages}"
    all_candidates = []
    machine.reduced_joltages.each do |tuple|
      count = 0
      temporary_results = []
      cached_results = {}
      tuple.each do |target_joltage, factor|
        puts "Processing reduced_joltage: #{target_joltage} for final joltage: #{machine.target_joltage}"
        next if target_joltage.zero?

        results = [target_joltage]
        cached_results[target_joltage] = 0
        loop do
          # binding.irb if count > 10
          count += 1
          new_results = []

          results.each do |result|
            machine.buttons.each do |button|
              temp_result = machine.reverse_press_joltage_button(button, result)
              result_overshot_start = false
              temp_result.each do |jolt|
                result_overshot_start = jolt.negative? if jolt.negative?
              end

              next if result_overshot_start || cached_results[temp_result]

              cached_results[temp_result] ||= count
              new_results << temp_result
            end
          end

          break if new_results.empty?
          break if new_results.any?(&:zero?)

          results = new_results.uniq
        end

        temporary_results << (count * factor)
      end

      all_candidates << (temporary_results.sum + 1)
    end

    all_candidates.min
  end
end
