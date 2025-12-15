# frozen_string_literal: true

class JunctionBox
  attr_reader :x_coord, :y_coord, :z_coord

  def initialize(x_coord:, y_coord:, z_coord:)
    @x_coord = x_coord
    @y_coord = y_coord
    @z_coord = z_coord
  end
end
