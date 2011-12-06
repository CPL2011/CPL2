require_relative 'adameus'

Adameus.new.execute do
  puts version
 #puts airports
  puts connections('VIE', 'BRU', '2012-01-15')
  #puts destinations('BRU')
 
#   puts "startmultihop"
  puts findpath('VIE', 'PEK', [])
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
