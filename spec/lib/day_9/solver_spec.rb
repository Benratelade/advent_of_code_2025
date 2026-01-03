# frozen_string_literal: true

require "day_9/solver"
require "pry"

RSpec.describe Solver do
  before do
    File.open("test-file.txt", "w") do |file|
      file << <<~FILE_CONTENT
        7,1
        11,1
        11,7
        9,7
        9,5
        2,5
        2,3
        7,3
      FILE_CONTENT
    end
  end

  after do
    File.delete("test-file.txt")
  end

  describe ".solve_part_1" do
    it "returns the expected result for part 1" do
      solver = Solver.new("test-file.txt")

      expect(solver.solve_part_1).to eq(50)
    end
  end

  describe ".solve_part_2" do
    it "returns the expected result for part 2" do
      solver = Solver.new("test-file.txt")

      expect(solver.solve_part_2).to eq(24)
    end
  end

  describe "initialize" do
    it "creates a polygon using the points" do
      solver = Solver.new("test-file.txt")

      expect(solver.polygon.sides.count).to eq(8)
    end
  end

  describe ".point_is_in_polygon?" do
    # ".#0#"
    # "##.0"
    # "#0#0"
    # "..##"
    it "returns true for a point INSIDE the polygon" do
      solver = Solver.new("test-file.txt")
      point_inside = Point.new(x_coord: 2, y_coord: 1)
      point_on_side = Point.new(x_coord: 3, y_coord: 1)

      expect(solver.point_is_in_polygon?(point_inside)).to be(true)
      expect(solver.point_is_in_polygon?(point_on_side)).to be(true)
    end

    it "returns false for a point OUTSIDE the polygon" do
      solver = Solver.new("test-file.txt")
      point = Point.new(x_coord: 0, y_coord: 0)

      expect(solver.point_is_in_polygon?(point)).to be(false)
    end
  end
end
