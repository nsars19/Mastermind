module Classable
  class Board
    attr_accessor :display, :row_contents
    attr_reader :code, :colors

    def initialize
      @colors = %w[red orange yellow green blue purple]
      @row_contents = []
    end

    def display_board

    end

    private
    def create_code *colors
      @code = colors[0..3]
    end

    def create_row
      4.times do
        @row_contents << @colors[rand(6)]
      end
    end
  end

  class Row < Board
  end

  class FeedbackPegs
  end
end