require_relative 'board'
require 'yaml'

class Minesweeper
  attr_accessor :board

  def self.load_game
    puts "Welcome to Minesweeper. Good luck!"
    if load_input
      Minesweeper.new(load_file).play
    else
      Minesweeper.new.play
    end
  end

  def initialize(game = nil)
    # game.nil? ? @board = Board.new : @board = game
    @board = (game.nil? ? Board.new : game)
  end

  def play
    board.display_answer
    until winner? || loser?
      board.display
      save_file if save_input
      board.make_move(coord_input,action_input)
      # sleep(1)
      # system('clear')
    end
    puts "You won!" if winner?
    puts "You lost!" if loser?
    board.display
  end

  def winner?
    board.grid.all? do |rows|
      rows.all? do |el|
        el.revealed || (el.value == 'b' && el.flagged)
      end
    end
  end

  def loser?
    board.grid.each do |rows|
      rows.any? do |el|
        return true if el.bombed
      end
    end
    false
  end

  def coord_input
    print "Please enter coordinates: "
    gets.chomp.split(",").map(&:to_i)
  end

  def action_input
    print "Please enter F to Flag, or R to Reveal: "
    gets.chomp.downcase
  end

  def save_input
    print "Please enter 's' to save & quit "
    input = gets.chomp.downcase

    if input == 's'
      return true
    else
      return false
    end
  end

  def save_file
    saved_game = board.to_yaml
    File.open("game_saved.txt","w") {|g| g.puts saved_game}
    puts "File Saved"
    exit
  end

  def self.load_input
    print "Please enter 'l' to load previous save file "
    input = gets.chomp.downcase

    if input == 'l'
      return true
    else
      return false
    end
  end

  def self.load_file
    board = YAML::load(File.read("game_saved.txt"))
  end
end

g = Minesweeper.load_game
