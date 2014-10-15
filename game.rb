require_relative 'board.rb'

class NOTONBOARD < StandardError
end

class Game

  def initialize
    @board = Board.new
    @current_turn = :white
  end
  
  def start_game
    system("clear")
    @board.display_board
    until @board.check_mate?(:white) || @board.check_mate?(:black)
      begin
        puts "It's #{@current_turn}'s turn"
        move_choice = parse_user_input(get_user_input)
        handle_move(move_choice)
        
      rescue NoPieceError => e
        puts e.message
        retry
      rescue NotYourPieceError => e
        puts e.message
        retry
      rescue NOTONBOARD => e
        puts e. message
        retry
      rescue CantMoveIntoCheck => e
        puts e. message
        retry
      end
    end
    
    winner_is
  end
  

  
  private
  
    def get_user_input
      puts "----------------------------------"
      puts "What piece would you like to move?"
      input_1 = gets.chomp
      puts "Where would you like to move to?"
      input_2 = gets.chomp
    
      [input_1, input_2]
    end
  
  
    def parse_user_input(array)
      from, to = array
  
      [convert_input(from), convert_input(to)]
    end
  
    def handle_move(move_choice)
    
      if @board.valid_move?(move_choice.first, move_choice.last, @current_turn)
        @board.move_piece(move_choice.first, move_choice.last)
        switch_turn
        system("clear")
        @board.display_board
        puts "#{@current_turn} is in check!" if @board.in_check?(@current_turn)

      else
        puts "Not a valid move, please try again."
      end
    
    end
  
    def winner_is
      switch_turn
      puts "#{@current_turn} wins!"
    end
  
    def convert_input(input)
      arr_of_input = input.split("")
      col = Board::ALPHABET.index(arr_of_input.first.upcase)
      row = (arr_of_input.last.to_i - 8).abs
    
      [row, col] if valid_row_col?(row, col)
    
    end
  
    def valid_row_col?(row, col)
      unless row.between?(0, 7) && col.between?(0, 7)
        raise NOTONBOARD.new("Must select valid square")
      end
    
      true
    end
  
    def switch_turn
      @current_turn = @current_turn == :white ? :black : :white
    
    end
  
end

game = Game.new
game.start_game