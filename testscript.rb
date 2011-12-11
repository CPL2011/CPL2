require_relative 'adameus'

Adameus.new.execute do
  #version
 #puts airports
  puts connections('VIE', 'BRU', '2012-01-15')
  #puts destinations('BRU')

# puts MultiHop.new.findHops('PEK', 'AKL')
 reservation = hold("2011-11-05", "BEL062", "B", "M", "John", "Doe")
 puts book(reservation[1,reservation.size-2])

#   puts "startmultihop"
  #puts findpath('VIE', 'PEK', [])
#   flight('VIE', 'FCO', '2012-01-15').each do |x|
#     puts("------------------")
#     puts x
#     puts("------------------")
#   end
#   puts "endmultihop"
end

=begin
  Example queries:
  airports
  connections('VIE', 'BRU', '2012-01-15'), also connections(:VIE, :BRU, '2012-01-15')
  seats('2012-01-15', 'BEL062', 'B'), also seats('2012-01-15', :BEL062, :B)
  
  To exit interactive mode, enter query 'exit'.
=end

#Adameus.new.repl
