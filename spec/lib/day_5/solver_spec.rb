# frozen_string_literal: true

require "day_5/solver"
require "pry"

RSpec.describe Solver do
  before do
    File.open("test-file.txt", "w") do |file|
      file << <<~FILE_CONTENT
        3-5
        10-14
        16-20
        12-18

        1
        5
        8
        11
        17
        32
      FILE_CONTENT
    end
  end

  after do
    File.delete("test-file.txt")
  end

  describe "initialize" do
    it "assigns a list of ingredient IDs" do
      solver = Solver.new("test-file.txt")

      expect(solver.ingredient_ids).to eq(
        [1, 5, 8, 11, 17, 32],
      )
    end

    it "assigns a list of ranges" do
      solver = Solver.new("test-file.txt")

      expect(solver.ranges).to eq(
        [
          (3..5),
          (10..14),
          (16..20),
          (12..18),
        ],
      )
    end
  end

  describe ".solve_part_1" do
    it "returns the expected result for part 1" do
      solver = Solver.new("test-file.txt")

      expect(solver.solve_part_1).to eq(3)
    end
  end

  describe ".solve_part_2" do
    it "returns the expected result for part 2" do
      solver = Solver.new("test-file.txt")

      expect(solver.solve_part_2).to eq(14)
    end
  end

  describe ".combine_ranges" do
    it "combines_ranges if range_2 is included in range_1 intersect" do
      range_1 = (3..5)
      range_2 = (4..5)

      expect(Solver.combine_ranges(range_1, range_2)).to eq(3..5)
    end

    it "combines_ranges if range_1 and range_2 intersect from the start" do
      range_1 = (3..5)
      range_2 = (1..3)

      expect(Solver.combine_ranges(range_1, range_2)).to eq(1..5)
    end

    it "combines_ranges if range_1 and range_2 intersect from the end" do
      range_1 = (3..5)
      range_2 = (5..7)

      expect(Solver.combine_ranges(range_1, range_2)).to eq(3..7)
    end

    it "does not combine ranges if they do not intersect" do
      range_1 = (3..5)
      range_2 = (6..7)

      expect(Solver.combine_ranges(range_1, range_2)).to eq(false)
    end
  end
end
