require_relative 'board.rb'
require 'yaml'
require 'io/console'

class NOTONBOARD < StandardError
end

class Game
  
  def initialize
    @board = Board.new
    @current_turn = :white
  end
  
  def start_game
    puts "Would you like to load a game? (y/n)"
    input = gets.chomp
    if input.downcase == 'y'
      load_file("saved-game.txt").run_game
    else
      run_game
    end
  end
  
  def run_game
    system("clear")
    @board.display_board
    until @board.check_mate?(:white) || @board.check_mate?(:black)
      begin
        puts "It's #{@current_turn}'s turn"
        move_choice = parse_user_input(get_user_input)
        after_move_output if successful_move_made?(move_choice)
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
    exit
  end

  private
  
    def save_file
      File.open("saved-game.txt", "w") do |f|
        f.puts self.to_yaml
      end
      puts "Successfully saved."
      exit
    end
  
    def load_file(filename)
      yaml_str = File.read(filename)
      raise NoSavedGame if yaml_str.length == 0
      game_obj = YAML.load(yaml_str)
    end
    
    def after_move_output
      switch_turn
      system("clear")
      @board.display_board
      puts "#{@current_turn} is in check!" if @board.in_check?(@current_turn)
    end
    
    def get_user_input
      puts "----------------------------------"
      puts "If you'd like to save, enter 's'."
      puts "What piece would you like to move? (cl/cr to castle left/right)"
      input_1 = gets.chomp
      save_file if input_1 == 's'
      if input_1 != 'cl' && input_1 != 'cr'
        puts "Where would you like to move to?"
        input_2 = gets.chomp
        save_file if input_2 == 's'
      else
        return input_1
      end
      
      [input_1, input_2]
    end
  
  
    def parse_user_input(array)
      return array unless array.is_a?(Array)
      
      from, to = array
  
      [convert_input(from), convert_input(to)]
    end
  
    def successful_move_made?(move_choice)
      if move_choice == 'cl'
        @board.castle(@current_turn, :left)
      elsif move_choice == 'cr'
        @board.castle(@current_turn, :right)
      else
        from_move, to_move = move_choice
      
        if @board.valid_move?(from_move, to_move, @current_turn)
          @board.move_piece(from_move, to_move)
          piece_at_end_pos = @board[to_move]
        
          #pawn promotion
          if piece_at_end_pos.is_a?(Pawn) && to_move.first == 0 || to_move.first == 7
            @board.create_queen_at_pos(to_move, piece_at_end_pos.color)
          end
        
          true
        else
          puts "Not a valid move, please try again."
          false
        end
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

if __FILE__ == $PROGRAM_NAME
  game = Game.new
  game.start_game
end