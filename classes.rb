module Classable
  class Board
    attr_reader :code, :board

    def initialize
      @@colors = %w[red orange yellow green blue purple]
      @board = []
      @code = Array.new(4, nil)
      @feedback_holder = []
      @board_feedback = []
      create_code_cpu
    end

    def self.board
      @board
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

    def display_board
      puts "\nCurrent Board:"
      @board.each_with_index do |e,i|
        puts "#{e.join(' ')} | #{@board_feedback[i].join(' ')}"
      end
      puts
    end
    
    private
    def create_code *colors
      @code = colors[0..3]
    end

    def create_code_cpu
      4.times { |i| @code[i] = @@colors[rand(6)] }
    end
  end

  class Game < Board
    ROUNDS = 12

    def self.code
      @code
    end

    def self.game_start
      @game = Board.new
      @@turn = 0
      puts @game.code
      until Game.over?
        puts "Enter your guess:"
        @game.create_guess(gets.chomp.split)
        @game.feedback
        @game.display_board
        @@turn += 1
      end
      puts "\nYOU WIN!" if Game.win?
      puts "\nYOU LOSE!" if Game.lose? unless Game.win?
    end

    def self.over?
      return true if @@turn == ROUNDS
      return true if @game.board.last == @game.code 
    end

    def self.win?
      @game.board.last == @game.code ? true : false
    end

    def self.lose?
      @@turn == ROUNDS ? true : false
    end
  end
end

Classable::Game.game_start