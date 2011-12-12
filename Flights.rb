require_relative 'Airport'
require_relative 'Date'

# The Flights class represents one or a series of connections between airports.
# It consists of a number of airports, the first one being the departure airport,
# and the last one being the destination.
class Flights
  attr_reader :flights

  # airports : An array of Airport instances. 
  # The first element in the list represents the departure airport, 
  # the last one the destination airport,
  # everything in between are the stops made in their respective sequence.
  def initialize(flights)
    @flights = flights
  end
  
  # Returns the best possible series of connections.
  # The best connection is the connection that brings you asap to your destination
  # departureDate : the date at which the first flight should be caught.
  # (after all, theoretically it's possible the trip to your 
  # destination spans multiple days)
  def bestConnectionChain(departureDate)

  end
  #BEL06215:1001:35
  
  def bestConnection(departureCode, arrivalCode, departureDate)
    
  end
  
  # returns the total estimated time the traveller will be airbone 
  # (excluding waiting times in between flights)
  def totalFlightTime

  end
  
  # returns the total estimated time passed between the departure and 
  # the moment the destination is reached
  def totalTripTime

  end  
end

#-------------------------------------------------------------------------------

