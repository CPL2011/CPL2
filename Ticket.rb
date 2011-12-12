require_relative 'Flight'
require_relative 'adameus'

class GroupTicket
  def initialize(flights, seatclass, gender, firstname, surname, nbOfTickets)
    #might be better to wait this one out until I have a better idea of 
    #what they're actually lookin for.
  end
end

# A Compound ticket represents a ticket for a sequence of flights.
# NOTE! currently the 'each' def is called a lot, I'm not pleased with it, looking for a 
# more elegant operator.
class CompoundTicket
  attr_reader :compoundTicket
  def initialize(flights, seatclass, gender, firstname, surname)
    @compoundTicket = []
    flights.each do |flight|
      ticket = Ticket.new(flight, seatclass, gender, firstname, surname)
      @compoundTicket.push(ticket)
    end
  end
  
  def hold
    compoundTicket.each do |ticket| 
      ticket.hold
    end
  end

  def book
    compoundTicket.each do |ticket|
      ticket.book
    end
  end

  def cancel
    compoundTicket.each do |ticket|
      ticket.cancel
    end
  end
  
  def status
    compoundTicket.each do |ticket|
      ticket.status
    end
  end  
end




class Ticket
  attr_reader :booking, :flight, :seatclass, :adameus, :gender, :firstname, :surname
  SEVEN_DAYS = 604800

  def initialize(flight, seatclass, gender, firstname, surname)
    @flight = flight
    @seatclass = seatclass
    @gender = gender
    @firstname = firstname
    @surname = surname
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

Struct.new("Booking", :bookingCode, :timeStamp)

#-SOME-TESTS--------------------------------------------------------------------
date = '2012-01-15'
adameus = Adameus.new
conns = adameus.connections('VIE', 'BRU', date).split(/\n/)
myFlight1 = Flight.new(conns[0], date)
myFlight2 = Flight.new(conns[1], date)
myCompoundTicket = CompoundTicket.new([myFlight1, myFlight2], 'B', 'M', 'Mr.', 'Burns')
myCompoundTicket.hold
myFlight = Flight.new(conns[0], date)
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
