require_relative 'Flight'
require_relative 'adameus'

class GroupTicket
  attr_reader :Customers
  attr_reader :nbOfTickers
  def initialize(flights, seatclass, nbOfTickets)
    #might be better to wait this one out until I have a better idea of 
    #what they're actually lookin for.
    @Customers = []
    @nbOfTickers = nbOfTickers
  end
  
  def addCustomer(customer)
    if( @Customers.length < @nbOfTickers ) then
      @Customers.append(customer)
    else
      puts("GroupTicket has reached its maximum customers")
    end
  end
  
  def to_s
    @Customers.each do |cust|
      cust.to_s
    end
  end
  
end

# A Compound ticket represents a ticket for a sequence of flights.
class CompoundTicket
  attr_reader :compoundTicket
    def initialize(flights, seatclass, gender, firstname, surname)
    @compoundTicket = flights.map do |flight|
      Ticket.new(flight, seatclass, gender, firstname, surname)
    end
  end
  
  def to_s

    # Before printing a check should be done to ensure the booking is entirely valid.
    # If not this message should mention it's invalid. if it is the subsequent string should be printed
    flights = @compoundTicket.inject("") do |acc, ticket|
      acc + ticket.flight.departure + "=>" 
    end
    flightString = flights + compoundTicket.last.flight.destination    
    if (compoundTicket.last.gender.eql?("M")) then 
      title = "Mr." 
    else title = "Mrs." end
    
    if (compoundTicket.last.seatclass.eql?("E")) then 
      seatclass = "Economy class" 
    elsif (compoundTicket.last.seatclass.eql?("B")) then 
      seatclass = "Business class" 
    else seatclass = "First class" end
    price = compoundTicket.inject(0) do |acc, ticket| 
      acc + ticket.flight.price(ticket.seatclass).to_i
    end
    ticketOpening = "-----------TICKET-------------\n"
    customer = title + " " + compoundTicket.last.firstname.strip + " " + compoundTicket.last.surname.strip + "\n"
    travel = "route = " + flightString + "\n"
    seat = "seat = " + seatclass + "\n"
    travelCost = "price = " + price.to_s + "\n"
    ticketClosure = "------------------------------\n"

    return ticketOpening + customer + travel + seat + travelCost + ticketClosure
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
conns2 = adameus.connections('BRU', 'FRA', date).split(/\n/)
myFlight1 = Flight.new(conns[0], date)
myFlight2 = Flight.new(conns2[0], date)
myCompoundTicket = CompoundTicket.new([myFlight1, myFlight2], 'E', 'M', 'Edsger', 'Dijkstra')
puts myCompoundTicket.hold
puts myCompoundTicket.to_s
# myFlight = Flight.new(conns[0], date)
# puts myFlight.price('F')
# puts myFlight.departure
# puts myFlight.destination

# myTicket = Ticket.new(myFlight, 'F', 'M', 'Mr.', 'Burns')

# puts myTicket.hold
# puts myTicket.status

# puts myTicket.cancel

# puts myTicket.hold
# puts myTicket.status

# puts myTicket.book
# puts myTicket.status

# puts myTicket.cancel
#-------------------------------------------------------------------------------
