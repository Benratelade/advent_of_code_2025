input = File.readlines("#{__dir__}/input.txt")
            .map { it.scan(/([()\d, ]+) {(.*)}/) }
            .flatten(1)
            .map do |b, j|
  [b.scan(/\((.+?)\)/).flatten.map { it.split(",").map(&:to_i) },
   j.split(",").map(&:to_i),]
end

def parity(jolts)  = jolts.map { it.odd? ? 1 : 0 }
def value(pattern) = pattern.join.to_i(2)

def solve(buttons, jolts)
  $cache = {}

  def togglepattern(buttons, pattern)
    val = value(pattern)
    return $cache[val] if $cache.include?(val)

    res = []
    bitcount = pattern.size
    butcount = buttons.size

    (2**butcount).times do |c|
      z = 0
      but = []
      butcount.times do |i|
        next unless c & (1 << i) != 0

        but << buttons[i]
        buttons[i].each do |b|
          z ^= (1 << (bitcount - b - 1))
        end
      end
      next unless z == val

      delta = 0.upto(bitcount - 1).map { but.flatten.count(it) }
      res << [but.size, delta]
    end
    $cache[val] = res
  end

  def solve2(buttons, jolts)
    return 0 if jolts.all?(0)

    res = togglepattern(buttons, parity(jolts))
          .map { |count, delta| [count, jolts.zip(delta).map { |x, y| (x - y) / 2 }] }
          .reject { |_, delta| delta.any?(&:negative?) }
          .map { |count, newjolts| count + (2 * solve2(buttons, newjolts)) }

    res.min || Float::INFINITY
  end
  solve2(buttons, jolts)
end

puts(input.sum { solve(*it) })
