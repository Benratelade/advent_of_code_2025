# frozen_string_literal: true

require "day_8/solver"
require "pry"

RSpec.describe Solver do
  before do
    File.open("test-file.txt", "w") do |file|
      file << <<~FILE_CONTENT
        162,817,812
        57,618,57
        906,360,560
        592,479,940
        352,342,300
        466,668,158
        542,29,236
        431,825,988
        739,650,466
        52,470,668
        216,146,977
        819,987,18
        117,168,530
        805,96,715
        346,949,466
        970,615,88
        941,993,340
        862,61,35
        984,92,344
        425,690,689
      FILE_CONTENT
    end

    allow(ThreeDTree).to receive(:new)
  end

  after do
    File.delete("test-file.txt")
  end

  describe "intialize" do
    it "assigns a bunch of junction boxes and builds a 3D tree" do
      [
        { x_coord: 162, y_coord: 817, z_coord: 812 },
        { x_coord: 57, y_coord: 618, z_coord: 57 },
        { x_coord: 906, y_coord: 360, z_coord: 560 },
        { x_coord: 592, y_coord: 479, z_coord: 940 },
        { x_coord: 352, y_coord: 342, z_coord: 300 },
        { x_coord: 466, y_coord: 668, z_coord: 158 },
        { x_coord: 542, y_coord: 29, z_coord: 236 },
        { x_coord: 431, y_coord: 825, z_coord: 988 },
        { x_coord: 739, y_coord: 650, z_coord: 466 },
        { x_coord: 52, y_coord: 470, z_coord: 668 },
        { x_coord: 216, y_coord: 146, z_coord: 977 },
        { x_coord: 819, y_coord: 987, z_coord: 18 },
        { x_coord: 117, y_coord: 168, z_coord: 530 },
        { x_coord: 805, y_coord: 96, z_coord: 715 },
        { x_coord: 346, y_coord: 949, z_coord: 466 },
        { x_coord: 970, y_coord: 615, z_coord: 88 },
        { x_coord: 941, y_coord: 993, z_coord: 340 },
        { x_coord: 862, y_coord: 61, z_coord: 35 },
        { x_coord: 984, y_coord: 92, z_coord: 344 },
        { x_coord: 425, y_coord: 690, z_coord: 689 },
      ].each do |coords|
        expect(JunctionBox).to receive(:new).with(**coords).and_return(double("a junction box"))
      end

      solver = Solver.new("test-file.txt")

      expect(solver.junction_boxes.count).to eq(20)
      expect(ThreeDTree).to have_received(:new).with(solver.junction_boxes)
    end
  end

  describe ".solve_part_1" do
    it "returns the expected result for part 1" do
      solver = Solver.new("test-file.txt")

      expect(solver.solve_part_1).to eq(40)
    end
  end

  describe ".solve_part_2" do
    it "returns the expected result for part 2" do
      solver = Solver.new("test-file.txt")

      expect(solver.solve_part_2).to eq(nil)
    end
  end
end
