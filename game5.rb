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


class Game

  VALID_ACTIONS = ['q', 'p', 'w', 'x', 'r']

  def initialize
    @garden = Garden.new
  end

  def get_valid_action
    puts "What would you like to do ('q': quit, 'p': plant, 'w': water, 'x': weed, 'r': rest)"
    validate( action = gets.chomp ) || try_again
  end

  def validate(action)
    VALID_ACTIONS.detect{ |valid_action| valid_action == action}
  end

  def try_again
    puts "Sorry, I didn't understand that."
    get_valid_action
  end

  def play
    action = nil

    while action != 'q'
      @garden.add_weeds
      puts 'A new weed grew.'
      puts @garden

      action = get_valid_action

      while !['q', 'p', 'w', 'x', 'r'].include? action
        puts "Sorry, I didn't understand that."
        puts "What would you like to do ('q': quit, 'p': plant, 'w': water, 'x': weed, 'r': rest)"
        action = gets.chomp
      end

      case action
        when 'q'
          puts 'goodbye'
        when 'p'
          @garden.add_plants
          puts 'A new plant has grown.'
        when 'w'
          puts 'The soil is damp now, good.'
        when 'x'
          @garden.remove_weeds(2)
          puts 'Got rid of some weeds, good.'
        when 'r'
          puts 'That was nice. Feeling rested now.'
      end
    end
  end
end

Game.new.play

