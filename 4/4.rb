matrix = []

@word_map = File.readlines("input", chomp: true).map do |line|
  line.split("")
end
@word_map_width = @word_map.first.length
@word_map_height = @word_map.length

XMAS = /XMAS/
SAMX = /SAMX/


def get_char(x, y)
  return if x >= @word_map.first.length or x < 0
  return if y >= @word_map.length or y < 0

  @word_map[y][x]
end

def total
  look_horizontally_matches + look_vertically_matches + look_diagonal_matches
end


def look_horizontally_matches
  matches = 0
  horizontal_words.each do |word|
    matches += word.scan(XMAS).length
    matches += word.scan(SAMX).length
  end

  matches
end

def look_vertically_matches
  matches = 0
  vertical_words.each do |word|
    matches += word.scan(XMAS).length
    matches += word.scan(SAMX).length
  end

  matches
end

def look_diagonal_matches
  matches = 0
  diagonal_words.each do |word|
    matches += word.scan(XMAS).length
    matches += word.scan(SAMX).length
  end

  matches
end

def horizontal_words
  @word_map.map(&:join)
end

def vertical_words
  vertical_words = []

  @word_map_width.times do |x|
    word = ""
    y = 0
    loop do
      char = get_char(x,y)
      break if char.nil?
      word << char
      y +=1
    end

    vertical_words << word
  end

  vertical_words
end

def diagonal_words
  left_down_triangle = []
  right_up_triangle = []

  left_up_triangle = []
  right_down_triangle = []

  (0..@word_map_height).each do |y|
    x = 0
    word = ""
    loop do
      char = get_char(x,y)
      break if char.nil?
      word << char
      x +=1
      y +=1
    end

    left_down_triangle << word
  end

  (1..@word_map_width).each do |x|
    y = 0
    word = ""
    loop do
      char = get_char(x,y)
      break if char.nil?
      word << char
      x +=1
      y +=1
    end

    right_up_triangle << word
  end

  (0..@word_map_width).reverse_each do |x|
    word = ""
    y = 0
    loop do
      char = get_char(x,y)
      break if char.nil?
      word << char
      x -=1
      y +=1
    end

    left_up_triangle << word
  end

  (1..(@word_map_height-1)).each do |y|
    word = ""
    x = @word_map_width-1
    loop do
      char = get_char(x,y)
      break if char.nil?
      word << char
      x -=1
      y +=1
    end

    right_down_triangle << word
  end


  diagonal_words = left_down_triangle
                      .concat(right_up_triangle)
                      .concat(left_up_triangle)
                      .concat(right_down_triangle)
end


def matches_xmas?(element, x,y)
  return false unless element == "A"

  upper_left = get_char(x-1, y-1)
  upper_right = get_char(x+1, y-1)
  lower_left = get_char(x-1, y+1)
  lower_right = get_char(x+1, y+1)


  return false unless ((upper_left == "M" && lower_right == "S") || (upper_left == "S" && lower_right == "M"))
  return false unless ((upper_right == "M" && lower_left == "S") || (upper_right == "S" && lower_left == "M"))


  true
end

total_xmas = 0
xmas_array = []

@word_map.each_with_index do |row,y|
  row.each_with_index do |element, x| 
    xmas_array << element if matches_xmas?(element, x, y)
  end
end

puts "xmas_array?", xmas_array.length

p "MATCH COUNT #{total}"
