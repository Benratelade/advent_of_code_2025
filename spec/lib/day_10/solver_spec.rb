# frozen_string_literal: true

require "day_10/solver"
require "pry"

RSpec.describe Solver do
  before do
    File.open("test-file.txt", "w") do |file|
      file << ""
    end
  end

  after do
    File.delete("test-file.txt")
  end
end
