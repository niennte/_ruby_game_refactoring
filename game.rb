class Garden
  attr_reader :weeds, :plants, :watering, :mana_balance

  def initialize(weeds: required, plants: required, watering: required, mana_balance: required)
    @weeds = weeds
    @plants = plants
    @watering = watering
    @mana_balance = mana_balance
  end

  def plant(num)
    @plants += num
    @plants = -1 if @plants < -1
  end

  def weed(num)
    @weeds += num
    @weeds = -1 if @weeds < -1
  end

  def water(percents)
    @watering += percents
    @watering = 0 if @watering < 0
    @watering = 100 if @watering > 100
  end

  def mana(percents)
    @mana_balance += percents
    @mana_balance = 100 if @mana_balance > 100
    @mana_balance = -5 if @mana_balance < -5
  end

  def state
    "
    *** Your garden has #{@plants} plants and #{@weeds} weeds.
    Soil is #{@watering}% watered. Your mana level is #{@mana_balance}%.
    "
  end

  private

  def required
    raise ArgumentError('Missing required argument.')
  end

end

class Game

  attr_reader :talk, :over

  GARDEN_CAPACITY = 30
  WIN_POINT = 20

  def initialize
    @garden = Garden.new(watering: 100, mana_balance: 100, plants: 0, weeds: 0)
    @talk = nil
    @over = false
  end

  def state
    @over || @garden.state
  end

  def assess
    if @garden.watering == 0
      plants = -1
      @garden.plant(plants)
      @talk = "#{plants.abs} plant dried."
    end
    if @garden.plants == -1
      @over = "
      #{@garden.state}
      ***
      Failure. All your plants dried!
      ***
      " #
    end
    if @garden.mana_balance == 0
      @over = "
      #{@garden.state}
      ***
      Failure. You are exhausted!
      ***
      " #
    end
    if @garden.weeds >= WIN_POINT
      @over = "
      #{@garden.state}
      ***
      Failure. Weeds took over your garden!
      ***
      " #
    end
    if @garden.plants >= WIN_POINT
      @over = "
      #{@garden.state}
      ***
      VICTORY!!! Your grew a perfect garden!
      ***
      "
    end
  end

  def help
    @talk = <<TEXT

Gardening Challenge rules:

- The goal is to plant #{WIN_POINT} plants in the garden.
- Garden can contain the maximum of #{GARDEN_CAPACITY} plants or weeds.
- Plants grow when planted (p), weeds grow by themselves each round.
- Weeds can be removed by weeding (x), to make space for the plants.
- Soil needs to be watered (w) for plants to stay alive.
- If soil is completely without water, plants start drying away each round.
- Gardener (you!) needs enough energy to work, called mana.
- Each action (planting, weeding, watering) costs mana.
- Small amount of mana gets replenished each round (through night's sleep).
- Mana can get a powerful boost through enjoying the garden, or resting (r).
- Each round player has a choice of 4 moves: p: plant, w: water, x: weed, and r: rest.
- You may also view rules help (h), or quit the game (q)
- Each round, game reports state of garden, and resources: Number of plants and weeds, and levels of water in soil and gardener's energy in percents.
- The game is lost when all plants dry, or the gardener burns out and gives up.
- The game is also lost if weeds take over the garden (grow #{WIN_POINT} or more)
- The garden is perfect when it has #{WIN_POINT} plants (a small number of weeds is a fact of life).
- When the garden is perfect, the game is won!
- Grow plants, while keeping weeds under control, soil well watered, and the gardener (you) well rested.

Good luck, and may you make wise choices!
TEXT
  end

  private

  def meanwhile
    @talk = '
    ***
    Meanwhile:
    '
    weeds = 1
    watering = -10
    mana = 5
    @garden.mana(mana)
    @garden.water(watering)
    if @garden.weeds + @garden.plants >= GARDEN_CAPACITY
      @talk += "#{weeds} new weed tried to grow but found no space.
    Soil dried by #{watering.abs}%. Gained #{mana}% mana."
    else
      @garden.weed(weeds)
      @talk += "#{weeds} new weed grew.
    Soil dried by #{watering.abs}%. Gained #{mana}% mana."
    end
    @talk += '
    ***'
  end

  def quit
    @garden = nil
    @talk = '
  *** Goodbye!'
  end

  def water
    watering = 25
    mana = -15
    @garden.mana(mana)
    @garden.water(watering)
    @talk = "
  *** The soil is damp now, good. Watered #{watering}% better. Spent #{mana.abs}% mana."
  end

  def plant
    plants = 1
    mana = -15
    watering = -10
    @garden.mana(mana)
    if @garden.weeds + @garden.plants >= GARDEN_CAPACITY
      @talk = "
    *** #{plants} new plant tried to grow but found no space. Soil dried by #{watering.abs}%. Spent #{mana.abs}% mana."
    else
      @garden.plant(plants)
      @talk = "
    *** #{plants} new plant grew. Spent #{mana.abs}% mana."
    end
  end

  def weed
    weeds = -5
    mana = -15
    @garden.mana(mana)
    @garden.weed(weeds)
    @talk = "
  *** Got rid of #{weeds.abs} weeds, good. Spent #{mana.abs}% mana."
  end

  def rest
    mana = 25
    @garden.mana(mana)
    @talk = "
  *** That was nice. Feeling rested now. Regained #{mana}% mana."
  end
end


class UI

  def initialize(moves: nil, answers: nil)
    @moves = moves
    @answers = answers
  end

  def capture(what)
    prompt what
    collect
  end

  def wonder
    puts '
    - Sorry, I didn\'t understand that.'
  end

  def render(something)
    puts something
  end

  private

  def prompt(what)
    if what == :move
      puts '- Make a move: ' + @moves
    end
    if what == :restart
      puts '- Play again? ' + @answers
    end
  end

  def collect
    gets.chomp.to_sym
  end

end


class GardenGame

  MOVES = {
    p: :plant,
    w: :water,
    x: :weed,
    r: :rest,
    h: :help,
    q: :quit
  }

  ANSWERS = {
    y: :yes,
    n: :no
  }

  def initialize
    @game = Game.new
    @ui = UI.new(moves: prettify(MOVES), answers: prettify(ANSWERS))
    @move = nil
  end

  def play
    @ui.render '
    Welcome Gardener!
    You can view game rules by calling help (h)
    May your garden prosper!
    '
    until @game.over || @move == :quit
      if @move
        @game.send :meanwhile
        @ui.render @game.talk
      end
      @game.assess
      @ui.render @game.state
      if @game.over
        restart
      else
        round
      end
    end
  end

  def help
    @ui.render @game.rules
  end

  private

  def round
    next_move? @ui.capture :move
    if @move
      @game.send @move
      @ui.render @game.talk
    else
      @ui.wonder
      round
    end
  end

  def restart
    case restart? @ui.capture :restart
      when :yes
        @game = Game.new
        @move = nil
      when :no
        @move = :quit
        @game.send @move
        @ui.render @game.talk
      else
        @ui.wonder
        restart
    end
  end

  def next_move?(key)
    @move = MOVES[key]
  end

  def restart?(key)
    ANSWERS[key]
  end

  def prettify(hash)
    hash.map { |key, val|
      key.to_s + ': ' + val.to_s
    }.join(', ')
  end

end

GardenGame.new.play

