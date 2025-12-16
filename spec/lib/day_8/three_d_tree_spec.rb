# frozen_string_literal: true

require "day_8/three_d_tree"

Point = Data.define(:x_coord, :y_coord, :z_coord)

RSpec.describe ThreeDTree do
  describe "initialize" do
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
      expect(tree.root.children.map(&:value)).to eq(
        [
          point_b,
          point_d,
        ],
      )
      expect(tree[point_d].children.map(&:value)).to eq([point_c])
    end
  end

  describe ".find_nearest_neighbour" do
    it "finds the nearest neigbour for a point" do
    end
  end
end
