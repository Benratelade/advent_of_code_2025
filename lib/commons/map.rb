# frozen_string_literal: true

module Commons
  class OutOfBoundsError < StandardError
  end

  class Map # rubocop:disable Metrics/ClassLength
    def initialize(array)
      @map = array
    end

    def raw
      @map
    end

    def value_at(x_coord, y_coord)
      validate_coords!(x_coord, y_coord)

      @map[y_coord][x_coord]
    end

    def [](*coords)
      raise "Too many arguments. Should be of the format map[x, y]" if coords.count > 2

      x_coord, y_coord = *coords

      value_at(x_coord, y_coord)
    end

    def []=(*coords, value)
      raise "Too many arguments. Should be of the format map[x, y] = value" if coords.count > 2

      x_coord, y_coord = *coords

      @map[y_coord][x_coord] = value
    end

    def surrounding_values_for(x_coord, y_coord)
      surrounding_coordinates(x_coord, y_coord).map do |coords|
        { x_coord: coords[0], y_coord: coords[1], value: self[*coords] }
      end
    end

    def left(x_coord, y_coord)
      new_x = x_coord - 1

      { x_coord: new_x, y_coord: y_coord, value: self[new_x, y_coord] }
    rescue OutOfBoundsError
      nil
    end

    def right(x_coord, y_coord)
      new_x = x_coord + 1

      { x_coord: new_x, y_coord: y_coord, value: self[new_x, y_coord] }
    rescue OutOfBoundsError
      nil
    end

    def up(x_coord, y_coord)
      new_y = y_coord - 1

      { x_coord: x_coord, y_coord: new_y, value: self[x_coord, new_y] }
    rescue OutOfBoundsError
      nil
    end

    def down(x_coord, y_coord)
      new_y = y_coord + 1

      { x_coord: x_coord, y_coord: new_y, value: self[x_coord, new_y] }
    rescue OutOfBoundsError
      nil
    end

    def left_and_above_values_for(x_coord, y_coord)
      cells = []

      surrounding_coordinates_without_diagonals(x_coord, y_coord, exclude_out_of_bounds: false).each do |coords|
        next if coords[0] > x_coord
        next if coords[1] > y_coord

        begin
          cells << { x_coord: coords[0], y_coord: coords[1], value: self[*coords] }
        rescue Commons::OutOfBoundsError
          cells << nil
        end
      end

      cells
    end

    def surrounding_coordinates(x_coord, y_coord)
      surrounding_coords = []

      ((y_coord - 1)..(y_coord + 1)).each do |surrounding_y|
        next unless y_within_bounds?(surrounding_y)

        ((x_coord - 1)..(x_coord + 1)).each do |surrounding_x|
          next unless x_within_bounds?(surrounding_x)
          next if surrounding_x == x_coord && surrounding_y == y_coord

          surrounding_coords << [surrounding_x, surrounding_y]
        end
      end

      surrounding_coords
    end

    def surrounding_values_without_diagonals_for(x_coord, y_coord, exclude_out_of_bounds: true)
      if exclude_out_of_bounds
        surrounding_coordinates_without_diagonals(x_coord, y_coord).map do |coords|
          { x_coord: coords[0], y_coord: coords[1], value: self[*coords] }
        end
      else
        surrounding_coordinates_without_diagonals(x_coord, y_coord, exclude_out_of_bounds: false).map do |coords|
          { x_coord: coords[0], y_coord: coords[1], value: self[*coords] }
        rescue OutOfBoundsError
          nil
        end
      end
    end

    def surrounding_coordinates_without_diagonals(x_coord, y_coord, exclude_out_of_bounds: true)
      surrounding_coordinates = []

      if exclude_out_of_bounds
        surrounding_coordinates << [x_coord, y_coord - 1] unless (y_coord - 1).negative?
        surrounding_coordinates << [x_coord - 1, y_coord] unless (x_coord - 1).negative?
        surrounding_coordinates << [x_coord + 1, y_coord] unless (x_coord + 1) > (@map.first.length - 1)
        surrounding_coordinates << [x_coord, y_coord + 1] unless (y_coord + 1) > (@map.length - 1)
      else
        surrounding_coordinates << [x_coord, y_coord - 1]
        surrounding_coordinates << [x_coord - 1, y_coord]
        surrounding_coordinates << [x_coord + 1, y_coord]
        surrounding_coordinates << [x_coord, y_coord + 1]
      end

      surrounding_coordinates
    end

    def each
      (0...@map.length).each do |y_index|
        (0...@map.first.length).each do |x_index|
          yield(@map[y_index][x_index], x_index, y_index)
        end
      end
    end

    def x_within_bounds?(x_coord)
      return false if x_coord.negative?
      return false if x_coord > (@map.first.length - 1)

      true
    end

    def y_within_bounds?(y_coord)
      return false if y_coord.negative?
      return false if y_coord > (@map.length - 1)

      true
    end

    def width
      @map.first.length
    end

    def height
      @map.length
    end

    private

    def validate_coords!(x_coord, y_coord)
      incorrect_coords = []

      incorrect_coords << [:x_axis, x_coord] if x_coord.negative? || x_coord > (@map.first.length - 1)
      incorrect_coords << [:y_axis, y_coord] if y_coord.negative? || y_coord > (@map.length - 1)

      return if incorrect_coords.empty?

      error_messages = incorrect_coords.map do |axis_and_value|
        "#{axis_and_value[1]} is out of bounds for #{axis_and_value[0]}"
      end

      raise(Commons::OutOfBoundsError, error_messages.join(", "))
    end
  end
end
