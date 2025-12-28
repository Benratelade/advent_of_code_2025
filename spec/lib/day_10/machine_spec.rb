# frozen_string_literal: true

require_relative "../../../lib/day_10/machine"
require "matrix"

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
      expect(machine.starting_joltage).to eq(Vector[0, 0, 0, 0])
      expect(machine.target_joltage).to eq(Vector[3, 5, 4, 7])
    end

    it "calculates a reduced_joltage and multiplier for the machine" do
      pending "Reduced joltage may not be that useful after all"
      machine = Machine.new(
        indicator_lights_string: "[..##..]",
        buttons_string: ["(0,5)", "(1,2,3,4,5)", "(1,3,4,5)", "(3,4)", "(2,3,5)", "(0,1,2,5)"],
        joltage_requirements_string: "{29,40,23,42,39,52}",
      )

      expect(machine.starting_joltage).to eq(Vector[0, 0, 0, 0, 0, 0])
      expect(machine.target_joltage).to eq(Vector[29, 40, 23, 42, 39, 52])
      expect(machine.reduced_joltages).to eq(
        {
          Vector[6, 1, 8, 1] => 10,
          Vector[0, 0, 0, 4] => 1,
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
          buttons[0], Vector[0, 0, 0, 0],
        ),
      ).to eq(Vector[0, 0, 0, 1])

      expect(
        machine.press_joltage_button(buttons[0], Vector[0, 0, 0, 1]),
      ).to eq(Vector[0, 0, 0, 2])

      expect(
        machine.press_joltage_button(buttons[1], Vector[0, 0, 0, 2]),
      ).to eq(Vector[0, 1, 0, 3])

      expect(
        machine.press_joltage_button(buttons[2], Vector[0, 1, 0, 3]),
      ).to eq(Vector[0, 1, 1, 3])
    end
  end
end
