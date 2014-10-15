require_relative "SteppingPiece.rb"

class Knight < SteppingPiece
  DELTAS = [
            [2, 1], 
            [2, -1], 
            [-2, 1], 
            [-2, -1],
            [1, 2], 
            [1, -2],
            [-1, 2],
            [-1, -2]
          ]
  
  def initialize(pos, board, color)
    super(pos, board, color)
    @piece_unicode = color==:white ? "\u2658" : "\u265E"
  end
  
end
