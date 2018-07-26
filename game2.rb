action = nil
num_plants = 0
num_weeds = 0

while action != 'q'
  num_weeds += 1
  puts "There are #{num_plants} plants in you garden and #{num_weeds} weeds."
  puts "What would you like to do ('q': quit, 'p': plant, 'w': water, 'x': weed, 'r': rest)"
  action = gets.chomp

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
