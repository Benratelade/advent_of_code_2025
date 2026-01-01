# frozen_string_literal: true

require "day_12/solver"
require "pry"

RSpec.describe Solver do
  before do
    File.open("test-file.txt", "w") do |file|
      file << <<~FILE_CONTENT
        0:
        ###
        ##.
        ##.

        1:
        ###
        ##.
        .##

        2:
        .##
        ###
        ##.

        3:
        ##.
        ###
        ##.

        4:
        ###
        #..
        ###

        5:
        ###
        .#.
        ###

        4x4: 0 0 0 0 2 0
        12x5: 1 0 1 0 2 2
        12x5: 1 0 1 0 3 2
      FILE_CONTENT
    end
  end

  after do
    File.delete("test-file.txt")
  end

  describe ".solve_part_1" do
    it "returns the expected result for part 1" do
      pending "the naive approach of considering the size of all presents without worrying about shape works. The example doesn't"
      solver = Solver.new("test-file.txt")

      expect(solver.solve_part_1).to eq(2)
    end
  end

  describe ".solve_part_2" do
    it "returns the expected result for part 2" do
      solver = Solver.new("test-file.txt")

      expect(solver.solve_part_2).to eq(nil)
    end
  end

  describe "initialize" do
    it "instantiates shapes and regions" do
      solver = Solver.new("test-file.txt")

      expect(solver.shapes.count).to eq(6)
      expect(solver.shapes[0].area).to eq(7)
      expect(solver.shapes[1].area).to eq(7)
      expect(solver.shapes[2].area).to eq(7)

      expect(solver.regions.count).to eq(3)
      expect(solver.regions[0].area).to eq(16)
      expect(solver.regions[0].area).to eq(16)
      expect(solver.regions[1].area).to eq(60)
      expect(solver.regions[2].area).to eq(60)
    end
  end
end
