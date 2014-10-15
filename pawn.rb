require_relative 'piece'

class Pawn < Piece
  attr_reader :move_taken
  
  PAWN_MOVES = {
    white: [-1, 0],
    black: [1, 0]
  }
  CAPTURE_MOVES = {
    white: [[-1, -1], [-1, 1]],
    black: [[1, -1], [1, 1]]
  }
  
  def initialize(pos, board, color)
    super(pos, board, color)
    @piece_unicode = color==:white ? "\u2659" : "\u265F"
    @move_taken = false
  end
  
  
  def possible_valid_moves
    moves = []
    pawn_movement = PAWN_MOVES[@color]
    new_pos = combine_pos(@pos, pawn_movement)
    if @board[new_pos].nil?
        moves << new_pos 
      if !@move_taken
        new_pos = combine_pos(new_pos, pawn_movement)
        moves << new_pos if @board[new_pos].nil?
      end
    end

    moves += return_cap_moves
  end
  
  def take_first_move
    @move_taken = true
  end
  
  
  private
  
    def return_cap_moves
      capture_moves = []
      pawn_capture_movement = CAPTURE_MOVES[@color]
      pawn_capture_movement.each do |move|
        new_pos = combine_pos(@pos, move)
        if !@board[new_pos].nil? && @board[new_pos].color != self.color
          capture_moves << new_pos
        end
      end
    
      capture_moves
    end
  
end