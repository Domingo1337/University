class Integer
  def ack(m)
    if self == 0
      m + 1
    elsif m == 0
      (self - 1).ack(1)
    else
      (self - 1).ack(self.ack(m - 1))
    end
  end

  def czynniki
    array = [1]
    i = 2
    while i <= self
      if self % i == 0
        array << i
      end
      i += 1
    end
    array
  end

  def doskonala
    sum = -self
    self.czynniki.each {|a| sum += a}
    self == sum
  end

  def slownie
    if self > 9
      (self / 10).slownie + ' ' + (self % 10).slownie
    elsif self == 9
      'dziewiec'
    elsif self == 8
      'osiem'
    elsif self == 7
      'siedem'
    elsif self == 6
      'szesc'
    elsif self == 5
      'piec'
    elsif self == 4
      'cztery'
    elsif self == 3
      'trzy'
    elsif self == 2
      'dwa'
    elsif self == 1
      'jeden'
    else
      'zero'
    end
  end
end

puts 'Ack(2,1) = ' + 2.ack(1).to_s
puts 'dzielniki 12: ' + 12.czynniki.to_s
puts '9069103 slownie to: ' + 906245103.slownie
puts 'czy 6 jest doskonala? ' + 6.doskonala.to_s
puts 'czy 7 jest doskonala? ' + 7.doskonala.to_s

