require 'net/telnet'

class Adameus
  def initialize
    @answer = ''
  end
  
  def open_host
    @host = Net::Telnet.new('Host' => 'localhost', 'Port' => 12111)
  end
  
  def close_host
    if(@host.respond_to?(:close))
      @host.close
    end
  end
  
  def query_host(query)
    open_host
    @host.puts(query)
    @answer = @host.waitfor(true)
    close_host
    @answer
  end
  
  def version
    query_host("V")
  end
  
  def airlines
    query_host("A")
  end
  
  def airports
    query_host("P")
  end
  
  def destinations(airport)
    query_host("D" + airport)
  end
  
  def connections(departure, arrival, date)
    query_host("C" + departure + arrival + date)
  end
  
  def flight_airports(flightnumber)
    query_host("F" + flightnumber)
  end
  
  def weekdays(flightnumber)
    query_host("W" + flightnumber)
  end
  
  def seats(date, flightnumber, seatclass)
    query_host("S" + date + flightnumber + seatclass)
  end
  
  def hold(date, flightnumber, seatclass, gender, firstname, surname)
    query_host("H" + date + flightnumber + seatclass + gender + firstname + surname)
  end
  
  def book(bookingcode)
    query_host("B" + bookingcode)
  end
  
  def cancel(bookingcode)
    query_host("X" + bookingcode)
  end
  
  def query_booking(bookingcode)
    query_host("Q" + bookingcode)
  end
  
  private :open_host, :close_host, :query_host
end