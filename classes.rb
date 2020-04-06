module Classable
  class Board
    attr_reader :code

    def initialize
      @@colors = %w[red orange yellow green blue purple]
      @board = []
      @code = []
      @feedback = []
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
      @board.each do |e|
        puts "#{e.join(' ')} | #{@feedback.join(' ')}"
      end
      puts
    end

    def create_guess *colors
      @row_contents = []
      @row_contents = colors
      @board << @row_contents.flatten
    end

    def feedback 
      @feedback = []
      guess = @board.last
      guess.each_with_index do |e, i|
        if @code[i] == e
          @feedback << "X"
        elsif @code.include?(e)
          @feedback << "O" 
        end
      end
      @feedback.sort!.reverse!
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
        
      end
    end

    def self.over?
      return true if @@turn == ROUNDS
      return true if @row_contents == @code
    end
  end
end

Classable::Game.game_start