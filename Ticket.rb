require_relative 'Flight'
require_relative 'adameus'

class Ticket
  attr_reader :booking, :flight, :seatclass, :adameus, :gender, :firstname, :surname
  SEVEN_DAYS = 604800

  def initialize(flight, seatclass, gender, firstname, surname)
    @flight = flight
    @seatclass = seatclass
    @gender = gender
    @firstname = firstname
    @surname = surname
    Struct.new("Booking", :bookingCode, :timeStamp)
    @booking = Struct::Booking.new(nil, nil)
    @adameus = adameus = Adameus.new 
  end

  def hold
    feedback = adameus.hold(flight.date, flight.flightCode, seatclass, gender, firstname, surname).chomp
    if (feedback.size == 33) 
      @booking[:bookingCode] = feedback[1,32]
      @booking[:timeStamp] = Time.now
    end
  end

  def book
    raise "A holding has to be made before a booking can be processed" if booking.bookingCode.nil?
    adameus.book(booking.bookingCode)
  end

  def cancel
    raise "No holding/booking made" if booking.bookingCode.nil?
    if ((booking.timeStamp + SEVEN_DAYS <=> Time.now) == 1)
      adameus.cancel(booking.bookingCode)
    end
  end
  
  def status
    raise "No holding/booking made" if booking.bookingCode.nil?
    adameus.query_booking(booking.bookingCode)    
  end
end

#-SOME-TESTS--------------------------------------------------------------------
date = '2012-01-15'
adameus = Adameus.new
conns = adameus.connections('VIE', 'BRU', date).split(/\n/)
myFlight = Flight.new(conns[1], date)
puts myFlight.price('F')
puts myFlight.departure
puts myFlight.destination

myTicket = Ticket.new(myFlight, 'B', 'M', 'Mr.', 'Burns')
puts myTicket.hold
puts myTicket.status

puts myTicket.cancel

puts myTicket.hold
puts myTicket.status

puts myTicket.book
puts myTicket.status

puts myTicket.cancel
#-------------------------------------------------------------------------------
