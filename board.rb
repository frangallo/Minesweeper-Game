require_relative 'tile'
class Board
  attr_accessor :grid
  DIRECTIONS = [-1,0,1].repeated_permutation(2).to_a.reject { |el| el == [0,0]}

  def [](pos)
    row, col = pos
    grid[row][col]
  end

  def []=(pos, mark)
    row, col = pos
    grid[row][col] = mark
  end

  def initialize
    @grid = Array.new(9) { Array.new (9)}
    bomb_placer
    count_placer
  end

  # def generate_board
  #   (0..9).each do |row|
  #    (0..9).each do |col|
  #      self[[row,col]] = Tile.new(self, self[[row,col]])
  #    end
  #  end
  # end

  def bomb_placer_generation
    bomb_positions = []

    while bomb_positions.length < 10
      position = [rand(9),rand(9)]
      bomb_positions << position unless bomb_positions.include?(position)
    end
    bomb_positions
  end

  def bomb_placer
    bomb_positions = bomb_placer_generation

    bomb_positions.each do |coord|
      self[coord] = Tile.new(self, "b",coord)
    end
    grid
  end

  def count_placer
    (0..8).each do |row|
     (0..8).each do |col|
       unless self[[row,col]].is_a?(Tile)
          self[[row,col]] = Tile.new(self,bomb_counter(row,col),[row,col])
       end
     end
   end
 end

   def make_move(coord_input,action_input)
      self[coord_input].reveal if action_input == 'r'
      self[coord_input].flag if action_input == 'f'
  end

 def bomb_counter(row,col)
   count = 0
   DIRECTIONS.each do |coord|
     rel_pos = [row+coord.first,col+coord.last]

     if rel_pos.all? { |x| x.between?(0,8) }

      count += 1 if self[rel_pos].is_a?(Tile) && self[rel_pos].value == 'b'
     end
   end
   count
 end

 def display
   (0..8).each do |row|
    (0..8).each do |col|
      print "#{self[[row,col]].inspect} "
    end
    puts
  end
  end

  def display_answer
    (0..8).each do |row|
     (0..8).each do |col|
       print "#{self[[row,col]].value} "
     end
     puts
   end
 end

end
