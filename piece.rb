class Piece
  attr_reader :piece_unicode, :color
  
  def initialize(pos, board, color)
    @pos = pos
    @board = board
    @color = color
  end

  def set_new_current_position(new_pos)
    @pos = new_pos
  end
  
  def move_into_check?(end_pos)
    board_dup = @board.dup
    board_dup.move_piece(@pos, end_pos)
    board_dup.in_check?(self.color)
  end
  
  def combine_pos(pos1, pos2)
    [pos1[0] + pos2[0], pos1[1] + pos2[1]]
  end
  
end

