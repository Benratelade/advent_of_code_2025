# frozen_string_literal: true

require_relative "circuit"
class JunctionBox
  attr_reader :x_coord, :y_coord, :z_coord
  attr_accessor :circuit

  def initialize(x_coord:, y_coord:, z_coord:)
    @x_coord = x_coord
    @y_coord = y_coord
    @z_coord = z_coord
    @circuit = Circuit.new
  end

  def to_s
    [@x_coord, @y_coord, @z_coord].join(", ")
  end
end
