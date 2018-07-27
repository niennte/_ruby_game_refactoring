class Garden
  attr_reader :weeds, :plants, :watering, :mana_balance

  def initialize
    @weeds = 0
    @plants = 0
    @watering = 110
    @mana_balance = 100
  end

  def add_plants (plants = 1)
    consume_mana
    @plants += plants
  end

  def remove_weeds (weeds = 1)
    consume_mana
    @weeds -= weeds
    @weeds = -1 if @weeds < -1
  end

  def add_weeds (weeds = 1)
    @weeds += weeds
  end

  def water
    consume_mana
    @watering += 25
    @watering = 100 if @watering > 100
  end

  def dry
    @watering -= 10
    @watering = 0 if @watering < 0
  end

  def yield_mana
    @mana_balance += 25
    @mana_balance = 100 if @mana_balance > 100
  end

  def state
    "
    *** Your garden has #{@plants} plants and #{@weeds} weeds.
    Soil is #{@watering}% watered. You are #{@mana_balance}% energized.
    "
  end

  def consume_mana(cost = 10)
    @mana_balance -= cost
    @mana_balance = 0 if @mana_balance < 0
  end

end

class Game

  attr_reader :talk

  def initialize
    @garden = Garden.new
    @talk = nil
  end

  def state
    @garden.state
  end

  private

  def meanwhile
    @garden.dry
    @garden.add_weeds
    @talk = '1 new weed grew.'
  end

  def quit
    @talk = 'Goodbye!'
  end

  def water
    @garden.water
    @talk = 'The soil is damp now, good.'
  end

  def plant
    @garden.add_plants
    @talk = '1 new plant grew.'
  end

  def rest
    @garden.yield_mana
    @talk = 'That was nice. Feeling rested now.'
  end

  def weed
    @garden.remove_weeds(5)
    @talk = 'Got rid of some weeds, good.'
  end
end


class UI

  def initialize(moves)
    @rules = moves
  end

  def fetch
    prompt
    collect_input
  end

  def prompt
    puts '- What would you like to do ' + @rules
  end

  def collect_input
    gets.chomp.to_sym
  end

  def try_again
    puts '- Sorry, I didn\'t understand that.'
  end

  def pass(something)
    puts something
  end

end

class GardenGame

  MOVES = {
      q: :quit,
      p: :plant,
      w: :water,
      x: :weed,
      r: :rest
  }

  def initialize
    @game = Game.new
    @ui = UI.new(moves)
    @next_move = nil
  end

  def play
    until @next_move == :quit
      @game.send :meanwhile
      @ui.pass @game.state
      round
    end
  end

  private

  def round
    make_move @ui.fetch
    if @next_move
      @game.send @next_move
      @ui.pass @game.talk
    else
      @ui.try_again
      round
    end
  end

  def make_move(key)
    @next_move = MOVES[key]
  end

  def moves
    MOVES.inspect
  end

end

GardenGame.new.play

