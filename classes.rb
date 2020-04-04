module Classable
  class Board
    attr_accessor :board, :row_contents
    attr_reader :code

    def initialize
      @@colors = %w[red orange yellow green blue purple]
      @board = []
      @code = []
    end

    def colors
      @@colors
    end

    def display_board
      @board.each do |e|
        puts "#{e} | #{@feedback}"
      end
    end

    def create_code_cpu
      4.times do
        @code << @@colors[rand(6)]
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
      4.times do |i|
        color = color_count[guess[i].to_sym]
        @feedback << "X" if @code[i] == guess[i]
        if @code.include? guess[i] 
          @feedback << "O" unless @code[i] == guess[i]
        end
      end
      @feedback.sort!.reverse!
    end
    
    private
    def create_code *colors
      @code = colors[0..3]
    end
  end

  class Game < Board
    def initialize
      super
      @code = [
        @@colors[rand(6)], 
        @@colors[rand(6)], 
        @@colors[rand(6)], 
        @@colors[rand(6)]
      ]
    end

    def self.game_start
      game = Board.new
      game.create_code_cpu
      puts game.code
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