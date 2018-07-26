class Garden
  attr_reader :weeds, :plants

  def initialize
    @weeds = 0
    @plants = 0
  end

  def add_plants (plants =1)
    @plants += plants
  end

  def remove_weeds (weeds = 1)
    @weeds -= weeds
    @weeds = @weeds < -1 ?  -1 : @weeds
  end

  def add_weeds (weeds = 1)
    @weeds += weeds
  end

  def to_s
    "Your garden has #{@plants} plants and #{@weeds} weeds."
  end
end

class Action

  attr_reader :current

  def initialize(garden)
    @garden = garden
    @current = nil
  end

  def handle(action)
    @current = (self.respond_to? action) ? action : nil
    self.send @current unless @current.nil?
  end

  def quit
    puts 'Goodbye!'
  end

  def water
    puts 'The soil is damp now, good.'
  end

  def plant
    @garden.add_plants
    puts 'A new plant has grown.'
  end

  def rest
    puts 'That was nice. Feeling rested now.'
  end

  def weed
    @garden.remove_weeds(2)
    puts 'Got rid of some weeds, good.'
  end
end


class Game

  ACTIONS = {
      q: :quit,
      p: :plant,
      w: :water,
      x: :weed,
      r: :rest
  }
  VALID_CHOICES = ACTIONS.keys

  def initialize
    @garden = Garden.new
    @action = Action.new(@garden)
  end

  def prompt_for_input
    puts "What would you like to do ('q': quit, 'p': plant, 'w': water, 'x': weed, 'r': rest)"
    user_choice = gets.chomp.to_sym
    handle_input(user_choice)
  end

  def handle_input(user_choice)
    valid_input? user_choice ? @action.handle(ACTIONS[user_choice]) : try_again
  end

  def valid_input?(user_choice)
    VALID_CHOICES.detect{ |valid_choice| valid_choice == user_choice }
  end

  def try_again
    puts "Sorry, I didn't understand that."
    get_valid_action
  end

  def play
    while @action.current != :quit
      @garden.add_weeds
      puts 'A new weed grew.'
      puts @garden
      prompt_for_input
    end
  end
end

Game.new.play

