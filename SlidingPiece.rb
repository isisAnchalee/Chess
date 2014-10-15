require_relative "piece.rb"

class SlidingPiece < Piece
  
  def possible_valid_moves 
    moves = []
    self.class::DELTAS.each do |delta|
      moves += create_path_in_direction(@pos, delta)
    end
    
    moves
  end
  
  private
  
    def create_path_in_direction(start, dir)
      path = []
      new_pos = combine_pos(start,dir)
    
      while @board.on_board?(new_pos) 
        if @board[new_pos].nil? 
          path << new_pos
        elsif @board[new_pos].color == self.color
          return path
        else
          path << new_pos
          return path
        end
        new_pos = combine_pos(new_pos, dir)
      end
    
      path
    end
  
end

