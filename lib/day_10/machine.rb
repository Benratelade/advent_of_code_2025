# frozen_string_literal: true

require "matrix"

class Machine
  attr_reader :buttons,
              :starting_indicator_lights,
              :target_indicator_lights,
              :target_joltage,
              :starting_joltage,
              :reduced_joltages,
              :length

  def initialize(
    indicator_lights_string:,
    buttons_string:,
    joltage_requirements_string:
  )
    build_indicator_lights(indicator_lights_string)
    build_buttons(buttons_string)
    build_joltage(joltage_requirements_string)
  end

  def press_button(button, indicators_state)
    new_state = indicators_state.dup
    button.light_indexes.each do |index|
      light = indicators_state[index]
      new_state[index] = if light == "."
                           "#"
                         else
                           "."
                         end
    end
    new_state
  end

  def press_joltage_button(button, joltage)
    joltage + button.joltage_vector
  end

  private

  def build_indicator_lights(indicator_lights_string)
    @target_indicator_lights = indicator_lights_string.gsub(/[\[\]]/, "").chars
    @starting_indicator_lights = ("." * @target_indicator_lights.count).chars
    @length = @starting_indicator_lights.length
  end

  def build_buttons(buttons_strings)
    @buttons = buttons_strings.map { |string| Button.new(self, string) }
  end

  def build_joltage(joltage_requirements_string)
    @target_joltage = Vector.elements(joltage_requirements_string.to_enum(:scan, /([\d]+)/).map do
      Regexp.last_match[1].to_i
    end)
    @starting_joltage = Vector.zero(@target_joltage.count)
  end

  class Button
    attr_reader :light_indexes, :joltage_vector

    def initialize(machine, string)
      @machine = machine
      @light_indexes = string.to_enum(:scan, /([\d]+)/).map { Regexp.last_match[1].to_i }
      @joltage_vector = Vector.zero(@machine.length)

      @light_indexes.each do |index|
        @joltage_vector[index] = 1
      end
    end
  end

  class IndicatorLight; end
end
