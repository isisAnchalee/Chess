require_relative 'SteppingPiece.rb'

class King < SteppingPiece
  attr_reader :has_moved
  DELTAS = [
     [-1, -1],
     [-1,  0],
     [-1,  1],
     [ 0, -1],
     [ 0,  1],
     [ 1, -1],
     [ 1,  0],
     [ 1,  1]
   ]
  
  def initialize(pos, board, color)
    super(pos, board, color)
    @piece_unicode = color==:white ? "\u2654" : "\u265A"
    @has_moved = false
  end
  
  def take_first_move
    @has_moved = true
  end
end
