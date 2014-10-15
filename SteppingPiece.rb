require_relative 'piece.rb'

class SteppingPiece < Piece
  
  def possible_valid_moves
    moves = []
    
    self.class::DELTAS.each do |coord|
      new_pos = combine_pos(@pos, coord)
      moves << new_pos if piece_can_move_to?(new_pos)
    end
    
    moves
  end
  
  private
  
    def piece_can_move_to?(pos)
      row, col = pos
      return false unless @board.on_board?(pos)
      square = @board.grid[row][col]
      square.nil? || square.color != self.color
    end
  
end