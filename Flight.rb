
#require_relative 'Airport'
require_relative 'Date'
require_relative 'adameus'
# The Flight class represents a single, direct flight between two airports
class Flight
  attr_reader :flightCode, :date, :adameus, :departureTime, :flightDuration, :departureAirport, :destinationAirport, :seats

  def initialize(connCode, date)
    @flightCode = connCode[0,6]
    if (date.class.to_s.eql?("Date"))
        @date = date
    else
        @date = Date.new(date, nil)
    end
    @departureTime = MyTime.new(connCode[6,5])
    @flightDuration = MyTime.new(connCode[11,5])
    @departureAirport = nil
    @destinationAirport = nil
    @adameus = Adameus.new 
    @seats = 0
  end

  # Returns the cost of a seat on this flight if there is still room for another
  # passenger, in all other cases nil gets returned.
  # Prices change all the time, thus every time the price for a particular seat on
  # this flight is requested a new database call is made.
  # NOTE TO SELF: curiously enough the call to .to_s for date is not required 
  def price(seatClass)
    seatInfo = adameus.seats(date, flightCode, seatClass).chomp
    #puts seatInfo
    if (seatInfo.size != 8) then return nil end 
    @seats = seatInfo[0,3]
    seatCost = seatInfo[3,5]
    if (@seats.to_i < 1) then return nil
    else return seatCost
    end
  end

  # since departure and destination airports of a particular flight
  # are not supposed to change, these are at most requested once from the database.
  def departure
    if (departureAirport.nil?) then setAirports end
    return @departureAirport
  end

  # since departure and destination airports of a particular flight
  # are not supposed to change, these are at most requested once from the database.
  def destination
    if (destinationAirport.nil?) then setAirports end
    return @destinationAirport
  end
  
  # The database is queried for the airports associated with this direct flight
  def setAirports 
    airportCodes = adameus.flight_airports(flightCode)
    @departureAirport = Airport.new(airportCodes[0,3])
    @destinationAirport = Airport.new(airportCodes[3,3])
  end
end

#-SOME-TESTS--------------------------------------------------------------------
#date = '2012-01-15'
#adameus = Adameus.new
#conns = adameus.connections('VIE', 'BRU', date).split(/\n/)
#myFlight = Flight.new(conns[1], date)
#puts myFlight.price('F')
#puts myFlight.departure
#puts myFlight.destination
#puts myFlight.departureTime
#puts myFlight.flightDuration
#-------------------------------------------------------------------------------
