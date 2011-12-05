require 'net/telnet'

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
  
  # If this string is shorter than len, extends this string with padding of spaces,
  # if this string is longer than len, shortens this string to length len.
  def fix_length!(len)
    self.replace(fix_length(len))
  end
end

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
    query_host("D" + airport.to_s)
  end
  
  def connections(departure, arrival, date)
    query_host("C" + departure.to_s + arrival.to_s + date.to_s)
  end
  
  def flight_airports(flightnumber)
    query_host("F" + flightnumber.to_s)
  end
  
  def weekdays(flightnumber)
    query_host("W" + flightnumber.to_s)
  end
  
  def seats(date, flightnumber, seatclass)
    query_host("S" + date.to_s + flightnumber.to_s + seatclass.to_s)
  end
  
  def hold(date, flightnumber, seatclass, gender, firstname, surname)
    firstname = firstname.to_s
    surname = surname.to_s
    firstname.fix_length!(15)
    surname.fix_length!(20)
    query_host("H" + date.to_s + flightnumber.to_s + seatclass.to_s + gender.to_s + firstname + surname)
  end
  
  def book(bookingcode)
    query_host("B" + bookingcode.to_s)
  end
  
  def cancel(bookingcode)
    query_host("X" + bookingcode.to_s)
  end
  
  def query_booking(bookingcode)
    query_host("Q" + bookingcode.to_s)
  end
  
  private :open_host, :close_host, :query_host

  def repl
    while true do
      puts 'Enter Query'
      entry = gets.chomp
      if(entry == "exit")
        break
      else
        response = eval(entry)      #eval does not work so good. functions with 0-1 arguments work, but others do not (the argument must be put between '' => destinations 'VIE')
        if(response.nil?)
          puts 'Response Empty'
        else
          puts 'Response:'
          puts response
        end
      end
    end
  end
end
