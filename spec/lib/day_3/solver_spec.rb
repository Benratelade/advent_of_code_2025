# frozen_string_literal: true

require "day_3/solver"
require "pry"

RSpec.describe Solver do
  before do
    File.open("test-file.txt", "w") do |file|
      file << <<~FILE_CONTENT
        987654321111111
        811111111111119
        234234234234278
        818181911112111
      FILE_CONTENT
    end
  end

  after do
    File.delete("test-file.txt")
  end

  describe ".solve_part_1" do
    it "returns the expected result for part 1" do
      solver = Solver.new("test-file.txt")

      expect(solver.solve_part_1).to eq(357)
    end
  end

  describe ".solve_part_2" do
    it "returns the expected result for part 2" do
      solver = Solver.new("test-file.txt")

      expect(solver.solve_part_2).to eq(3_121_910_778_619)
    end
  end

  describe "initialize" do
    it "assigns a list of battery_banks" do
      solver = Solver.new("test-file.txt")

      expect(solver.battery_banks).to eq(
        [
          [9, 8, 7, 6, 5, 4, 3, 2, 1, 1, 1, 1, 1, 1, 1],
          [8, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 9],
          [2, 3, 4, 2, 3, 4, 2, 3, 4, 2, 3, 4, 2, 7, 8],
          [8, 1, 8, 1, 8, 1, 9, 1, 1, 1, 1, 2, 1, 1, 1],
        ],
      )
    end
  end

  describe "extract_joltage_from_battery_bank" do
    it "extracts the joltage from a battery bank" do
      solver = Solver.new("test-file.txt")

      expect(solver.extract_joltage_from_battery_bank([9, 8, 7, 6, 5, 4, 3, 2, 1, 1, 1, 1, 1, 1, 1])).to eq(98)
      expect(solver.extract_joltage_from_battery_bank([8, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 9])).to eq(89)
      expect(solver.extract_joltage_from_battery_bank([2, 3, 4, 2, 3, 4, 2, 3, 4, 2, 3, 4, 2, 7, 8])).to eq(78)
      expect(solver.extract_joltage_from_battery_bank([8, 1, 8, 1, 8, 1, 9, 1, 1, 1, 1, 2, 1, 1, 1])).to eq(92)
    end
  end

  describe "extract_joltage_from_battery_bank_for_part_2" do
    it "extracts the joltage from a battery bank" do
      solver = Solver.new("test-file.txt")

      expect(
        solver.extract_joltage_from_battery_bank_for_part_2(
          [9, 8, 7, 6, 5, 4, 3, 2, 1, 1, 1, 1, 1, 1, 1],
        ),
      ).to eq(987_654_321_111)
      expect(
        solver.extract_joltage_from_battery_bank_for_part_2(
          [8, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 9],
        ),
      ).to eq(811_111_111_119)
      expect(
        solver.extract_joltage_from_battery_bank_for_part_2(
          [2, 3, 4, 2, 3, 4, 2, 3, 4, 2, 3, 4, 2, 7, 8],
        ),
      ).to eq(434_234_234_278)
      expect(
        solver.extract_joltage_from_battery_bank_for_part_2(
          [8, 1, 8, 1, 8, 1, 9, 1, 1, 1, 1, 2, 1, 1, 1],
        ),
      ).to eq(888_911_112_111)
    end

    context "some real examples" do
      it "does what we expect for the first line from the problem" do
        solver = Solver.new("test-file.txt")

        expect(
          solver.extract_joltage_from_battery_bank_for_part_2(
            "2241213221432712242323222122544232352344223223231433322416731152222121222425315232122422623633244223".chars,
          ),
        ).to eq(
          776_633_244_223,
        )
      end
    end
  end
end
