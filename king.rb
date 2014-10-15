require_relative 'SteppingPiece.rb'

class King < SteppingPiece
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
  end
  
end
