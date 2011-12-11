require_relative 'Airport'

# The Flight class represents one or a series of connections between airports.
# It consists of a number of airports, the first one being the departure airport,
# and the last one being the destination.
class Flight
  attr_reader :airports

  # airports : An array of Airport instances. 
  # The first element in the list represents the departure airport, 
  # the last one the destination airport,
  # everything in between are the stops made in their respective sequence.
  def initialize(airports)
    @airports = airports
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

# The Date class is used to contain the data and time data (relies on the Ruby-core class Time)
# Altough not strictly enforced (def freeze in Ruby is awkward) instances of 
# this class should be treated as immutable
class Date
  attr_reader :date

  # date : The date argument is compulsory e.g.: "2011-09-23"
  # time : A time argument can be provided or is specified as nil e.g.: "08:49"
  def initialize(date, time)
    raise "Missing date" if date.nil? # date is compulsory
    splitData = date.split(/-/)
    if (time.nil?) 
      @date = Time.new(splitData[0], splitData[1], splitData[2], 0, 0, 0)
    else 
      timeWrap = MyTime.new(time)
      @date = Time.new(splitData[0], splitData[1], splitData[2], timeWrap.seconds/3600, timeWrap.seconds%3600/60)  
    end
  end
  
  
  # Add the given time to the date
  # the given time added to the current time gets returned
  # time : a string following the previously specified 
  # syntax or an object of class MyTime
  def addTimeToDate(time)
    if (!time.class.to_s.eql?("MyTime"))
      time = MyTime.new(time)
    end
    return @date + time.seconds
  end

  # Compares the date represented by 'this' with the date 
  # specified by the parameters
  # givenDate : a string following the previously specified syntax for dates, 
  # or an instance of class Date (in which case givenTime should be nil).
  # givenTime : a string following the previously specified syntax or nil
  def compare(givenDate, givenTime)
    if (givenDate.class.to_s.eql?("Date") && givenTime == nil) 
      return date <=> givenDate.date
    else
      return date <=> Date.new(givenDate, givenTime).date
    end
  end
end

#-------------------------------------------------------------------------------

# The MyTime class is used to contain the time data
class MyTime
  attr_reader :seconds
  
  # time : the time argument following the previously defined syntax e.g.: "10:30"
  def initialize(time)
    splitTime = time.split(/:/)
    hours = splitTime[0]
    minutes = splitTime[1]
    @seconds = hours.to_i*3600 + minutes.to_i*60 
  end
end

#-SOME-TESTS--------------------------------------------------------------------
test1 = Date.new("2011-03-12", "10:30")
test2 = Date.new("2011-03-12", nil)
puts test1.date
puts test2.date
puts test1.addTimeToDate("17:55")
timeToAdd = MyTime.new("17:55")
puts test1.addTimeToDate(timeToAdd)
puts test1.compare("2011-03-12", "10:29")
puts test1.compare(test1, nil)
#-------------------------------------------------------------------------------
