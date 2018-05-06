class Kolekcja
  @array

  def initialize array
    @array = array
  end

  def get(i)
    @array[i]
  end

  def length()
    @array.length
  end

  def swap(i, j)
    temp = get(i)
    @array[i] = @array[j]
    @array[j] = temp
  end

  def to_s
    @array.to_s
  end
end

class Sortowanie
  def self.sort1 kolekcja
    i = 0

    while i < kolekcja.length
      min = i
      j = i + 1
      while j < kolekcja.length
        if kolekcja.get(min) > kolekcja.get(j)
          min = j
        end
        j += 1
      end
      kolekcja.swap(min, i)
      i += 1
    end
  end

  def self.sort2 kolekcja
    gap = kolekcja.length
    swapped = true
    while gap > 1 or swapped
      gap = gap * 10 / 13
      if gap == 9 or gap == 10
        gap = 11;
      end
      if gap == 0
        gap = 1
      end
      swapped = false
      i = 0
      while i < kolekcja.length - gap
        if kolekcja.get(i + gap) < kolekcja.get(i)
          kolekcja.swap(i, i + gap)
          swapped = true
        end
        i += 1
      end
    end
  end

  def self.mergesort kolekcja, start, stop
    if start != stop
      self.mergesort kolekcja, start, (start + stop) / 2
      self.mergesort kolekcja, (start + stop) / 2 + 1, stop
      i = start
      j = (start + stop / 2) + 1
      while i < stop and i < j and j < stop
        if kolekcja.get(i) > kolekcja.get(j)
          kolekcja.swap(i, j)
          j += 1
        end
        i += 1
      end
    end
  end
end

kol = Kolekcja.new [3, 4, 1, 2, 123, 123, 11, 23, 12, -3, 12, -3, 123, 3, 21, 21, 0]
puts kol
Sortowanie.sort1(kol)
puts kol
kol2 = Kolekcja.new [3, 4, 1, 2, 123, 123, 11, 23, 12, -3, 12, 2312312, 2312395, 49412, 4914, 14, 4, 4, 129412, 4124, 9, 294, 124912, 49124, 9149, 4, -3, 123, 3, 21, 21, 0]
puts kol2
Sortowanie.sort2 kol2
puts kol2