class Funkcja
  @proc

  def initialize procedure
    @proc = procedure
  end

  def value(x)
    @proc.call (x)
  end

  def zerowe (a, b, e)
    res = []
    while a < b
      temp = a + e
      if @proc.call(a) * @proc.call(temp) < 0
        res << ((a + temp) / 2)
      end
      a = temp
    end
    res
  end

  def pole (a, b)
    integral = 0
    e = (b - a) * 0.0001
    while a < b
      integral += 0.5 * e * (@proc.call(a) + @proc.call(a + e))
      a += e
    end
    integral
  end

  def pochodna (x)
    e = 0.0000001
    (@proc.call(x + e) - @proc.call(x - e)) / (2 * e)
  end
end

test = Funkcja.new(Proc.new {|x| Math.sin(x)})
puts 'f(3.5) = ' + test.value(3.5).to_s
puts
puts 'miejsca zerowe: '
puts test.zerowe(-2.0, 5.0, 0.001)
puts
puts 'calka:'
puts test.pole(0, 3.1416)
puts
puts 'pochodna:'
puts test.pochodna(0)
