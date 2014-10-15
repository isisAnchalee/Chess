require_relative 'SlidingPiece.rb'

class Bishop < SlidingPiece
  DELTAS = [
     [-1, -1],
     [-1,  1],
     [ 1, -1],
     [ 1,  1]
   ]
   
  def initialize(pos, board, color)
    super(pos, board, color)
    @piece_unicode = color==:white ? "\u2657" : "\u265d"
  end
  
end
