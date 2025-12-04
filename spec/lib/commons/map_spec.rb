# frozen_string_literal: true

require "commons/map"

RSpec.describe Commons::Map do
  describe "initialize" do
    it "allows creating a map from an array" do
      map = Commons::Map.new(
        [
          %w[a b c d],
          %w[e f g h],
        ],
      )

      expect(map.raw).to eq(
        [
          %w[a b c d],
          %w[e f g h],
        ],
      )
    end
  end

  describe "accessors" do
    it "allows querying by column and row, starting with row (x axis)" do
      map = Commons::Map.new(
        [
          %w[a b c d],
          %w[e f g h],
        ],
      )

      expect(map.value_at(0, 1)).to eq("e")
      expect(map.value_at(3, 0)).to eq("d")
      expect(map[0, 1]).to eq("e")
    end

    it "throws an error when asking for a item outside bounds" do
      map = Commons::Map.new(
        [
          %w[a b c d],
          %w[e f g h],
        ],
      )

      expect do
        map.value_at(-1, 0)
      end.to raise_error(Commons::OutOfBoundsError, "-1 is out of bounds for x_axis")

      expect do
        map.value_at(0, -1)
      end.to raise_error(Commons::OutOfBoundsError, "-1 is out of bounds for y_axis")

      expect do
        map.value_at(4, 0)
      end.to raise_error(Commons::OutOfBoundsError, "4 is out of bounds for x_axis")

      expect do
        map.value_at(0, 3)
      end.to raise_error(Commons::OutOfBoundsError, "3 is out of bounds for y_axis")

      expect do
        map.value_at(4, 3)
      end.to raise_error(Commons::OutOfBoundsError, "4 is out of bounds for x_axis, 3 is out of bounds for y_axis")
    end
  end

  describe "setters" do
    it "allows setting by column and row, starting with row (x axis)" do
      map = Commons::Map.new(
        [
          %w[a b c d],
          %w[e f g h],
        ],
      )

      expect(map.value_at(0, 1)).to eq("e")

      map[0, 1] = "k"

      expect(map.value_at(0, 1)).to eq("k")
    end
  end

  describe "each" do
    it "iterates over each item in the map, row by row" do
      map = Commons::Map.new(
        [
          %w[a b c d],
          %w[e f g h],
        ],
      )

      result = []
      map.each do |value, x_coord, y_coord| # rubocop:disable Style/MapIntoArray
        result << { value: value, x_coord: x_coord, y_coord: y_coord }
      end

      expect(result).to eq(
        [
          { value: "a", x_coord: 0, y_coord: 0 },
          { value: "b", x_coord: 1, y_coord: 0 },
          { value: "c", x_coord: 2, y_coord: 0 },
          { value: "d", x_coord: 3, y_coord: 0 },
          { value: "e", x_coord: 0, y_coord: 1 },
          { value: "f", x_coord: 1, y_coord: 1 },
          { value: "g", x_coord: 2, y_coord: 1 },
          { value: "h", x_coord: 3, y_coord: 1 },
        ],
      )
    end
  end

  describe "directional accessors" do
    before do
      @map = Commons::Map.new(
        [
          %w[a b c d],
          %w[e f g e],
          %w[h i j k],
        ],
      )
    end

    it "has an accessor for left node" do
      expect(@map.left(0, 0)).to eq(nil)
      expect(@map.left(1, 1)).to eq({ x_coord: 0, y_coord: 1, value: "e" })
    end

    it "has an accessor for right node" do
      expect(@map.right(1, 1)).to eq({ x_coord: 2, y_coord: 1, value: "g" })
      expect(@map.right(3, 1)).to eq(nil)
    end

    it "has an accessor for up node" do
      expect(@map.up(0, 0)).to eq(nil)
      expect(@map.up(1, 1)).to eq({ x_coord: 1, y_coord: 0, value: "b" })
    end

    it "has an accessor for down node" do
      expect(@map.down(1, 1)).to eq({ x_coord: 1, y_coord: 2, value: "i" })
      expect(@map.down(0, 2)).to eq(nil)
    end
  end

  describe ".surrounding_values_for" do
    it "provides all the surrounding values for a point" do
      map = Commons::Map.new(
        [
          %w[a b c d],
          %w[e f g e],
          %w[h i j k],
        ],
      )

      expect(map.surrounding_values_for(0, 0)).to eq(
        [
          { x_coord: 1, y_coord: 0, value: "b" },
          { x_coord: 0, y_coord: 1, value: "e" },
          { x_coord: 1, y_coord: 1, value: "f" },
        ],
      )

      expect(map.surrounding_values_for(2, 1)).to eq(
        [
          { x_coord: 1, y_coord: 0, value: "b" },
          { x_coord: 2, y_coord: 0, value: "c" },
          { x_coord: 3, y_coord: 0, value: "d" },
          { x_coord: 1, y_coord: 1, value: "f" },
          { x_coord: 3, y_coord: 1, value: "e" },
          { x_coord: 1, y_coord: 2, value: "i" },
          { x_coord: 2, y_coord: 2, value: "j" },
          { x_coord: 3, y_coord: 2, value: "k" },
        ],
      )
    end
  end

  describe "#surrounding_values_without_diagonals_for" do
    it "provides all the surrounding values for a point, without diagonal values" do
      map = Commons::Map.new(
        [
          %w[a b c d],
          %w[e f g e],
          %w[h i j k],
        ],
      )

      expect(map.surrounding_values_without_diagonals_for(0, 0)).to eq(
        [
          { x_coord: 1, y_coord: 0, value: "b" },
          { x_coord: 0, y_coord: 1, value: "e" },
        ],
      )

      expect(map.surrounding_values_without_diagonals_for(2, 1)).to eq(
        [
          { x_coord: 2, y_coord: 0, value: "c" },
          { x_coord: 1, y_coord: 1, value: "f" },
          { x_coord: 3, y_coord: 1, value: "e" },
          { x_coord: 2, y_coord: 2, value: "j" },
        ],
      )
    end

    context "when exclude_out_of_bounds is false" do
      it "returns nil for out of bounds coordinates" do
        map = Commons::Map.new(
          [
            %w[a b c d],
            %w[e f g e],
            %w[h i j k],
          ],
        )

        expect(map.surrounding_values_without_diagonals_for(0, 0, exclude_out_of_bounds: false)).to eq(
          [
            nil,
            nil,
            { x_coord: 1, y_coord: 0, value: "b" },
            { x_coord: 0, y_coord: 1, value: "e" },
          ],
        )

        expect(map.surrounding_values_without_diagonals_for(2, 1, exclude_out_of_bounds: false)).to eq(
          [
            { x_coord: 2, y_coord: 0, value: "c" },
            { x_coord: 1, y_coord: 1, value: "f" },
            { x_coord: 3, y_coord: 1, value: "e" },
            { x_coord: 2, y_coord: 2, value: "j" },
          ],
        )
      end
    end
  end

  describe "#left_and_above_values_for" do
    it "provides the left and above values for the given position" do
      map = Commons::Map.new(
        [
          %w[a b c d],
          %w[e f g e],
          %w[h i j k],
        ],
      )

      expect(map.left_and_above_values_for(0, 0)).to eq(
        [
          nil,
          nil,
        ],
      )

      expect(map.left_and_above_values_for(2, 1)).to eq(
        [
          { x_coord: 2, y_coord: 0, value: "c" },
          { x_coord: 1, y_coord: 1, value: "f" },
        ],
      )
    end
  end
end
