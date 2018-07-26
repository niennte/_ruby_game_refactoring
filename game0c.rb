action = nil
while true
  puts "What would you like to do ('q': quit, 'p': plant, 'w': water, 'x': weed, 'r': rest)"
  action = gets.chomp

  case action
    when 'q' then puts 'goodbye'
    when 'p' then puts 'A new plant has grown.'
    when 'w' then puts 'The soil is damp now, good.'
    when 'x' then puts 'Got rid of some weeds, good.'
    when 'r' then puts 'That was nice. Feeling rested now.'
  end
end
