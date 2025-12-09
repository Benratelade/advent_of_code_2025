# frozen_string_literal: true

require "day_7/solver"
require "pry"

RSpec.describe Solver do
  before do
    File.open("test-file.txt", "w") do |file|
      file << <<~FILE_CONTENT
        .......S.......
        ...............
        .......^.......
        ...............
        ......^.^......
        ...............
        .....^.^.^.....
        ...............
        ....^.^...^....
        ...............
        ...^.^...^.^...
        ...............
        ..^...^.....^..
        ...............
        .^.^.^.^.^...^.
        ...............
      FILE_CONTENT
    end
  end

  after do
    File.delete("test-file.txt")
  end

  describe "initialize" do
    it "assigns a map from the input" do
      solver = Solver.new("test-file.txt")

      expect(solver.map[0, 0]).to eq(".")
      expect(solver.map[7, 0]).to eq("S")
      expect(solver.map[5, 6]).to eq("^")
    end

    it "assigns a starting point for the beam " do
      solver = Solver.new("test-file.txt")

      expect(solver.starting_point).to eq(
        { value: "S", x_coord: 7, y_coord: 0 },
      )
    end
  end

  describe ".solve_part_1" do
    it "returns the expected result for part 1" do
      solver = Solver.new("test-file.txt")

      expect(solver.solve_part_1).to eq(21)
    end
  end

  describe ".solve_part_2" do
    it "returns the expected result for part 2" do
      solver = Solver.new("test-file.txt")

      expect(solver.solve_part_2).to eq(40)
    end
  end
end
