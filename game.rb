VALID_ACTIONS = ['q', 'p', 'w', 'x', 'r']

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

action = nil
num_plants = 0
num_weeds = 0

while action != 'q'
  num_weeds += 1
  puts "A new weed grew."
  puts "There are #{num_plants} plants in you garden and #{num_weeds} weeds."

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
      num_plants += 1
      puts 'A new plant has grown.'
    when 'w'
      puts 'The soil is damp now, good.'
    when 'x'
      num_weeds -= 1
      puts 'Got rid of some weeds, good.'
    when 'r'
      puts 'That was nice. Feeling rested now.'
  end
end
