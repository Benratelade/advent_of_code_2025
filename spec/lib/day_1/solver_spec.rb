# frozen_string_literal: true

require "day_1/solver"
require "pry"

RSpec.describe Solver do
  before do
    File.open("test-file.txt", "w") do |file|
      file << <<~FILE_CONTENT
        L68
        L30
        R48
        L5
        R60
        L55
        L1
        L99
        R14
        L82
      FILE_CONTENT
    end
  end

  after do
    File.delete("test-file.txt")
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

      expect(solver.solve_part_2).to eq(6)
    end
  end

  describe "initialize" do
    it "creates a solver where the dial starts at 50" do
      solver = Solver.new("test-file.txt")

      expect(solver.dial_position).to eq(50)
    end
  end

  describe "extract instructions" do
    it "extracts the instructions from a string" do
      expect(Solver.extract_instructions("L68")).to eq(direction: :left, amount: 68)
    end
  end

  describe ".rotate" do
    it "rotates the dial by as many digits to the left or right" do
      solver = Solver.new("test-file.txt")

      solver.rotate(direction: :left, amount: 68)
      expect(solver.dial_position).to eq(82)

      solver.rotate(direction: :left, amount: 30)
      expect(solver.dial_position).to eq(52)

      solver.rotate(direction: :right, amount: 48)
      expect(solver.dial_position).to eq(0)
    end
  end
end
