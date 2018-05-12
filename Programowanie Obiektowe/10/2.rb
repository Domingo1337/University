class Kolekcja
  class Node
    attr_accessor :prev, :next, :val
    @prev
    @next
    @val

    def initialize prev, val, nxt
      @prev = prev
      @next = nxt
      @val = val
    end
  end

  @first
  @last
  @length

  def initialize
    @first = nil
    @length = 0
  end
  def length
    @length
  end
  def get i
    if i < @length / 2
      temp = @first
      for j in 0...i
        temp = temp.next
      end
      return temp.val
    else
      temp = @last
      for j in 0...@length - i - 1
        temp = temp.prev
      end
      return temp.val
    end
  end

  def add value
    if @first == nil
      @first = Node.new nil, value, nil
      @last = @first
    elsif value <= @first.val
      @first = Node.new nil, value, @first
      @first.next.prev = @first
    else
      temp = @first
      while value >= temp.val and temp.next != nil
        temp = temp.next
      end
      if value >= temp.val
        temp.next = Node.new temp, value, nil
        @last = temp.next
      else
        node = Node.new temp.prev, value, temp
        temp.prev.next = node
        temp.prev = node
      end
    end
    @length += 1
  end

  def to_s
    if @first == nil
      return nil
    end
    s = '[' + @first.val.to_s
    temp = @first.next
    while temp != nil
      s += ', ' + temp.val.to_s
      temp = temp.next
    end
    s += ']'
  end
end

class Wyszukiwanie
  def self.binsearch kolekcja, value
    counter = 0
    left = 0
    right = kolekcja.length - 1
    while left <= right
      counter +=1
      center = (left+right)/2
      current = kolekcja.get center
      if  current == value
        puts counter
        return center
      elsif current > value
        right = center - 1
      else
        left = center + 1
      end
    end
    false
  end
  def self.interpolarsearch kolekcja, value
    counter = 0
    left = 0
    right = kolekcja.length - 1
    while left <= right
      counter +=1
      leftval = kolekcja.get left
      rghtval = kolekcja.get right

      center =  left+(right-left)*(value - leftval)/(rghtval-leftval)
      current = kolekcja.get center
      if  current == value
        puts counter
        return center

      elsif current > value
        right = center - 1
      else
        left = center + 1
      end
    end
    false
  end
end

test = Kolekcja.new

for i in 0 ... 1000
  test.add rand 1000
end



puts Wyszukiwanie.interpolarsearch test, 0
puts Wyszukiwanie.interpolarsearch test, 500
puts Wyszukiwanie.interpolarsearch test, 1000
puts Wyszukiwanie.binsearch test, 0
puts Wyszukiwanie.binsearch test, 500
puts Wyszukiwanie.binsearch test, 1000