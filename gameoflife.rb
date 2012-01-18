# encoding: utf-8
require 'rubygems'
require 'test/unit'
require 'pp'




class Game
  attr_accessor :grid

  def initialize(start_brett)
    @grid={}
    start_brett.each{|e|@grid[e]=1}
  end

  def neigbour_cell_coordinates
    [[-1,-1],[0,-1],[1,-1],
     [-1,0],        [1,0],
     [-1,1], [0,1], [1,1]]
  end

  def is_alive?(celle)
    @grid.has_key?(celle)
  end

  def neigbours(cell)
    cnt = 0
    neigbour_cell_coordinates.each {|koordinates|
      celle = [cell[0]+koordinates[0],cell[1]+koordinates[1]]
      cnt += is_alive?(celle) ? 1 :0
    }
    cnt
  end

  def find_surviviors
    @grid.each_with_object([]){ |cell,obj|
      cnt = neigbours(cell[0])
      obj << cell[0] if (cnt >1) and (cnt <4)
    }
  end

  def find_new_cells
    candidates ={}

    @grid.each_with_object([]){ |cell,obj|
      neigbour_cell_coordinates.each {|koordinates|
         celle = [cell[0][0]+koordinates[0],cell[0][1]+koordinates[1]]
         candidates[celle] = neigbours(celle) if !candidates.has_key?(celle) && !@grid.has_key?(celle)
      }
    }
    candidates.select{|k,v|v==3}.each_with_object([]){|element,obj|obj<<element[0]}
  end

  def next_generation
    surviors = find_surviviors
    new_born = find_new_cells

    surviors + new_born
  end

  def tick

  end

  def find_grid_max
    [0,0]
    exit unless @grid.count >0

    x_max = @grid.max_by{|k,e|k[0]}
    y_max = @grid.max_by{|k,e|k[1]}
    [x_max[0][0],y_max[0][1]]
  end


  def skriv
    element = find_grid_max

    (1..element[1]+1).each{|y|
      (1..element[0]+1).each{|x|
        print is_alive?([x,y]) ? '*' :'.'
      }
      print "\n"
    }
  end

end




class GameOfLifeTest < Test::Unit::TestCase

  def setup

  end

  def teardown
    ## Nothing really
  end

  def test_x
    puts "test_next_generation"

    start = [[2,2],[2,3],[2,4]]
    game = Game.new(start)
    grid = game.next_generation
    game.skriv

    g2 = Game.new(grid)
    g2.skriv


  end

  def test_tt
    puts "tt"
  end



  def test_game_of_life
    puts "test_game_of_life"
    # Starter med enkel oscillator
    start = [[2,2],[2,3],[2,4]]

    game =Game.new(start)
    start.each{|celle| assert_not_nil  game.is_alive?(celle) }
    assert_equal [2,4],game.find_grid_max

    nextgen =  game.next_generation
    pp nextgen



  end

  def test_game_of_life_zero_elements
    puts "test_game_of_life_zero_elements"
    game = Game.new([])
    assert(game.find_grid_max ===[0,0],"Bør nok returnere [0,0] og ikke #{game.find_grid_max}")
  end

  def test_check_neigbour
    puts "test_check_neigbour"
    game = Game.new([[1,1],[3,4]])

    assert_equal game.neigbours([1,1]),0
    assert_equal game.neigbours([0,0]),1
    assert_equal game.neigbours([10,10]),0

    # todo: test all variations

  end


  def test_find_survivors
    puts "test_find_survivors"
    # Starter med enkel oscillator
    start = [[2,2],[2,3],[2,4]]
    game =Game.new(start)
     x = game.find_surviviors

    assert_equal 1,x.count
    assert_not_nil x.index([2,3])
  end




  def test_find_new_cells
    puts "test_find_new_cells"
    start = [[2,2],[2,3],[2,4]]
    game =Game.new(start)
    new_cells = game.find_new_cells

    assert_equal 2, new_cells.count
    assert_not_nil  new_cells.index([1,3])
    assert_not_nil  new_cells.index([3,3])
  end




end