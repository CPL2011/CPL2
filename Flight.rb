require_relative 'Airport'
require_relative 'adameus'
# The Flight class represents a single, direct flight between two airports
class Flight
  attr_reader :flightCode, :date, :departureTime, :flightDuration, :departureAirport, :destinationAirport

  def initialize(connCode, date)
    @flightCode = connCode[0,6]
    @date = date
    @departureTime = connCode[6,5]
    @flightDuration = connCode[11,5]
    @departureAirport = nil
    @destinationAirport = nil
  end

  # Returns the cost of a seat on this flight if there is still room for another
  # passenger, otherwise nil gets returned.
  # Prices change all the time, thus every time the price for a particular seat on
  # this flight is requested a new database call is made.
  def price(seatClass)
    seatInfo = Adameus.new.seats(date, flightCode, seatClass)   
    nbOfSeats = seatInfo[0,3]
    seatCost = seatInfo[3,5]
    if (nbOfSeats.to_i < 1) then return nil
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
    airportCodes = Adameus.new.flight_airports(flightCode)
    @departureAirport = airportCodes[0,3]
    @destinationAirport = airportCodes[3,3]
  end
end

#-SOME-TESTS--------------------------------------------------------------------
date = '2012-01-15'
conns = Adameus.new.connections('VIE', 'BRU', date).split(/\n/)
puts Flight.new(conns[0], date).price('B')
#-------------------------------------------------------------------------------
