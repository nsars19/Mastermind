module Classable
  class Board
    attr_reader :code

    def initialize
      @@colors = %w[red orange yellow green blue purple]
      @board = []
      @code = []
      create_code_cpu
    end

    def colors
      @@colors
    end

    def display_board
      @board.each do |e|
        puts "#{e} | #{@feedback}"
      end
    end

    def create_guess *colors
      @row_contents = []
      @row_contents = colors
      @board << @row_contents.flatten
    end

    def feedback 
      guess = @board.last
      @feedback = []
      guess.each_with_index do |e, i|
        @feedback << "X" if @code[i] == e
      end
      @feedback #.sort!.reverse!
    end

    private
    def create_code *colors
      @code = colors[0..3]
    end

    def create_code_cpu
      4.times do
        @code << @@colors[rand(6)]
      end
    end
  end

  class Game < Board
    ROUNDS = 12
    
    def initialize
      super
      4.times { @code << @@colors[rand(6)] }
    end

    def self.game_start
      game = Board.new
      puts game.code
      puts
      game.create_guess(gets.chomp.split)
      game.feedback
      game.display_board
    end
  end

  class Row < Board
  end

  class FeedbackPegs
  end
end

Classable::Game.game_start