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

    File.open("test-file-2.txt", "w") do |file|
      file << <<~FILE_CONTENT
        svr: aaa bbb
        aaa: fft
        fft: ccc
        bbb: tty
        tty: ccc
        ccc: ddd eee
        ddd: hub
        hub: fff
        eee: dac
        dac: fff
        fff: ggg hhh
        ggg: out
        hhh: out
      FILE_CONTENT
    end
  end

  after do
    File.delete("test-file.txt")
    File.delete("test-file-2.txt")
  end

  describe ".solve_part_1" do
    it "returns the expected result for part 1" do
      solver = Solver.new("test-file.txt")

      expect(solver.solve_part_1).to eq(5)
    end
  end

  describe ".solve_part_2" do
    it "returns the expected result for part 2" do
      pending "That doesn't work yet"
      solver = Solver.new("test-file-2.txt")

      expect(solver.solve_part_2).to eq(2)
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

    it "instantiates a reverse devices map" do
      solver = Solver.new("test-file-2.txt")

      expect(solver.reverse_devices).to eq(
        {
          "aaa" => %w[svr],
          "bbb" => %w[svr],
          "fft" => %w[aaa],
          "ccc" => %w[fft tty],
          "tty" => %w[bbb],
          "ddd" => %w[ccc],
          "eee" => %w[ccc],
          "hub" => %w[ddd],
          "fff" => %w[hub dac],
          "dac" => %w[eee],
          "ggg" => %w[fff],
          "hhh" => %w[fff],
          "out" => %w[ggg hhh],
        },
      )
    end
  end
end
