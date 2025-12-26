# frozen_string_literal: true

class Machine
  attr_reader :buttons, :indicator_lights, :target_indicator_lights

  def initialize(
    indicator_lights_string:,
    buttons_string:,
    joltage_requirements_string:
  )
    build_indicator_lights(indicator_lights_string)
    build_buttons(buttons_string)
    @joltage_requirements = joltage_requirements_string
  end

  def indicator_display
    @indicator_lights.join
  end

  def press_button(button_index)
    button = @buttons[button_index]

    button.light_indexes.each do |index|
      light = @indicator_lights[index]
      @indicator_lights[index] = if light == "."
                                   "#"
                                 else
                                   "."
                                 end
    end
  end

  private

  def build_indicator_lights(indicator_lights_string)
    @target_indicator_lights = indicator_lights_string.gsub(/[\[\]]/, "").chars
    @indicator_lights = ("." * @target_indicator_lights.count).chars
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
