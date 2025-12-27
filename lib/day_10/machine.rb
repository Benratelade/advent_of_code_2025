# frozen_string_literal: true

class Machine
  attr_reader :buttons, :starting_indicator_lights, :target_indicator_lights

  def initialize(
    indicator_lights_string:,
    buttons_string:,
    joltage_requirements_string:
  )
    build_indicator_lights(indicator_lights_string)
    build_buttons(buttons_string)
    @joltage_requirements = joltage_requirements_string
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

  private

  def build_indicator_lights(indicator_lights_string)
    @target_indicator_lights = indicator_lights_string.gsub(/[\[\]]/, "").chars
    @starting_indicator_lights = ("." * @target_indicator_lights.count).chars
  end

  def build_buttons(buttons_strings)
    @buttons = buttons_strings.map { |string| Button.new(string) }
  end

  class Button
    attr_reader :light_indexes

    def initialize(string)
      @light_indexes = string.to_enum(:scan, /([\d]+)/).map { Regexp.last_match[1].to_i }
    end
  end

  class IndicatorLight; end
end
