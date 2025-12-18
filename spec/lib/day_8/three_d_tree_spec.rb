# frozen_string_literal: true

require "day_8/three_d_tree"

Point = Data.define(:x_coord, :y_coord, :z_coord)

RSpec.describe ThreeDTree do
  before do
    @point_a = Point.new(x_coord: 162, y_coord: 817, z_coord: 812)
    @point_b = Point.new(x_coord: 57, y_coord: 618, z_coord: 57)
    @point_c = Point.new(x_coord: 906, y_coord: 360, z_coord: 560)
    @point_d = Point.new(x_coord: 592, y_coord: 479, z_coord: 940)
    @point_e = Point.new(x_coord: 352, y_coord: 342, z_coord: 300)
    @point_f = Point.new(x_coord: 466, y_coord: 668, z_coord: 158)

    @points = [
      @point_a,
      @point_b,
      @point_c,
      @point_d,
      @point_e,
      @point_f,
    ]
  end
  describe ".initialize" do
    it "iterates through points and assigns them on a tree, alternating dimensions" do
      point_a = Point.new(x_coord: 162, y_coord: 817, z_coord: 812)
      point_b = Point.new(x_coord: 57, y_coord: 618, z_coord: 57)
      point_c = Point.new(x_coord: 906, y_coord: 360, z_coord: 560)
      point_d = Point.new(x_coord: 592, y_coord: 479, z_coord: 940)
      point_e = Point.new(x_coord: 352, y_coord: 342, z_coord: 300)
      point_f = Point.new(x_coord: 466, y_coord: 668, z_coord: 158)

      tree = ThreeDTree.new(
        [
          point_a,
          point_b,
          point_c,
          point_d,
          point_e,
          point_f,
        ],
      )

      expect(tree.root.value).to eq(point_f)
      expect(tree.root.axis).to eq(:x_coord)
      expect(tree.root.left_child.value).to eq(point_b)
      expect(tree.root.left_child.axis).to eq(:y_coord)
      expect(tree.root.right_child.value).to eq(point_d)
      expect(tree.root.right_child.axis).to eq(:y_coord)

      expect(tree[point_d].left_child.value).to eq(point_c)
      expect(tree[point_d].left_child.axis).to eq(:z_coord)
    end
  end

  describe "#find_nearest_neighbour_for" do
    it "finds the nearest neigbour for a point" do
      tree = ThreeDTree.new(@points)

      expect(tree.find_nearest_neighbour_for(@point_a)).to eq(@point_d)
      expect(tree.find_nearest_neighbour_for(@point_e)).to eq(@point_f)
    end
  end

  describe ".calculate_distance_between" do
    it "calculates the distance between 2 points" do
      expect(
        ThreeDTree.calculate_distance_between(first_point: @point_a, second_point: @point_b),
      ).to be_within(0.01).of(787.81)
      expect(
        ThreeDTree.calculate_distance_between(first_point: @point_a, second_point: @point_c),
      ).to be_within(0.01).of(908.78)
      expect(
        ThreeDTree.calculate_distance_between(first_point: @point_a, second_point: @point_d),
      ).to be_within(0.01).of(561.71)
      expect(
        ThreeDTree.calculate_distance_between(first_point: @point_a, second_point: @point_e),
      ).to be_within(0.01).of(723.78)
      expect(
        ThreeDTree.calculate_distance_between(first_point: @point_a, second_point: @point_f),
      ).to be_within(0.01).of(736.43)
      expect(
        ThreeDTree.calculate_distance_between(first_point: @point_b, second_point: @point_c),
      ).to be_within(0.01).of(1019.98)
      expect(
        ThreeDTree.calculate_distance_between(first_point: @point_b, second_point: @point_d),
      ).to be_within(0.01).of(1041.74)
      expect(
        ThreeDTree.calculate_distance_between(first_point: @point_b, second_point: @point_e),
      ).to be_within(0.01).of(471.43)
      expect(
        ThreeDTree.calculate_distance_between(first_point: @point_b, second_point: @point_f),
      ).to be_within(0.01).of(424.24)
      expect(
        ThreeDTree.calculate_distance_between(first_point: @point_c, second_point: @point_d),
      ).to be_within(0.01).of(507.10)
      expect(
        ThreeDTree.calculate_distance_between(first_point: @point_c, second_point: @point_e),
      ).to be_within(0.01).of(612.24)
      expect(
        ThreeDTree.calculate_distance_between(first_point: @point_c, second_point: @point_f),
      ).to be_within(0.01).of(670.87)
      expect(
        ThreeDTree.calculate_distance_between(first_point: @point_d, second_point: @point_e),
      ).to be_within(0.01).of(697.11)
      expect(
        ThreeDTree.calculate_distance_between(first_point: @point_d, second_point: @point_f),
      ).to be_within(0.01).of(814.32)
      expect(
        ThreeDTree.calculate_distance_between(first_point: @point_e, second_point: @point_f),
      ).to be_within(0.01).of(373.41)
    end
  end
end
