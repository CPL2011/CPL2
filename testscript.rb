require_relative 'adameus'

$adameus = Adameus.new

puts "\nadameus.version"
puts $adameus.version

puts "\nadameus.airlines"
puts $adameus.airlines

puts "\nadameus.airports"
puts $adameus.airports

puts "\nadameus.destinations(\"BRU\")"
puts $adameus.destinations("BRU")

puts "\nadameus.connections(\"VIE\", \"BRU\", \"2012-01-15\")"
puts $adameus.connections("VIE", "BRU", "2012-01-15")

puts "\nflight_airports(\"BEL062\")"
puts $adameus.flight_airports("BEL062")

puts "\nadameus.weekdays(\"Wrong FlightNumber\")"
puts $adameus.weekdays("Wrong FlightNumber")

puts "\nadameus.weekdays(\"SJT208\")"
puts $adameus.weekdays("SJT208")

puts "\nadameus.seats(\"2012-01-15\", \"SJT208\", \"B\")"
puts $adameus.seats("2012-01-15", "SJT208", "B")
#puts "\nadameus.hold_cheapest(\"2012-01-15\", \"TEG\", \"AKL\",  \"B\", \"M, Edsger, Dijkstra\", \"M, John, McCarthy\")"
#puts $adameus.hold_cheapest("2012-01-15", "TEG", "AKL",  "B", "M, Edsger, Dijkstra", "M, John, McCarthy")
#puts $adameus.book("tralalalalal")