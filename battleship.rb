# setup board data structures for player_one_board, player_two_board,
# player_one_guesses, and player_two_guesses

class Board

  attr_reader :pieces

  # helper hashes for easier conversion in methods
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
    @avail_cells = [%w[A1,B1,C1,D1,E1],%w[F1,F2,F3,F4],%w[C2,D2,E2],%w[I3,J3],%w[G10]]
  end

  def place_pieces(pieces)
    pieces.each do |piece|
      cell = candidate_cell
      direction = candidate_direction
      length = piece.length
      positions = cells_available_for_placement
      place_piece(piece, positions )
      # prev line should always have an array of avail. cells passed to 2nd arg
    end
  end

  def place_piece(piece, available_cells)
    available_cells.each_with_index do |cell, index|
      piece[index] = cell
      @taken["cell"] = piece_length_to_name(piece.length)
    end
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

  def cells_valid?(cells)
    cells.each do |elem|
      y_as_letter = elem.split("").first
      x_as_number = elem.split("").last.to_i

      if letter_to_number(y_as_letter) > 10 || 
          letter_to_number(y_as_letter) < 0 || 
          x_as_number > 10 || 
          x_as_number < 0
       return false
      end

    end

    return true
  end 

  # => if length # of cells open, returns their coords, otherwise returns -1
  def cells_available_for_placement 
    @avail_cells.each do |cells|
      cells.each do |cell|
        @taken[cell] = piece_length_to_name(cell.length)
      end
    end
    @avail_cells.shift
  end

  def candidate_cell
    number_to_letter(rand(10)) + "#{rand(11).to_s}"
  end

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
b.place_pieces(b.pieces)

