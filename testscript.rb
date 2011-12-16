require_relative 'adameus'

$adameus = Adameus.new

puts "\nadameus.version"
puts $adameus.version

puts "\nadameus.airlines"
puts $adameus.airlines

puts "\nadameus.airports"
puts $adameus.airports

puts "\nadameus.connections(\"VIE\", \"BRU\", \"2012-01-15\")"
puts $adameus.connections("VIE", "BRU", "2012-01-15")

puts "\nadameus.weekdays(\"Whrong FlightNumber\")"
$adameus.weekdays("Whrong FlightNumber")

#puts "\nadameus.hold_cheapest(\"2012-01-15\", \"TEG\", \"AKL\",  \"B\", \"M, Edsger, Dijkstra\", \"M, John, McCarthy\")"
#puts $adameus.hold_cheapest("2012-01-15", "TEG", "AKL",  "B", "M, Edsger, Dijkstra", "M, John, McCarthy")
#puts $adameus.book("tralalalalal")