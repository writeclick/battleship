# setup board data structures for player_one_board, player_two_board,
# player_one_guesses, and player_two_guesses

class Board
  attr_reader :taken
  attr_accessor :pieces, :hits_on_pieces

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
    @hits_on_pieces = {"AC" => [], "BS" => [], "CR" => [], "DS" => [], "SB" => []}


    p @taken
    #p @ac
    #p @bs
    #p @cr
    #p @ds
    #p @sb
    #p @avail_horiz_cells_hash
    #p @avail_vert_cells_hash
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
    pieces = []
    @ac = place_piece(@ac, position(@ac.length))
    pieces << @ac
    @bs = place_piece(@bs, position(@bs.length))
    pieces << @bs
    @cr = place_piece(@cr, position(@cr.length))
    pieces << @cr
    @ds = place_piece(@ds, position(@ds.length))
    pieces << @ds
    @sb = place_piece(@sb, position(@sb.length))
    pieces << @sb

    pieces.each do |piece|
      piece.each do |cell|
        @taken[cell] = piece_length_to_name(piece.length)
      end
    end
    
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
    if @avail_horiz_cells_hash[row].length >= length &&
        horiz_cells_adjacent?(@avail_horiz_cells_hash[row].slice(0,length))
      remove_cells_from_vert_hash(@avail_horiz_cells_hash[row].slice(0,length))
      return @avail_horiz_cells_hash[row].slice!(0,length)
    else
      if letter_to_number(row) + 1 < 9
        avail_horiz_position(number_to_letter(letter_to_number(row) + 1), length)
      end
    end
  end

  def avail_vert_position(col, length)
    if @avail_vert_cells_hash[col].length >= length &&
        vert_cells_adjacent?(@avail_vert_cells_hash[col].slice(0,length))
      remove_cells_from_horiz_hash(@avail_vert_cells_hash[col].slice(0,length))
      return @avail_vert_cells_hash[col].slice!(0,length)
    else
      if col.to_i + 1 < 9
        avail_vert_position("#{col.to_i + 1}", length)
      end
    end
  end

  def vert_cells_adjacent?(position)
    first_row = position[0].split("")[0]
    col = position[0].split("")[1]
    expected_position = []
    position.length.times do |count|
      expected_position << number_to_letter(letter_to_number(first_row) + count) + col
    end

    if expected_position == position
      return true
    else
      return false
    end
  end

  def horiz_cells_adjacent?(position)
    first_col = position[0].split("")[1]
    row = position[0].split("")[0]
    expected_position = []
    position.length.times do |count|
      expected_position << row + "#{first_col.to_i + count}"
    end

    if expected_position == position
      return true
    else
      return false
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
 
  def hit?(cell)
    @taken[cell] != nil ? true : false
  end  

end



class ScoreCard
  attr_accessor :player_one_gunner, :computer_gunner, :player_one_board,
    :computer_board

  def initialize
    @player_one_board = Board.new
    @computer_board = Board.new
    @player_one_gunner = Gunner.new
    @computer_gunner = Gunner.new
  end
   
  def sunk_pieces(target_player)
    target_player.hits_on_pieces.each_with_index  do |piece, damage|
      if target_player.piece_length_to_name(piece.length) == piece
        puts "You have sunk #{:target_player}'s piece"
      end
    end
  end

end

class Gunner
  attr_accessor :shots_fired, :misses

  def initialize
    @shots_fired = []
    @misses = []
  end

  def fire_shots(target_player)
    shots = []

    while @shots_fired.length < target_player.pieces.length
      puts "Enter {#player_one_board} coordinates"
      @shots_fired << gets.chomp!.upcase           
    end

    @shots_fired.each do |shot|
      if target_player.hit?(shot)
        record_hit(target_player, shot)
      else
        record_miss(shot)
      end
    end
  end

  def record_miss(splash)
    @misses << splash
  end

  def record_hit(target_player, explosion)
    target_player.hits_on_pieces[target_player.taken[explosion]] << explosion
  end

end


game = ScoreCard.new

game.player_one_gunner.fire_shots(game.computer_board)
p game.player_one_gunner.shots_fired 
p game.player_one_gunner.misses
p game.computer_board.hits_on_pieces
p game.sunk_pieces(game.computer_board)

