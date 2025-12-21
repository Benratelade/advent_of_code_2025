# frozen_string_literal: true

require "day_10/solver"
require "pry"

RSpec.describe Solver do
  before do
    File.open("test-file.txt", "w") do |file|
      file << <<~FILE_CONTENT
        [.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}
        [...#.] (0,2,3,4) (2,3) (0,4) (0,1,2) (1,2,3,4) {7,5,12,7,2}
        [.###.#] (0,1,2,3,4) (0,3,4) (0,1,2,4,5) (1,2) {10,11,11,5,10,5}
      FILE_CONTENT
    end
  end

  after do
    File.delete("test-file.txt")
  end

  describe ".solve_part_1" do
    it "returns the expected result for part 1" do
      solver = Solver.new("test-file.txt")

      expect(solver.solve_part_1).to eq(7)
    end
  end

  describe ".solve_part_2" do
    it "returns the expected result for part 2" do
      solver = Solver.new("test-file.txt")

      expect(solver.solve_part_2).to eq(nil)
    end
  end

  describe "initialize" do
    it "instantiates a machine with buttons for each line" do
      expect(Machine).to receive(:new).with(
        indicator_lights: "[.##.]",
        buttons: [
          "(3)", "(1,3)", "(2)", "(2,3)", "(0,2)", "(0,1)",
        ],
        joltage_requirements: "{3,5,4,7}",
      )
      expect(Machine).to receive(:new).with(
        indicator_lights: "[...#.]",
        buttons: [
          "(0,2,3,4)", "(2,3)", "(0,4)", "(0,1,2)", "(1,2,3,4)",
        ],
        joltage_requirements: "{7,5,12,7,2}",
      )
      expect(Machine).to receive(:new).with(
        indicator_lights: "[.###.#]",
        buttons: [
          "(0,1,2,3,4)", "(0,3,4)", "(0,1,2,4,5)", "(1,2)",
        ],
        joltage_requirements: "{10,11,11,5,10,5}",
      )

      Solver.new("test-file.txt")
    end
  end
end
