module Classable
  class Board
    attr_accessor :board, :row_contents
    attr_reader :code, :colors

    def initialize
      @colors = %w[red orange yellow green blue purple]
      @board = []
      @code = []
    end

    def display_board
      @board.each do |e|
        puts e
      end
    end

    private
    def create_code *colors
      @code = colors[0..3]
    end

    def create_code_cpu *colors
      4.times do
        @code << @colors[rand(6)]
      end
    end

    def create_guess *colors
      @row_contents = []
      @row_contents = colors[0..3]
      @board << @row_contents
    end

    def feedback 
      current_guess = @board.last
      @feedback = []
      4.times do |i|
        @feedback << "X" if @code[i] == current_guess[i]
        if @code.include? current_guess[i]
          @feedback << "O" unless @code[i] == current_guess[i]
        end
      end
    end
  end

  class Row < Board
  end

  class FeedbackPegs
  end
end