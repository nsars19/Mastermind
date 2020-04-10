class Mastermind
  class Board
    attr_accessor :code
    attr_reader :board, :board_feedback

    def initialize
      @@colors = %w[red orange yellow green blue purple]
      @@color_index = Hash.new(0)
      @board = []
      @code = Array.new(4, nil)
      @code_num = []
      @board_feedback = []
      Board.populate_color_index
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
      @board_feedback << feedback_holder#.sort!.reverse!
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
    
    def create_code_player *colors
      @code = colors[0].split
      @@color_index.each do |k, v|
        colors[0].split.each do |e|
          @code_num << k if e == v
        end
      end
    end
    
    def create_code_cpu
      4.times { |i| @code[i] = @@colors[rand(6)] }
      @@color_index.each do |k, v|
        colors[0].split.each do |e|
          @code_num << k if e == v
        end
      end
    end

    def color_index
      @@color_index
    end
    
    def cpu_better_guess
      last_guess = @board[-1]
      next_guess = Array.new(4, nil)
      right_color = []
      multiples = []
      position_set = Array.new(4, false)
      colors_remaining = @@colors

      last_guess.each_with_index do |e, i|
        if @code[i] == e
          next_guess[i] = e
          position_set[i] = true
        elsif @code.count(e) < last_guess.count(e) && @code.include?(e)
          multiples << e unless position_set[i]
        else 
          right_color << e if @code.include?(e)
        end
        colors_remaining -= [e] if !@code.include?(e)
      end

      multiples.uniq.each { |e| right_color << e }
      next_guess.count(nil).times do |i|
        next_guess[i] = right_color.shuffle[i] if next_guess[i] == nil
      end

      until next_guess.all? { |e| e != nil }
        cr_length = colors_remaining.length
        nil_idx = next_guess.index(nil)
        next_guess[nil_idx] = colors_remaining[rand(cr_length)]
      end

      p next_guess
      p "#{multiples}"
      p "#{right_color}"
      @board << next_guess
    end

    private
    def self.populate_color_index
      @@colors.each_with_index { |e, i| @@color_index[i] = e }
    end
  end

  class Game < Board
    ROUNDS = 12

    def self.game_start_codebreaker
      @game = Board.new
      @@turn = 0
      @game.create_code_cpu
      #@game.code = %w[red red blue blue]
      puts @game.code #### REMOVE ME WHEN FINISHED
      until Game.over?
        puts "Enter your guess:"
        @game.create_guess(gets.chomp.split[0..3])
        @game.feedback(@game.board[-1])
        @game.display_board
        @@turn += 1
      end
      puts "\nYOU WIN!"  if Game.win?
      puts "\nYOU LOSE!" if Game.lose? unless Game.win?
    end

    def self.game_start_codemaker
      @game = Board.new
      @@turn = 1
      puts "Please select four colors from the list:\n#{@@colors.join(', ')}"
      @game.create_code_player(gets.chomp)
      p @game.code #### REMOVE ME WHEN FINISHED
      @game.create_guess_cpu
      until Game.over?
        @game.feedback(@game.board[-1])
        @game.display_board
        @game.cpu_better_guess
        @@turn += 1
        sleep(0.5)
      end
      @game.feedback(@game.board[-1])
      @game.display_board
      puts "\nCOMPUTER WINS!"  if Game.win?
      puts "\nCOMPUTER LOSES!" if Game.lose? unless Game.win?
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

  class Cpu < Game
    def initialize
      @@possible_codes = []
    end

    def self.solve_code
      @game = Board.new
      @game.create_code_cpu
      @game.create_guess_cpu
      @game.feedback(@game.board[-1])
    end

    def self.create_codeset
      @@possible_codes = []
      ci = @@color_index
      # Create set of all possible codes
      6.times do |i_1|
        6.times do |i_2|
          6.times do |i_3|
            6.times do |i_4|
              @@possible_codes << [ci[i_1], ci[i_2], ci[i_3], ci[i_4]]
            end
          end
        end
      end
      @@possible_codes
    end

    def self.compare_feedback
      Cpu.new
      @game = Board.new
      initial_feedback = @game.feedback(Cpu.first_guess)
      same_feedback = []
      @@possible_codes.each do |e|
        same_feedback << e if @game.feedback(e) == initial_feedback
      end
      p same_feedback
    end

    def self.first_guess
      %w[red red orange orange]
    end
  end

  class Creator < Game
    def self.game_start
      puts "Would you like to create the code or guess the code?"
      until @make_or_break == "create" || @make_or_break == "guess"
        puts "Please choose 'create' or 'guess'"
        @make_or_break = gets.chomp
      end

      Game.game_start_codebreaker if @make_or_break == "guess"
      Game.game_start_codemaker   if @make_or_break == "create"
    end
  end
end

Mastermind::Creator.game_start