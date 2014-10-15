require_relative 'knight.rb'
require_relative 'king.rb'
require_relative 'pawn.rb'
require_relative 'rook.rb'
require_relative 'bishop.rb'
require_relative 'queen.rb'
require 'colorize'

class NoPieceError < StandardError
end

class NotYourPieceError < StandardError
end

class CantMoveIntoCheck < StandardError
end

class Board
  attr_reader :grid, :current_tile
  
  ALPHABET = ("A".."H").to_a
  
  def initialize(dup = false)
    @grid = Array.new(8) { Array.new(8) { nil } }
    # @current_tile = [5,0]
    place_pieces_on_board unless dup
  end
  
  def display_board
    puts "Welcome to Chess!"
    puts "#{(ALPHABET.join "|")}|"
    each_piece do |el, row_index, col_index| 
      get_piece_color(el, row_index, col_index)
      puts 8 - row_index if col_index == 7
    end
      
    puts "#{(ALPHABET.join "|")}|"
    puts "-----------------"
  end
  
  def set_current_tile(pos)
    @current_tile = pos
  end

  def in_check?(color)
    king_pos = find_king_position(color)
    enemy_includes_position?(king_pos, color)
  end
  
  def move_piece(start_pos, end_pos)
    start_piece = self[start_pos]
    self[end_pos] = start_piece
    self[start_pos] = nil
    
    start_piece.set_new_current_position(end_pos)
    if start_piece.is_a?(Pawn) || start_piece.is_a?(Rook) || start_piece.is_a?(King) 
      start_piece.take_first_move
    end
    
    self
  end
  
  def castle(color, dir)
    if can_castle?(color, dir)
      row, col = get_row(color), get_col(dir)
      king_delta = dir==:left ? [0, -2] : [0, 2]
      rook_delta = dir==:left ? [0, 3] : [0, -2]
      new_king_pos = combine_pos([row, 4], king_delta)
      new_rook_pos = combine_pos([row, col], rook_delta)
      move_piece([row, 4], new_king_pos)
      move_piece([row, col], new_rook_pos)

      true
    else
      puts "Can't castle that."
      false
    end
  end
  

  
  def can_castle?(color, dir)
    return false if in_check?(color)
    row, col = get_row(color), get_col(dir)
    delta = dir==:left ? [0, -1] : [0, 1]
    
    king_pos, rook_pos = [row, 4], [row, col]
    rook, king = self[rook_pos], self[king_pos]
    
    return false if invalid_casle_pos?(king, rook)
    
    new_pos = combine_pos(king_pos, delta)
    until new_pos.last < 2 || new_pos.last > 6
      return false if !self[new_pos].nil?
      new_board = self.dup
      new_board.move_piece(king_pos, new_pos)
      return false if new_board.in_check?(color)
      new_pos = combine_pos(new_pos, delta)
    end
    
    true
  end
  

  
  
  def invalid_casle_pos?(king, rook)
    king.nil? || king.has_moved || rook.nil? || rook.has_moved
  end
  
  def combine_pos(pos1, pos2)
    [pos1[0] + pos2[0], pos1[1] + pos2[1]]
  end
  
  
  def create_queen_at_pos(pos, color)
    self[pos] = Queen.new(pos, self, color)
  end
  
  def valid_move?(start_pos, end_pos, color)
    start_piece = self[start_pos]
    valid_start_piece!(start_piece, color)
    if start_piece.possible_valid_moves.include?(end_pos)
      if start_piece.move_into_check?(end_pos)
        raise CantMoveIntoCheck.new "Cannot make that move since your king is/would be in check."
      else
        return true
      end
    end
    
    false
  end
  
  def on_board?(pos)
    row, col = pos
    row.between?(0,7) && col.between?(0,7)
  end
  
  def [](pos)
    row, col = pos
    @grid[row][col]
  end
  
  def []=(pos, piece)
    row, col = pos
    @grid[row][col] = piece
  end
  
  def check_mate?(color)
    your_moves(color).empty?
  end
  
  def dup
    new_board = self.class.new(true)
    each_piece do |el, row_index, col_index|
      if !el.nil?
        new_board[[row_index, col_index]] = 
                  el.class.new([row_index, col_index], new_board, el.color)
        if el.is_a?(Pawn)
          new_board[[row_index, col_index]].take_first_move if el.move_taken
        end
      end 
    end
    
    new_board
  end
  
  private

    def get_piece_color(el, row_index, col_index)
      if !el.nil?
        if el.color == :white
          piece = "#{el.piece_unicode} ".green
        else
          piece = "#{el.piece_unicode} ".light_blue
        end
      end
      
      if row_index.even? && col_index.odd? || col_index.even? && row_index.odd?
        processed_piece = el.nil? ? "  ".on_black : piece.on_black
      else
        processed_piece = el.nil? ? "  ".on_light_white : piece.on_light_white
      end
      print processed_piece
      # if [row_index, col_index] == @current_tile
#         print processed_piece.yellow.on_magenta.blink
#       else
#         print processed_piece
#       end
    end
  
    def each_piece
      if block_given?
        @grid.each_with_index do |row, row_index|
          row.each_with_index do |el, col_index|
            yield(el, row_index, col_index)
          end
        end
      end
    end
  
    def enemy_includes_position?(pos, color)
      enemy_possible_moves = []
      each_piece do |el, row_index, col_index|
        if !el.nil? && el.color != color
          enemy_possible_moves += el.possible_valid_moves
        end
      end
    
      enemy_possible_moves.include?(pos)
    end
    
    def get_row(color)
      row = color==:white ? 7 : 0
    end
  
    def get_col(dir)
      col = dir==:left ? 0 : 7
    end
  
    def valid_start_piece!(start_piece, color)
      if start_piece.nil?
        raise NoPieceError.new "There is no piece here!"
      elsif start_piece.color != color
        raise NotYourPieceError.new "That's not your piece."
      end
    end
  
    def your_moves(color)
      your_possible_moves = []
      each_piece do |el, row_index, col_index|
        if !el.nil? && el.color == color
          subanswer = el.possible_valid_moves
          subanswer.select! { |move| !el.move_into_check?(move) }
          your_possible_moves += subanswer
        end
      end

     your_possible_moves
    end
  
    def find_king_position(color)
      each_piece do |el, row_index, col_index|
        if el.is_a?(King) && el.color == color
          return [row_index, col_index]
        end
      end
    end
  
    def place_pieces_on_board
      @grid.each_with_index do |row, row_index|
        row.each_index do |col_index|
          if row_index == 6
            @grid[row_index][col_index] = Pawn.new([row_index,col_index], self, :white)
          elsif row_index == 1
            @grid[row_index][col_index] = Pawn.new([row_index,col_index], self, :black)
          elsif row_index == 0
            if col_index == 0 || col_index == 7
              @grid[row_index][col_index] = Rook.new([row_index,col_index], self, :black)
            elsif col_index == 1 || col_index == 6
              @grid[row_index][col_index] = Knight.new([row_index,col_index], self, :black)
            elsif col_index == 2 || col_index == 5
              @grid[row_index][col_index] = Bishop.new([row_index,col_index], self, :black)
            elsif col_index == 3
              @grid[row_index][col_index] = Queen.new([row_index,col_index], self, :black)
            else
              @grid[row_index][col_index] = King.new([row_index,col_index], self, :black)
            end
          elsif row_index == 7
            if col_index == 0 || col_index == 7
              @grid[row_index][col_index] = Rook.new([row_index,col_index], self, :white)
            elsif col_index == 1 || col_index == 6
              @grid[row_index][col_index] = Knight.new([row_index,col_index], self, :white)
            elsif col_index == 2 || col_index == 5
              @grid[row_index][col_index] = Bishop.new([row_index,col_index], self, :white)
            elsif col_index == 3
              @grid[row_index][col_index] = Queen.new([row_index,col_index], self, :white)
            else
              @grid[row_index][col_index] = King.new([row_index,col_index], self, :white)
            end
          end
        end
      end
    end
  
end
