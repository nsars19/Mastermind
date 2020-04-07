require_relative 'codebreaker_helper'

class Mastermind
  class Board
    attr_accessor :code
    attr_reader :board

    def initialize
      @@colors = %w[red orange yellow green blue purple]
      @board = []
      @code = Array.new(4, nil)
      @board_feedback = []
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
    
    def feedback 
      feedback_holder = []
      guess = @board.last
      guess.each_with_index do |e, i|
        if @code[i] == e
          feedback_holder << "X"
        elsif @code.include?(e)
          feedback_holder << "O" 
        end
      end
      @board_feedback << feedback_holder.sort!.reverse!
    end

    def display_board
      puts "\nCurrent Board:"
      puts " _____________________________________"
      @board.each_with_index do |e,i|
        # Adds spaces between '|' based on character length of input & feedback
        color_spacing = " " * (27 - (e.join(' ').length))
        feedback_spacing = " " * (8 - (@board_feedback[i].join(' ').length))

        puts "|#{e.join(' ')}#{color_spacing}| #{
              @board_feedback[i].join(' ')}#{feedback_spacing}|"
      end
      puts "|___________________________|_________|\n\n"
    end
    
    def create_code_player *colors
      @code = colors[0].split
    end
    
    def create_code_cpu
      4.times { |i| @code[i] = @@colors[rand(6)] }
    end
  end

  class Game < Board
    include Solvable
    ROUNDS = 12

    def self.game_start_codebreaker
      @game = Board.new
      @@turn = 0
      @game.create_code_cpu
      puts @game.code #### REMOVE ME WHEN FINISHED
      until Game.over?
        puts "Enter your guess:"
        @game.create_guess(gets.chomp.split[0..3])
        @game.feedback
        @game.display_board
        @@turn += 1
      end
      puts "\nYOU WIN!"  if Game.win?
      puts "\nYOU LOSE!" if Game.lose? unless Game.win?
    end

    def self.game_start_codemaker
      @game = Board.new
      @@turn = 0
      puts "Please select four colors from the list:\n#{@@colors.join(', ')}"
      @game.create_code_player(gets.chomp)
      p @game.code #### REMOVE ME WHEN FINISHED
      @game.create_guess_cpu
      until Game.over?
        @game.feedback
        @game.display_board
        ### helper method to go here
        @@turn += 1
        Solvable.solve_code
        sleep(1)
      end
      puts "\nYOU WIN!"  if Game.win?
      puts "\nYOU LOSE!" if Game.lose? unless Game.win?
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

  class Creator < Game
    def self.game_start
      puts "Would you like to create the code or guess the code?"
      until @make_or_break == "create" || @make_or_break == "guess"
        puts "Please choose 'create' or 'guess'"
        @make_or_break = gets.chomp
      end

      Mastermind::Game.game_start_codebreaker  if @make_or_break == "guess"
      Mastermind::Game.game_start_codemaker    if @make_or_break == "create"
    end
  end
end

Mastermind::Creator.game_start