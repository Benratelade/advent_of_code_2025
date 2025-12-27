# frozen_string_literal: true

require_relative "../../../lib/day_10/machine"

describe Machine do
  describe "initialize" do
    it "instantiates indicator lights, buttons and joltage requirements" do
      machine = Machine.new(
        indicator_lights_string: "[.##.]",
        buttons_string: ["(3)", "(1,3)", "(2)", "(2,3)", "(0,2)", "(0,1)"],
        joltage_requirements_string: "{3,5,4,7}",
      )

      expect(machine.buttons.count).to eq(6)
      expect(machine.buttons[0].light_indexes).to eq([3])
      expect(machine.indicator_lights.length).to eq(4)
      expect(machine.indicator_display).to eq("....")
      expect(machine.target_indicator_lights).to eq([".", "#", "#", "."])
    end
  end

  describe "press button" do
    it "toggles the lights for button's associated indicator lights" do
      machine = Machine.new(
        indicator_lights_string: "[.##.]",
        buttons_string: ["(3)", "(1,3)", "(2)", "(2,3)", "(0,2)", "(0,1)"],
        joltage_requirements_string: "{3,5,4,7}",
      )

      buttons = machine.buttons
      expect(
        machine.press_button(
          buttons[0], [".", ".", ".", "."],
        ),
      ).to eq([".", ".", ".", "#"])

      expect(
        machine.press_button(buttons[0], [".", ".", ".", "#"]),
      ).to eq([".", ".", ".", "."])

      expect(
        machine.press_button(buttons[1], [".", ".", ".", "."]),
      ).to eq([".", "#", ".", "#"])

      expect(
        machine.press_button(buttons[2], [".", "#", ".", "#"]),
      ).to eq([".", "#", "#", "#"])
    end
  end
end
