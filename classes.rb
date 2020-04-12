class Mastermind
  class Board
    attr_accessor :code
    attr_reader :board

    ROUNDS = 12

    def initialize
      @@colors = %w[red orange yellow green blue purple]
      @board = []
      @code = Array.new(4, nil)
      @code_num = []
      @board_feedback = []
    end

    def self.game_start_codebreaker
      @game = Board.new
      @@turn = 0
      @game.create_code_cpu
      until Board.over?
        puts "Enter your guess:"
        @game.create_guess(gets.chomp.split[0..3])
        @game.feedback(@game.board[-1])
        @game.display_board
        @@turn += 1
      end
      puts "\nYOU WIN!"  if Board.win?
      puts "\nYOU LOSE!" if Board.lose? unless Board.win?
    end

    def self.game_start_codemaker
      @game = Board.new
      @@turn = 1
      puts "Please select four colors from the list:\n#{@@colors.join(', ')}"
      @game.create_code_player(gets.chomp)
      @game.create_guess_cpu
      until Board.over?
        @game.feedback(@game.board[-1])
        @game.display_board
        @game.cpu_better_guess
        @@turn += 1
        sleep(1)
      end
      @game.feedback(@game.board[-1])
      @game.display_board
      puts "\nCOMPUTER WINS!"  if Board.win?
      puts "\nCOMPUTER LOSES!" if Board.lose? unless Board.win?
    end

    def create_code_player *colors
      @code = colors[0].split
    end
    
    def create_code_cpu
      4.times { |i| @code[i] = @@colors[rand(6)] }
    end

    def create_guess *colors
      guess_contents = []
      guess_contents = colors
      @board << guess_contents.flatten
    end
    
    def create_guess_cpu
      guess_contents = []
      4.times { guess_contents << @@colors[rand(6)]}
      @board << guess_contents.flatten
    end
    
    def feedback current_guess
      feedback_holder = []
      current_guess.each_with_index do |e, i| 
        feedback_holder << "X" if @code[i] == e
        feedback_holder << "O" if @code.include?(e) && @code[i] != e
        feedback_holder << " " if !@code.include?(e)
      end
      @board_feedback << feedback_holder
    end
    
    def display_board
      puts "\nCurrent Board:"
      puts " _____________________________________"
      @board.each_with_index do |e, i|
        # Adds spaces between '|' based on character length of input & feedback
        # 27 spaces minus however many letters there are in each row
        color_spacing = " " * (27 - (e.join(' ').length))
        feedback_spacing = " " * (8 - (@board_feedback[i][0..3].join(' ').length))
        
      puts "|#{e.join(' ')}#{color_spacing}| #{
          @board_feedback[i][0..3].join(' ')}#{
            feedback_spacing}|"
      end
      puts "|___________________________|_________|\n\n"
    end
        
    def cpu_better_guess
      last_guess = @board[-1]
      next_guess = Array.new(4, nil)
      right_color = []
      multiples = []
      position_set = Array.new(4, false)

      last_guess.each_with_index do |e, i|
        if @code[i] == e
          next_guess[i] = e
          position_set[i] = true
        elsif (@code.count(e) < last_guess.count(e)) && @code.include?(e)
          multiples << e unless position_set[last_guess.index(e)]
        else 
          right_color << e if @code.include?(e) && (@code.count(e) >= last_guess.count(e))
        end
        @@colors -= [e] if !@code.include?(e)
      end

      multiples.uniq.each { |e| right_color << e }
      next_guess.count(nil).times do |i|
        nil_idx = next_guess.index(nil)
        next_guess[nil_idx] = right_color.shuffle[i] if next_guess[i] == nil
      end
      
      until next_guess.count(nil) == 0
        colors_size = @@colors.size
        nil_idx = next_guess.index(nil)
        next_guess[nil_idx] = @@colors[rand(colors_size)]
      end
    
      @board.each_with_index do |outer_e, outer_i|
        @board[outer_i].each_with_index do |e, i|
          if next_guess[i] == @board[outer_i][i] && @board[outer_i][i] != @code[i]
            until next_guess[i] != @board[outer_i][i]
              next_guess[i] = @@colors[rand(@@colors.size)]
            end
          end
        end
      end
      @board << next_guess
    end

    private 
    def self.over?
      return true if @@turn == ROUNDS
      return true if @game.board.last == @game.code 
    end

    def self.win?
      @game.board.last == @game.code
    end

    def self.lose?
      @@turn == ROUNDS
    end
  end

  class Creator < Board
    def self.game_start
      puts "Would you like to create the code or guess the code?"
      until @make_or_break == "create" || @make_or_break == "guess"
        puts "Please choose 'create' or 'guess'"
        @make_or_break = gets.chomp
      end

      Board.game_start_codebreaker if @make_or_break == "guess"
      Board.game_start_codemaker   if @make_or_break == "create"
    end
  end
end

Mastermind::Creator.game_start