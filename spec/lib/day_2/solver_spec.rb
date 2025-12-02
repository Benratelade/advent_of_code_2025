# frozen_string_literal: true

require "day_2/solver"
require "pry"

RSpec.describe Solver do
  before do
    File.open("test-file.txt", "w") do |file|
      file << <<~FILE_CONTENT
        11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124
      FILE_CONTENT
    end
  end

  after do
    File.delete("test-file.txt")
  end

  describe ".solve_part_1" do
    it "returns the expected result for part 1" do
      solver = Solver.new("test-file.txt")

      expect(solver.solve_part_1).to eq(1_227_775_554)
    end
  end

  describe ".solve_part_2" do
    it "returns the expected result for part 2" do
      solver = Solver.new("test-file.txt")

      expect(solver.solve_part_2).to eq(4_174_379_265)
    end
  end

  describe "initialize" do
    it "assigns the ranges" do
      solver = Solver.new("test-file.txt")

      expect(solver.ranges).to eq(
        [
          (11..22),
          (95..115),
          (998..1012),
          (1_188_511_880..1_188_511_890),
          (222_220..222_224),
          (1_698_522..1_698_528),
          (446_443..446_449),
          (38_593_856..38_593_862),
          (565_653..565_659),
          (824_824_821..824_824_827),
          (2_121_212_118..2_121_212_124),
        ],
      )
    end
  end

  describe "get_invalid_ids_from_range" do
    it "extracts the invalid ids from a range" do
      solver = Solver.new("test-file.txt")

      # an invalid id has a repeating first and second half, e.g 11, 6464 etc.
      expect(solver.get_invalid_ids_from_range(11..22)).to eq([11, 22])
      expect(solver.get_invalid_ids_from_range(95..115)).to eq([99])
      expect(solver.get_invalid_ids_from_range(998..1012)).to eq([1010])
    end
  end

  describe "get_invalid_ids_from_range_for_part_2" do
    it "extracts the invalid ids from a range" do
      solver = Solver.new("test-file.txt")

      # an invalid id has a repeating first and second half, e.g 11, 6464 etc.
      expect(solver.get_invalid_ids_from_range_for_part_2(11..22)).to eq([11, 22])
      expect(solver.get_invalid_ids_from_range_for_part_2(95..115)).to eq([99, 111])
      expect(solver.get_invalid_ids_from_range_for_part_2(998..1012)).to eq([999, 1010])
    end
  end
end
