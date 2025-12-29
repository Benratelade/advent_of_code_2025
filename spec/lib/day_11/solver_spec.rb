# frozen_string_literal: true

require "day_11/solver"
require "pry"

RSpec.describe Solver do
  before do
    File.open("test-file.txt", "w") do |file|
      file << <<~FILE_CONTENT
        aaa: you hhh
        you: bbb ccc
        bbb: ddd eee
        ccc: ddd eee fff
        ddd: ggg
        eee: out
        fff: out
        ggg: out
        hhh: ccc fff iii
        iii: out
      FILE_CONTENT
    end
  end

  after do
    File.delete("test-file.txt")
  end

  describe ".solve_part_1" do
    it "returns the expected result for part 1" do
      solver = Solver.new("test-file.txt")

      expect(solver.solve_part_1).to eq(5)
    end
  end

  describe ".solve_part_2" do
    it "returns the expected result for part 2" do
      solver = Solver.new("test-file.txt")

      expect(solver.solve_part_2).to eq(nil)
    end
  end

  describe "initialize" do
    it "instantiates devices" do
      solver = Solver.new("test-file.txt")

      expect(solver.devices).to eq(
        {
          "aaa" => %w[you hhh],
          "you" => %w[bbb ccc],
          "bbb" => %w[ddd eee],
          "ccc" => %w[ddd eee fff],
          "ddd" => %w[ggg],
          "eee" => %w[out],
          "fff" => %w[out],
          "ggg" => %w[out],
          "hhh" => %w[ccc fff iii],
          "iii" => %w[out],
        },
      )
    end
  end
end
