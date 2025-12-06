#!/usr/bin/env ruby
# frozen_string_literal: true

require "./lib/day_6/solver"
require "pry"

part_1 = Solver.new("./lib/day_6/input.txt").solve_part_1
puts "solution part 1: #{part_1}"

part_2 = Solver.new("./lib/day_6/input.txt").solve_part_2
puts "solution part 2: #{part_2}"
