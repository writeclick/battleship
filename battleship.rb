# setup board data structures for player_one_board, player_two_board,
# player_one_guesses, and player_two_guesses

class Board

  # helper hashes for easier conversion in methods
  @@row_letters = %w[A B C D E F G H I J]
  @@col_numbers = %w[0 1 2 3 4 5 6 7 8 9]
  @@letter_as_number = {"A" => 0, "B" => 1, "C" => 2, "D" => 3, "E" => 4, "F" => 5,
    "G" => 6, "H" => 7, "I" => 8, "J" => 9}
  @@number_as_letter = {0 => "A", 1 => "B", 2 => "C", 3 => "D", 4 => "E", 5 => "F",
    6 => "G", 7 => "H", 8 => "I", 9 => "J"}

  def initialize
    @taken = {}               # coordinates are keys, values are occupying pieces
    @ac = ["","","","",""]    # aircraft carrier
    @bs = ["","","",""]       # battleship
    @cr = ["","",""]          # cruiser
    @ds = ["",""]             # destroyer
    @sb = [""]                # submarine
    @pieces = [@ac, @bs, @cr, @ds, @sb]
    # row letter is key, cells are values
    @avail_horiz_cells_hash = avail_horiz_cells_init 
    # col number is key, cells are values
    @avail_vert_cells_hash = avail_vert_cells_init
    place_pieces
    p @ac
    p @bs
    p @cr
    p @ds
    p @sb
    # p @avail_horiz_cells_hash
    # p @avail_vert_cells_hash
  end

  def avail_horiz_cells_init
    horiz_cells = []
    @@row_letters.each do |row_letter|
      @@col_numbers.each do |col_number|
        horiz_cells << row_letter + col_number
      end
    end
    horiz_cells_hash = {}
    @@row_letters.each_with_index do |letter, index|
      horiz_cells_hash[letter] = horiz_cells.slice!(0,10)
    end
    return horiz_cells_hash
  end

  def avail_vert_cells_init
    vert_cells = []
    @@col_numbers.each do |col_number|
      @@row_letters.each do |row_letter|
        vert_cells << row_letter + col_number
      end
    end
    vert_cells_hash = {}
    @@col_numbers.each_with_index do |number, index|
      vert_cells_hash[number] = vert_cells.slice!(0,10)
    end
    return vert_cells_hash
  end

  def place_pieces
    @ac = place_piece(@ac, position(@ac.length))
    @bs = place_piece(@bs, position(@bs.length))
    @cr = place_piece(@cr, position(@cr.length))
    @ds = place_piece(@ds, position(@ds.length))
    @sb = place_piece(@sb, position(@sb.length))
  end

  def position(piece_length)
    if horiz_or_vert_position == "horiz"
      position = avail_horiz_position(candidate_row, piece_length)
    else
      position = avail_vert_position(candidate_col, piece_length)
    end
    
    return position
  end

  def horiz_or_vert_position
    coin_flip = rand(2)
    position = coin_flip == 1 ? "horiz" : "vert"
    return position
  end

  def place_piece(piece, position)
    piece = position 
  end

  def avail_horiz_position(row, length)
    if @avail_horiz_cells_hash[row].length >= length
      remove_cells_from_vert_hash(@avail_horiz_cells_hash[row].slice(0,length))
      return @avail_horiz_cells_hash[row].slice!(0,length)
    else
      if letter_to_number(row) + 1 < 9
        avail_horiz_position(number_to_letter(letter_to_number(row) + 1), length)
      end
    end
  end

  def avail_vert_position(col, length)
    if @avail_vert_cells_hash[col].length >= length
      remove_cells_from_horiz_hash(@avail_vert_cells_hash[col].slice(0,length))
      return @avail_vert_cells_hash[col].slice!(0,length)
    else
      if col.to_i + 1 < 9
        avail_vert_position("#{col.to_i + 1}", length)
      end
    end
  end

  def remove_cells_from_vert_hash(cells_to_remove)
    cells_to_remove.each do |elem|
      key = elem.split("")[1]
      @avail_vert_cells_hash[key].delete(elem)
    end    
  end

  def remove_cells_from_horiz_hash(cells_to_remove)
    cells_to_remove.each do |elem|
      key = elem.split("")[0]
      @avail_horiz_cells_hash[key].delete(elem)
    end
  end

  def candidate_row
    number_to_letter(rand(9))
  end

  def candidate_col
    "#{rand(9).to_s}"
  end

  def piece_length_to_name(length) 
    length_to_piece = {5 => "AC", 4 => "BS", 3 => "CR", 2 => "DS", 1 => "SB"}
    return length_to_piece[length]
  end

  def letter_to_number(letter)
    @@letter_as_number[letter]
  end

  def number_to_letter(number)
    @@number_as_letter[number]
  end
 
  def taken?(cell)
    @taken[cell] != nil ? true : false
  end

  # def cells_valid?(cells)
  #   cells.each do |elem|
  #     y_as_letter = elem.split("").first
  #     x_as_number = elem.split("").last.to_i

  #     if letter_to_number(y_as_letter) > 9 || 
  #         letter_to_number(y_as_letter) < 0 || 
  #         x_as_number > 9 || 
  #         x_as_number < 0
  #      return false
  #     end

  #   end

  #   return true
  # end



  def candidate_direction
    direction_seed = rand(4)
    case direction_seed
    when 1
      return "right"
    when 2
      return "up"
    when 3
      return "left"
    else
      return "down"
    end
  end 

end

b = Board.new
# b.place_pieces(b.pieces)
