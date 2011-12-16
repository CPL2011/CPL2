require 'net/telnet'
require './Date'
require './Dijkstra'
require './Ticket'
require './Flight'
class String
  # If this string is shorter than len, returns an extended version of this string with padding of spaces,
  # if this string is longer than len, returns a shortened version of this string with length len.
  def fix_length(len)
    str = self
    if(len.respond_to?(:to_int))
      len = len.to_i
      str = "%-#{len}s" % str
      str = str[0..len-1]
    else
      raise ArgumentError, "The given argument has to be a number."
    end
  end
  
  # If the given string is shorter than len, extends this string with padding of spaces,
  # If the given string is longer than len, shortens this string to length len.
  def fix_length!(len)
    self.replace(fix_length(len))
  end
end

Person = Struct.new(:gender, :firstname, :surname)

class Adameus

  # initialize an Adameus instance
  def initialize
    @answer = ''
  end
  
  # make a connection with the Adameus server
  def open_host
    @host = Net::Telnet.new('Host' => 'localhost', 'Port' => 12111)
  end
  
  # close the connection with the Adameus server
  def close_host
    if(@host.respond_to?(:close))
      @host.close
    end
  end
  
  # send a query to the Adameus server
  def query_host(query)
    open_host
    @host.puts(query)
    @answer = @host.waitfor(true)
    close_host
    @answer
  end
  
  # returns  the version information on the Adameus server
  def version
    query_host("V")
  end
  
  # returns  the airlines currently in the database of the Adameus server
  def airlines
    query_host("A")
  end
  
  # returns  the airports currently in the database of the Adameus server
  def airports
    query_host("P")
  end
  
  # returns the airports to which you can make direct flights from the given airport
  # airport : A String specifying an airport
  def destinations(airport)
    query_host("D" + airport.to_s)
  end
  
  # returns the flight information for the connections between the given departure and
  # arrival airport on the given day
  def connections(departure, arrival, date)
    query_host("C" + departure.to_s + arrival.to_s + date.to_s)
  end
  
  # returns the two airports which the flight with the given flightnumber connects.
  def flight_airports(flightnumber)
    output = query_host("F" + flightnumber.to_s).chomp()
    if (output == "FN" || output == "ERRIM") then puts "No such flightnumber"
    else return output
    end
  end
  
  # returns the days of the week that the plane with the given flight number flies
  def weekdays(flightnumber)
    output = query_host("W" + flightnumber.to_s).chomp()
    if (output == "FN" || output == "ERRIM") 
      puts "No such flightnumber"
    else return output 
    end
  end
  
  # returns the number of tickets available in the given class and on the given date and 
  # flight with the given flightnumber
  # date : A String specifying the date
  # flightnumber : A String specifying the flight
  # seatclass : a String/Char specifying the class of the seating arrangement
  def seats(date, flightnumber, seatclass)
    query_host("S" + date.to_s + flightnumber.to_s + seatclass.to_s)
  end

  # If successful, returns the booking code(s) of the requested flight arrangement(s). 
  # If unsuccessful returns an error. The booking codes will specify the connection that will 
  # allow the traveler to reach his destination in the cheapest possible way
  # date : A String specifying the date
  # airportDepartureCode : a String specifying the airport from which the passenger departs.
  # airportDestinationCode : a String specifying the airport that the passenger wishes to reach
  # seatclass : a String/Char specifying the class of the seating arrangement
  # people : a list of Struct::Person which specifies the people for which the flight should be booked 
  def hold_cheapest(date, airportDepartureCode, airportDestinationCode,  seatclass, *rest)
    people = strings2people(*rest)
    flights = MultiDijkstraHop.new(Date.new(date, nil), seatclass, people.length).find_cheapest(airportDestinationCode, airportDepartureCode)
    return hold_helper(flights, seatclass, people)
  end

  # Converts an unspecified number of String parameters into a list of Person instances
  # *rest : an undefined number of String parameters
  # each String follows the following syntax: "<gender>, <firstname>, <surname>"
  # e.g.: "M, John, McCarthy", "M, Edsger, Dijkstra", "F, Ada Lovelace"
  def strings2people(*rest) 
    return *rest.map do |person_info|
      split_info = person_info.split(/, /)
      Person.new(split_info[0], split_info[1], split_info[2])
    end
  end
  # If successful, returns the booking code(s) of the requested flight arrangement(s). 
  # If unsuccessful return an error. The booking codes will specify the connection that will 
  # allow the traveler to reach his destination in the least possible hops
  # date : A String specifying the date
  # airportDepartureCode : a String specifying the airport from which the passenger departs.
  # airportDestinationCode : a String specifying the airport that the passenger wishes to reach
  # seatclass : a String/Char specifying the class of the seating arrangement
  # people : a list of Struct::Person which specifies the people for which the flight should be booked 
  def hold_minimal_hops(date, airportDepartureCode, airportDestinationCode, seatclass, *rest)
    people = strings2people(*rest)
    flights = MultiDijkstraHop.new(Date.new(date, nil), seatclass, people.length).find_shortest(airportDestinationCode, airportDepartureCode)
    return hold_helper(flights, seatclass, people)
  end

  # If successful, returns the booking code(s) of the requested flight arrangement(s). 
  # If unsuccessful returns a message. The booking codes will specify the connection that will 
  # allow the traveler to reach his destination in the quickest possible way
  # date : A String specifying the date
  # airportDepartureCode : a String specifying the airport from which the passenger departs.
  # airportDestinationCode : a String specifying the airport that the passenger wishes to reach
  # seatclass : a String/Char specifying the class of the seating arrangement
  # people : a list of Struct::Person which specifies the people for which the flight should be booked 
  def hold_quickest(date, airportDepartureCode, airportDestinationCode, seatclass, *rest)
    people = strings2people(*rest)
    flights = MultiDijkstraHop.new(Date.new(date, nil), seatclass, people.length).uniform_cost_algorithm.find_shortest_time(airportDestinationCode, airportDepartureCode)
    return hold_helper(flights, seatclass, people)
  end

  # If successful, returns the booking code of the requested flight arrangement, if unsuccessful, return an error.
  # date : A String specifying the date
  # flightnumber : a String specifying the code of the flight the passenger wishes to book
  # seatclass : a String/Char specifying the class of the seating arrangement
  # gender : a String/Char specifying the gender of the passenger
  # firstname : a String specifying the first name of the passenger
  # surname : a String specifying the last name of the passenger
  def hold(date, flightnumber, seatclass, gender, firstname, surname)
    firstname = firstname.to_s
    surname = surname.to_s
    begin 
      firstname.fix_length!(15)
      surname.fix_length!(20)
    rescue 
      puts $!.message
    end
    output = query_host("H" + date.to_s + flightnumber.to_s + seatclass.to_s + gender.to_s + firstname + surname).chomp()
    if (output == "FN" || output == "ERRIM") then
      puts "No seats available(" + output + ")"
    else 
      return output
    end
  end
  

  # If successful, the flight associated with the given bookingcode gets booked
  # If unsuccessful one of the following messages gets printed:
  # A message will be printed if the bookingcode length violates the expected length
  # A message will be printed if the Adameus server informs that the given bookingcode is invalid
  # A message will be printed if the Adameus server informs that the seat associated with the given 
  # bookingcode has already been booked.
  # bookingcode : A String representation of the bookingcode
  def book(bookingcode)
    if (bookingcode.length != 32) then puts "An invalid bookingcode was given"
    else 
      output = query_host("B" + bookingcode.to_s)
      if (output.chomp() == "FN" || output.chomp() == "ERRIM") then puts "An invalid booking code was given" 
      elsif (output.chomp() == "FA") then puts "The requested seat has already been booked" 
      else return output
      end
    end
  end
    
  # If successful, cancels the holding/booking associated with the given bookingcode 
  # If unsuccessful one of the following messages gets printed:
  # A message will be printed if the Adameus server informs that the given bookingcode is invalid
  # A message will be printed if the Adameus server informs that the cancel period has been exceeded
  # bookingocde: A String representation of the bookingcode
  def cancel(bookingcode)
    output = query_host("X" + bookingcode.to_s)
    if (output.chomp() == "FN" || output.chomp() == "ERRIM") then puts "An invalid booking code was given" 
    elsif (output.chomp() == "FX") then puts "The booking is older than seven days and can no longer be cancelled" 
    else return output
    end
  end
  
  def query_booking(bookingcode)
    output = query_host("Q" + bookingcode.to_s).chomp()
    if (output == "FN" || output == "ERRIM") then puts  "No such bookingcode"
    else return output
    end
  end

  # def priceOfFlight(date, seatClass, airportDepartureCode, airportDestinationCode)
  #   MultiHop.new.findHops(airportDepartureCode, airportDestinationCode)
  #   query_host("S" + date.to_s + flightnumber.to_s + seatclass.to_s)
  # end

  def loadfile(path)
    file = File.open(path)
    file.each {|line|
      response = self.send(*line.split(/\s+/)) 
      if(response.nil?) then puts 'Response Empty'
      else
        puts 'Response:'
        puts response
      end
    }
  end

  def method_missing(m, *args, &block)  
    puts "There's no Query called #{m} here -- please try again."  
  end 
  alias :execute :instance_eval
  
  # If successful, holds a ticket of the given 'seatclass' for each passenger specified in 'people' 
  # on each flight specified in 'flights'. If unsuccessful, prints an error
  # flights : A list of Flight instances
  # seatclass : a String/Char specifying the class of the seating arrangement
  # people : a list of Struct::Person which specifies the people for which the flight should be booked 
  def hold_helper(flights, seatclass, people)
    if (flights.nil? || flights.length == 0) then puts "There is no flight satisfying the given requirements" 
    else 
      ticket = GroupTicket.new(flights, seatclass)
      people.each do |person|
        ticket.addTicket(person.gender, person.firstname, person.surname)
      end
      return ticket.hold   # hold GroupTicket will be responsible for handling potential rollback, 
      # should also return the list of bookingcodes if successful. Probably raise an error
      # in case a rollback was neccessary
    end
  end
  
  private :open_host, :close_host, :query_host, :hold_helper, :strings2people # all methods listed here will be made private: not accessible for outside objects
end

def repl
 
  while true do
        puts 'Enter Query'
        entry = gets.chomp
        if(entry == "exit")
          break
        else
          response = $adameus.send(*entry.split(/\s+/)) 
          if(response.nil?)
            puts 'Response Empty'
          else
            puts 'Response:'
            puts response
          end
        end
  end
end
#$adameus = Adameus.new
#puts $adameus.weekdays("Taketsuru")
#edsger_dijkstra = Person.new("M", "Edsger", "Dijkstra")
#puts $adameus.book("tralalalalal")
#puts $adameus.hold_cheapest("2012-01-15", "TEG", "AKL",  "B", "M, Edsger, Dijkstra", "M, John, McCarthy")
#puts $adameus.version
#puts $adameus.connections("VIE", "BRU", "2012-01-15")
# puts $adameus.cancel("5b129c0f1f1f6b911f88b759470dbc7c")
#puts $adameus.hold("2012-01-15", "SJT208", "E", "M", "Edsger", "Dijkstra")
# puts $adameus.book("5b129c0f1f1f6b911f88b759470dbc7c")
# repl
