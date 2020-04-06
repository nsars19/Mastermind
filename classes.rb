module Classable
  class Board
    attr_reader :code

    def initialize
      @@colors = %w[red orange yellow green blue purple]
      @board = []
      @code = []
      @feedback_holder = []
      @board_feedback = []
      create_code_cpu
    end

    def colors
      @@colors
    end

    def self.board
      @board
    end

    def display_board
      puts "\nCurrent Board:"
      @board.each_with_index do |e,i|
        puts "#{e.join(' ')} | #{@board_feedback[i].join(' ')}"
      end
      puts
    end

    def create_guess *colors
      @guess_contents = []
      @guess_contents = colors
      @board << @guess_contents.flatten
    end

    def feedback 
      @feedback_holder = []
      guess = @board.last
      guess.each_with_index do |e, i|
        if @code[i] == e
          @feedback_holder << "X"
        elsif @code.include?(e)
          @feedback_holder << "O" 
        end
      end
      @board_feedback << @feedback_holder.sort!.reverse!
    end

    private
    def create_code *colors
      @code = colors[0..3]
    end

    def create_code_cpu
      4.times { @code << @@colors[rand(6)] }
    end
  end

  class Game < Board
    attr_reader :board, :code
    
    ROUNDS = 12
    
    def initialize
      super
      @code = []
      create_code_cpu
    end

    def self.game_start
      game = Board.new
      @@turn = 1
      puts game.code
      until Game.over?
        game.create_guess(gets.chomp.split)
        game.feedback
        game.display_board
        @@turn += 1
        # puts "#{self.board}"
        # puts "#{game.code}"
      end
    end

    def self.code
      @code
    end

    def self.over?
      return true if @@turn == ROUNDS
      #return true if @board == self.code 
    end
  end
end

Classable::Game.game_start