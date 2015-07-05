class Tile
  attr_reader :board, :position
  attr_accessor :value, :flagged, :bombed, :revealed
  DIRECTIONS = [-1,0,1].repeated_permutation(2).to_a.reject { |el| el == [0,0]}

  def initialize(board, value, position, revealed = false, flagged = false)
    @board = board
    @value = value
    @flagged = flagged
    @revealed = revealed
    @position = position
    @bombed = false
  end

  def inspect
    if flagged
      'F'
    elsif revealed
      value.to_s
    elsif bombed
      'b'
    else
      '*'
    end
  end

  def reveal
    self.bombed = true if value == 'b'
    self.revealed = true unless value == 'b'


    if self.value == 0
      DIRECTIONS.each do |coord|
        rel_pos = [position.first + coord.first, position.last + coord.last]
        if rel_pos.all? { |x| x.between?(0,8) }
          board[rel_pos].reveal unless board[rel_pos].revealed
        end
      end
    end
    value
  end

  def flag
    flagged == true ? self.flagged = false : self.flagged = true
  end

end
