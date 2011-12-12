require_relative 'Airport'
require_relative 'adameus'
# The Flight class represents a single, direct flight between two airports
class Flight
  attr_reader :flightCode, :booking, :date, :departureTime, :flightDuration, :departureAirport, :destinationAirport
  SEVEN_DAYS = 604800

  def initialize(connCode, date)
    @flightCode = connCode[0,6]
    @date = date
    @departureTime = connCode[6,5]
    @flightDuration = connCode[11,5]
    @departureAirport = nil
    @destinationAirport = nil
    Booking = Struct.new(:bookingCode, :timeStamp)
    @booking = Booking.new(nil, nil)
    @adameus = adameus = Adameus.new 
  end

  # Returns the cost of a seat on this flight if there is still room for another
  # passenger, in all other cases nil gets returned.
  # Prices change all the time, thus every time the price for a particular seat on
  # this flight is requested a new database call is made.
  def price(seatClass)
    seatInfo = adameus.seats(date, flightCode, seatClass).chomp
    if (seatInfo.size != 8) then return nil end 
    nbOfSeats = seatInfo[0,3]
    seatCost = seatInfo[3,5]
    if (nbOfSeats.to_i < 1) then return nil
    else return seatCost
    end
  end



#-------------------------------------------------------------------------------
#-It-might-be-better-if-this-were-stored-in-a-separate-class-(e.g.:ticket)------
#-------------------------------------------------------------------------------
  def hold(seatclass, gender, firstname, surname)
    feedback = adameus.hold(date, flightCode, seatclass, gender, firstname, surname).chomp
    if (feedback.size == 33) 
      @booking[:bookingCode] = feedback[1,32]
      @booking[:timeStamp] = Time.now
    end
  end

  def book
    raise "A holding has to be made before a booking can be processed" if booking.bookingCode.nil?
    adameus.book(booking.bookingCode)
  end

  # I am confused, is it our responsibility to keep track of the time?
  # If so,...How? use some sort of timestamp? How does that mix with the fact that all
  # flights occur between 1 november 2011 and 31 januari 2012? 
  # currently working with a timestamp...

  # A holding is automatically removed after 24 hours, a booking can be removed up until 7 
  # days have passed. Since there is no difference between the two in the way cancel is called,
  # the only check that has to be done is if the timeStamp isn't older than 7 days.
  def cancel
    raise "No holding/booking made" if booking.bookingCode.nil?
    if ((booking.timeStamp + SEVEN_DAYS <=> Time.now) = 1)
      cancel(booking.bookingCode)
    end
  end
  
  # request the status of a booking
  def status
    raise "No holding/booking made" if booking.bookingCode.nil?
    adameus.status(booking.bookingCode)    
  end
#-------------------------------------------------------------------------------





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
    @departureAirport = airportCodes[0,3]
    @destinationAirport = airportCodes[3,3]
  end
end

#-SOME-TESTS--------------------------------------------------------------------
date = '2012-01-15'
conns = adameus.connections('VIE', 'BRU', date).split(/\n/)
myFlight = Flight.new(conns[1], date)
puts myFlight.price('F')
puts myFlight.departure
puts myFlight.destination
#-------------------------------------------------------------------------------
