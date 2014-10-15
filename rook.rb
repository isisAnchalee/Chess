require_relative 'SlidingPiece.rb'

class Rook < SlidingPiece
  DELTAS = [
     [-1,  0],
     [ 0, -1],
     [ 0,  1],
     [ 1,  0]
   ]
  
  def initialize(pos, board, color)
    super(pos, board, color)
    @piece_unicode = color==:white ? "\u2656" : "\u265C"
  end
  
end
