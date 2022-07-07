class Knight
  attr_reader :children, :current_value, :parent_value
  MOVES = [[-1, -2], [-1, 2], [1, -2], [1, 2], [-2, -1], [-2, 1], [2, -1], [2, 1]].freeze

  def initialize(current_value, parent_value=nil)
    @current_value = current_value
    @parent_value = parent_value
    @children = []
  end

  def create_children
    @children = MOVES.map do |move_pair|
      move_pair.each_with_index.map do |n, i|
        n + @current_value[i] unless (n + @current_value[i]) < 0 || (n + @current_value[i]) > 7
      end
    end
    @children.delete_if { |move_pair| move_pair.include?(nil)}
  end
end

class GameBoard
  def initialize(start_tile, end_tile)
    @start_tile = start_tile
    @end_tile = end_tile
    @queue = []
    @already_seen = []
    @history = []
    @count = 0
  end

  def search_graph
    current_tile = Knight.new(@start_tile)
    current_tile.create_children
    @queue.push(current_tile)
    until current_tile.current_value == @end_tile
      current_tile.children.each do |tile_value|
        new_child = Knight.new(tile_value, current_tile)
        new_child.create_children
        @queue.push(new_child) unless @already_seen.include?(tile_value)
      end
      @already_seen.push(current_tile.current_value)
      @queue.shift
      current_tile = @queue[0]
    end
    current_tile
  end

  def number_of_turns
    current_tile = self.search_graph
    count = 0
    until current_tile.current_value == @start_tile
      count += 1
      @history.push(current_tile.current_value)
      current_tile = current_tile.parent_value
    end
    @history.push(current_tile.current_value)
    count
  end

  def knight_moves
    self.search_graph
    @count = self.number_of_turns
    @history = @history.reverse
    puts "You made it in #{@count} moves! Here's your path:"
    @history.each { |val| p val}
  end
end

test = GameBoard.new([2, 3], [7, 7])
test.knight_moves