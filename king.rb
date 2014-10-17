require_relative 'stepping_piece.rb'

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
<<<<<<< HEAD
    @piece_unicode = color==:white ? "\u2654" : "\u265A"
=======
    @piece_unicode = color == :white ? "\u2654" : "\u265A"
>>>>>>> e91f73200e651b091610fc6096e921dc9c9de2a9
    @has_moved = false
  end
  
  def take_first_move
    @has_moved = true
  end
end
