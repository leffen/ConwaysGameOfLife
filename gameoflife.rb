# encoding: utf-8
require 'rubygems'
require 'test/unit'
require 'pp'




class Game
  attr_accessor :grid
  NEIGBOUR_COORDINATES=  [[-1,-1],[0,-1],[1,-1],
                          [-1,0],        [1,0],
                          [-1,1], [0,1], [1,1]]

  # alive_cells = array with alvie cells. Format = [[x,y],[x,y]]
  def initialize(alive_cells)
    init_grid(alive_cells)
  end

  def init_grid(alive_cells)
    @grid={}
    alive_cells.each{|e|@grid[e]=1}
  end

  def is_alive?(cell)
    @grid.has_key?(cell)
  end

  def neigbour_count(cell)
    cnt = 0
    NEIGBOUR_COORDINATES.each {|koordinates|
      celle = [cell[0]+koordinates[0],cell[1]+koordinates[1]]
      cnt += is_alive?(celle) ? 1 :0
    }
    cnt
  end

  # rules 1,2,3
  def find_surviviors
    @grid.each_with_object([]){ |cell,obj|
      cnt = neigbour_count(cell[0])
      obj << cell[0] if (cnt >1) and (cnt <4)
    }
  end

  # rule 4
  def find_new_cells
    candidates ={}

    @grid.each_with_object([]){ |cell,obj|
      NEIGBOUR_COORDINATES.each {|koordinates|
         potenintial_cell = [cell[0][0]+koordinates[0],cell[0][1]+koordinates[1]]
         candidates[potenintial_cell] = neigbour_count(potenintial_cell) if !candidates.has_key?(potenintial_cell) && !@grid.has_key?(potenintial_cell)
      }
    }
    candidates.select{|k,v|v==3}.each_with_object([]){|element,obj|obj<<element[0]}
  end

  # generate next "generation"
  def next_generation
   find_surviviors + find_new_cells
  end

  # advance to next level
  def tick
    init_grid(next_generation)
  end

  def to_array
    @grid.each_with_object([]){|element,obj|obj<<element[0]}.sort{|a,b|a[1]+a[0]/1000<=>b[1]+b[0]/1000}
  end

  # Simple print out of grid
  def print_grid
    element = find_grid_max

    (1..element[1]+1).each{|y|
      (1..element[0]+1).each{|x|
        print is_alive?([x,y]) ? '*' :'.'
      }
      print "\n"
    }
  end

  # Find the size of the current grid, [0,0] is assumed as starting point
  def find_grid_max
    [0,0]
    exit unless @grid.count >0

    x_max = @grid.max_by{|k,e|k[0]}
    y_max = @grid.max_by{|k,e|k[1]}
    [x_max[0][0],y_max[0][1]]
  end

end




class GameOfLifeTest < Test::Unit::TestCase
  TEST_OSICLLATOR = [[2,2],[2,3],[2,4]]
  TEST_OSICLLATOR_G1 = [[1,3],[2,3],[3,3]]


  def setup

  end

  def teardown
    ## Nothing really
  end

  def test_game_of_life_oscillator_1
    game = Game.new(TEST_OSICLLATOR)

    TEST_OSICLLATOR.each{|cell| assert_not_nil  game.is_alive?(cell) }

    assert_equal [2,4],game.find_grid_max

    game.tick
    game.print_grid
    # assert_equal TEST_OSICLLATOR_G1,game.to_array

    game.tick
    game.print_grid
    # assert_equal TEST_OSICLLATOR,game.to_array
  end

  def test_game_of_life_zero_elements
    game = Game.new([])
    assert(game.find_grid_max ===[0,0],"Bør nok returnere [0,0] og ikke #{game.find_grid_max}")
  end

  def test_check_neigbour
    game = Game.new([[1,1],[3,4]])

    assert_equal game.neigbour_count([1,1]),0
    assert_equal game.neigbour_count([0,0]),1
    assert_equal game.neigbour_count([10,10]),0

    # todo: test all variations

  end


  def test_find_survivors
    # Starter med enkel oscillator
    start = [[2,2],[2,3],[2,4]]
    game =Game.new(start)
     x = game.find_surviviors

    assert_equal 1,x.count
    assert_not_nil x.index([2,3])
  end




  def test_find_new_cells
    start = [[2,2],[2,3],[2,4]]
    game =Game.new(start)
    new_cells = game.find_new_cells

    assert_equal 2, new_cells.count
    assert_not_nil  new_cells.index([1,3])
    assert_not_nil  new_cells.index([3,3])
  end




end