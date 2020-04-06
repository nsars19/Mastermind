module Classable
  class Board
    attr_accessor :code
    attr_reader :board

    def initialize
      @@colors = %w[red orange yellow green blue purple]
      @board = []
      @code = Array.new(4, nil)
      @feedback_holder = []
      @board_feedback = []
      create_code_cpu
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
      puts " _____________________________________"
      @board.each_with_index do |e,i|
        puts "|#{e.join(' ')}#{" " * (27 - (e.join(' ').length))}| #{@board_feedback[i].join(' ')}#{" " * 
              (8 - (@board_feedback[i].join(' ').length))}|"
      end
      puts "|_____________________________________|\n\n"
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

    def self.game_start
      @game = Board.new
      @@turn = 0
      puts @game.code
      until Game.over?
        puts "Enter your guess:"
        @game.create_guess(gets.chomp.split[0..3])
        @game.feedback
        @game.display_board
        @@turn += 1
      end
      puts "\nYOU WIN!" if Game.win?
      puts "\nYOU LOSE!" if Game.lose? unless Game.win?
    end

    private
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

  class Creator < Game
    # def initialize
    #   puts "Would you like to create the code or guess the code?"
    #   @make_or_break = gets.chomp
    #   until @make_or_break == "create" || @make_or_break == "guess"
    #     puts "Please choose 'create' or 'guess'"
    #     @make_or_break = gets.chomp
    #   end
    #   self.game_start
    # end

    def self.game_start
      puts "Would you like to create the code or guess the code?"
      @make_or_break = gets.chomp
      until @make_or_break == "create" || @make_or_break == "guess"
        puts "Please choose 'create' or 'guess'"
        @make_or_break = gets.chomp
      end
      Classable::Game.game_start if @make_or_break == "guess"
    end
    
    private
    def codemaker?
      true if @make_or_break == "create"
    end

    def codebreaker?
      true if @make_or_break == "guess"
    end
  end
end

Classable::Creator.game_start