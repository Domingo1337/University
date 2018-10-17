class Jawna
  @napis

  def initialize napis
    @napis = napis
  end

  def zaszyfruj klucz
    res = ""
    for c in 0..@napis.length - 1 do
      temp = klucz[@napis[c]]
      if temp != nil
        res += temp
      else
        res += @napis[c]
      end
    end
    Zaszyfrowane.new res
  end

  def to_s
    @napis.to_s
  end
end

class Zaszyfrowane
  @napis

  def initialize napis
    @napis = napis
  end

  def odszyfruj klucz
    res = ""
    for c in 0..@napis.length - 1 do
      temp = klucz[@napis[c]]
      if temp != nil
        res += temp
      else
        res += @napis[c]
      end
    end
    Jawna.new res
  end

  def to_s
    @napis.to_s
  end
end

gaderypoluki = {
    'g' => 'a',
    'd' => 'e',
    'r' => 'y',
    'p' => 'o',
    'l' => 'u',
    'k' => 'i',
    'a' => 'g',
    'e' => 'd',
    'y' => 'r',
    'o' => 'p',
    'u' => 'l',
    'i' => 'k'
}

jawne = Jawna.new 'zakodujmy cos'
puts jawne
puts jawne.zaszyfruj gaderypoluki
puts (jawne.zaszyfruj gaderypoluki).odszyfruj gaderypoluki

