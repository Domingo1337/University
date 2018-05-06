class Funkcja2
  @proc

  def initialize procedure
    @proc = procedure
  end

  def value(x, y)
    @proc.call(x, y)
  end

  def objetosc(a, b, c, d)
    x = a
    e = 0.001
    volume = 0
    while x < b
      y = c
      while y < d
        volume += e * e * value(x, y)
        y += e
      end
      x += e
    end
    volume
  end

  def poziomica (a, b, c, d, wysokosc)
    pary = []
    x = a
    e_dok = 0.01
    e_wys = 0.001
    while x < b
      y = c
      while y < d

        if (value(x, y) - wysokosc).abs <= e_wys
          pary << [x, y]
        end
        y += e_dok
      end
      x += e_dok
    end
    pary
  end
end

fun = Funkcja2.new(Proc.new {|x, y| Math.sin(x)*Math.cos(y)})
puts fun.value(3,3)
puts fun.poziomica(-5, 5, -5, 5, 0)