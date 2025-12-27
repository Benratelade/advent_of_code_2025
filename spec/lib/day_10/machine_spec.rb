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
      expect(machine.target_indicator_lights).to eq([".", "#", "#", "."])
      expect(machine.starting_joltage).to eq([0, 0, 0, 0])
      expect(machine.target_joltage).to eq([3, 5, 4, 7])
    end

    it "calculates a reduced_joltage and multiplier for the machine" do
      machine = Machine.new(
        indicator_lights_string: "[.##.]",
        buttons_string: ["(3)", "(1,3)", "(2)", "(2,3)", "(0,2)", "(0,1)"],
        joltage_requirements_string: "{60,10,80,14}",
      )

      expect(machine.starting_joltage).to eq([0, 0, 0, 0])
      expect(machine.target_joltage).to eq([60, 10, 80, 14])
      expect(machine.reduced_joltages).to eq(
        {
          [6, 1, 8, 1] => 10,
          [0, 0, 0, 4] => 1,
        },
      )
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

  describe "press_joltage_button" do
    it "increments the joltage for button's associated indicator lights" do
      machine = Machine.new(
        indicator_lights_string: "[.##.]",
        buttons_string: ["(3)", "(1,3)", "(2)", "(2,3)", "(0,2)", "(0,1)"],
        joltage_requirements_string: "{3,5,4,7}",
      )

      buttons = machine.buttons
      expect(
        machine.press_joltage_button(
          buttons[0], [0, 0, 0, 0],
        ),
      ).to eq([0, 0, 0, 1])

      expect(
        machine.press_joltage_button(buttons[0], [0, 0, 0, 1]),
      ).to eq([0, 0, 0, 2])

      expect(
        machine.press_joltage_button(buttons[1], [0, 0, 0, 2]),
      ).to eq([0, 1, 0, 3])

      expect(
        machine.press_joltage_button(buttons[2], [0, 1, 0, 3]),
      ).to eq([0, 1, 1, 3])
    end
  end
end
