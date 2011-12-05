require_relative 'adameus'

Adameus.new.execute do
  puts version
  puts connections('VIE', 'BRU', '2012-01-15')
end

=begin
  Example queries:
  airports
  connections('VIE', 'BRU', '2012-01-15'), also connections(:VIE, :BRU, '2012-01-15')
  seats('2012-01-15', 'BEL062', 'B'), also seats('2012-01-15', :BEL062, :B)
  
  To exit interactive mode, enter query 'exit'.
=end

Adameus.new.repl
