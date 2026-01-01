# frozen_string_literal: true

class Solver
  attr_reader :shapes, :regions

  def initialize(file)
    @file = file
    @shapes = []
    @regions = []

    process_presents_and_regions
  end

  def solve_part_1
    @regions.filter do |region|
      region.total_necessary_space <= region.area
    end.count
  end

  def solve_part_2; end

  private

  def process_presents_and_regions
    current_shape_description = []
    File.readlines(@file).each do |line|
      if line.strip.empty?
        @shapes << Shape.new(shape_description: current_shape_description)
        current_shape_description = []
        next
      end

      if line.match?(/\d+x\d+/)
        process_region(line)
        next
      elsif line.match?(/\d:/)
        next
      end

      current_shape_description << line.strip
    end
  end

  def process_region(line)
    @regions << Region.new(line, shapes: @shapes)
  end

  class Shape
    attr_reader :area

    def initialize(shape_description:)
      @shape_description = shape_description
      @area = @shape_description.join("\n").count("#")
    end
  end

  class Region
    attr_reader :area, :presents_list

    def initialize(region_description, shapes:)
      size, presents_counts = region_description.split(": ")

      @area = size.split("x").map(&:to_i).reduce(:*)
      @presents_list = {}
      presents_counts.split.each_with_index do |count, index|
        @presents_list[shapes[index]] = count.to_i
      end
    end

    def total_necessary_space
      @presents_list.sum do |shape, count|
        shape.area * count
      end
    end
  end
end
