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
    (@proc.call(x-e)+@proc.call(x+e))/(2*e)
  end
end


fun = Proc.new {|x| -x * x + 2 * x + 5}
test = Funkcja.new(fun)
puts test.value(3.5)
puts 'miejsca zerowe' + fun.to_s + ': '
puts test.zerowe(-2, 5, 0.1)
puts
puts 'calka od -2 do 5'
puts test.pole(-2.0, 5.0)
puts
puts test.pochodna(3.0)