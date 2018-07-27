class Garden
  attr_reader :weeds, :plants, :watering, :mana_balance

  def initialize(weeds: 0, plants: 0, watering: 110, mana_balance: 100)
    @weeds = weeds
    @plants = plants
    @watering = watering
    @mana_balance = mana_balance
  end

  def add_plants (plants)
    @plants += plants
  end

  def remove_plants (num)
    @plants -= num
    @plants = -1 if @plants < -1
  end

  def remove_weeds (weeds)
    @weeds -= weeds
    @weeds = -1 if @weeds < -1
  end

  def add_weeds (weeds)
    @weeds += weeds
  end

  def water(percents)
    @watering += percents
    @watering = 100 if @watering > 100
  end

  def dry(percents)
    @watering -= percents
    @watering = 0 if @watering < 0
  end

  def yield_mana(percents)
    @mana_balance += percents
    @mana_balance = 100 if @mana_balance > 100
  end

  def state
    "
    *** Your garden has #{@plants} plants and #{@weeds} weeds.
    Soil is #{@watering}% watered. Your mana level is #{@mana_balance}%.
    "
  end

  def consume_mana(cost)
    @mana_balance -= cost
    @mana_balance = -5 if @mana_balance < -5
  end

end

class Game

  attr_reader :talk, :over

  def initialize
    @garden = Garden.new
    @talk = nil
    @over = false
  end

  def state
    @over || @garden.state
  end

  def assess
    if @garden.watering == 0
      @garden.remove_plants(1)
      @talk = '1 plant dried.'
    end
    if @garden.plants == -1
      @over = 'All plants dried!'
    end
    if @garden.mana_balance == 0
      @over = 'You are exhausted!'
    end
  end

  private

  def meanwhile
    weeds = 1
    watering = 10
    mana = 5
    @garden.dry(watering)
    @garden.add_weeds(weeds)
    @garden.yield_mana(mana)
    @talk = "#{weeds} new weed grew. Soil dried by #{watering}%. Gained #{mana}% mana."
  end

  def quit
    @garden = nil
    @talk = 'Goodbye!'
  end

  def water
    watering = 25
    mana = 15
    @garden.consume_mana(mana)
    @garden.water(watering)
    @talk = "The soil is damp now, good. Watered #{watering}% better. Spent #{mana}% mana."
  end

  def plant
    plants = 1
    mana = 15
    @garden.consume_mana(mana)
    @garden.add_plants(plants)
    @talk = "#{plants} new plant grew. Spent #{mana}% mana."
  end

  def weed
    weeds = 5
    mana = 15
    @garden.consume_mana(mana)
    @garden.remove_weeds(weeds)
    @talk = "Got rid of #{weeds} weeds, good. Spent #{mana}% mana."
  end

  def rest
    mana = 25
    @garden.yield_mana(mana)
    @talk = "That was nice. Feeling rested now. Regained #{mana}% mana."
  end
end


class UI

  def initialize(moves)
    @moves = moves
  end

  def capture
    prompt
    collect
  end

  def wonder
    puts '- Sorry, I didn\'t understand that.'
  end

  def transmit(something)
    puts something
  end

  private

  def prompt
    puts '- Please make a move: ' + @moves
  end

  def collect
    gets.chomp.to_sym
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
    @move = nil
  end

  def play
    until @game.over || @move == :quit
      @game.send :meanwhile
      @game.assess
      @ui.transmit @game.state
      round unless @game.over
    end
  end

  private

  def round
    player_move @ui.capture
    if @move
      @game.send @move
      @ui.transmit @game.talk
    else
      @ui.wonder
      round
    end
  end

  def player_move(key)
    @move = MOVES[key]
  end

  def moves
    MOVES.inspect
  end

end

GardenGame.new.play

