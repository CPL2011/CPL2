require_relative 'adameus'

a = Adameus.new

=begin
  example queries:
  airports
  connections('VIE', 'BRU', '2012-01-15'), also connections(:VIE, :BRU, '2012-01-15')
  seats('2012-01-15', 'BEL062', 'B'), also seats('2012-01-15', :BEL062, :B)
=end

a.repl