# frozen_string_literal: true

require "day_6/solver"
require "pry"

RSpec.describe Solver do
  before do
    File.open("test-file.txt", "w") do |file|
      file << <<~FILE_CONTENT
        123 328  51 64
        45 64  387 23
        6 98  215 314
        *   +   *   +
      FILE_CONTENT
    end
  end

  after do
    File.delete("test-file.txt")
  end

  describe ".solve_part_1" do
    it "returns the expected result for part 1" do
      solver = Solver.new("test-file.txt")

      expect(solver.solve_part_1).to eq(4_277_556)
    end
  end

  describe ".solve_part_2" do
    it "returns the expected result for part 2" do
      solver = Solver.new("test-file.txt")

      expect(solver.solve_part_2).to eq(nil)
    end
  end

  describe "initialize" do
    it "assigns operations" do
      solver = Solver.new("test-file.txt")

      expect(solver.operations[0].operand).to eq("*")
      expect(solver.operations[0].inputs).to eq([123, 45, 6])
      expect(solver.operations[0].result).to eq(33_210)

      expect(solver.operations[1].operand).to eq("+")
      expect(solver.operations[1].inputs).to eq([328, 64, 98])
      expect(solver.operations[1].result).to eq(490)
    end
  end
end
