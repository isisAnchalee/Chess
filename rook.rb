require_relative 'SlidingPiece.rb'

class Rook < SlidingPiece
  attr_reader :has_moved
  
  DELTAS = [
     [-1,  0],
     [ 0, -1],
     [ 0,  1],
     [ 1,  0]
   ]
  
  def initialize(pos, board, color)
    super(pos, board, color)
    @piece_unicode = color==:white ? "\u2656" : "\u265C"
    @has_moved = false
  end
  
  def take_first_move
    @has_moved = true
  end
end
