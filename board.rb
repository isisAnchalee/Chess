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
  attr_reader :grid
  
  ALPHABET = ("A".."H").to_a
  
  def initialize(dup = false)
    @grid = Array.new(8) { Array.new(8) { nil } }
    place_pieces_on_board unless dup
  end
  
  def display_board

    puts "Welcome to Chess!"
    puts "#{(ALPHABET.join "|")}|"
    @grid.each_with_index do |row, row_index|
      row.each_with_index do |el, col_index|
        get_piece_color(el, row_index, col_index)
      end
      puts 8 - row_index 
    end
    puts "#{(ALPHABET.join "|")}|"
    puts "-----------------"
  end
  
  # def each_piece
  #   if block_given?
  #     @grid.each_with_index do |row, row_index|
  #       row.each_with_index do |el, col_index|
  #         yield(row_index, col_index, el)
  #       end
  #     end
  #   end
  # end
  def in_check?(color)
    king_pos = find_king_position(color)
    enemy_includes_position?(king_pos, color)
  end
  
  def move_piece(start_pos, end_pos)
    start_piece = self[start_pos]
    self[end_pos] = start_piece
    self[start_pos] = nil
    
    start_piece.set_new_current_position(end_pos)
    start_piece.take_first_move if start_piece.is_a?(Pawn)

    self
  end
  
  def valid_move?(start_pos, end_pos, color)
    start_piece = self[start_pos]
    valid_start_piece!(start_piece, color)
    if start_piece.possible_valid_moves.include?(end_pos)
      if start_piece.move_into_check?(end_pos)
        raise CantMoveIntoCheck.new "Cannot make that move since your king is in check."
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
    @grid.each_with_index do |row, row_index|
      row.each_with_index do |el, col_index|
        if !el.nil?
          new_board[[row_index, col_index]] = 
                      el.class.new([row_index, col_index], new_board, el.color)
          if el.is_a?(Pawn)
            new_board[[row_index, col_index]].take_first_move if el.move_taken
          end 
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
        print el.nil? ? "  ".on_black : piece.on_black
      else
        print el.nil? ? "  ".on_light_white : piece.on_light_white
      end
    end
  
    def enemy_includes_position?(pos, color)
      enemy_possible_moves = []
      @grid.each_with_index do |row, row_index|
        row.each_with_index do |el, col_index|
          if !el.nil? && el.color != color
            enemy_possible_moves += el.possible_valid_moves
          end
        end
      end
    
      enemy_possible_moves.include?(pos)
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
      @grid.each_with_index do |row, row_index|
        row.each_with_index do |el, col_index|
          if !el.nil? && el.color == color
            subanswer = el.possible_valid_moves
            subanswer.select! do |move|
              !el.move_into_check?(move)
            end
            your_possible_moves += subanswer
          end
        end
      end

     your_possible_moves
    end
  
    def find_king_position(color)
      @grid.each_with_index do |row, row_index|
        row.each_with_index do |el, col_index|
          if el.is_a?(King) && el.color == color
            return [row_index, col_index]
          end
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