class Flight
  attr_reader :airportCodes

  # airports : An array of airport codes. 
  # The first element is the code of the departure airport, 
  # the last one is the code of the destination airport,
  # everything in between are the stops made in their respective sequence.
  def initialize(airports)
    @airportCodes = airports
  end
  
  # Checks the validity of this Flight.
  # A flight is valid when it's physically possible for the passenger
  # to 'catch his/her next flight'.
  def isValid
    
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

class Date
  attr_reader :date

  def initialize(date, time)
    raise "Missing date" if date.nil?
    splitData = date.split(/-/)
    if (time.nil?) 
      @date = Time.new(splitData[0], splitData[1], splitData[2], 0, 0, 0)
    else 
      timeWrap = MyTime.new(time)
      @date = Time.new(splitData[0], splitData[1], splitData[2], timeWrap.seconds/3600, timeWrap.seconds%3600/60)  
    end
  end
  
  def addTimeToDate(time)
    if (!time.class.to_s.eql?("MyTime"))
      time = MyTime.new(time)
    end
    return @date + time.seconds
  end

  def compare(givenDate, givenTime)
    if (givenDate.class.to_s.eql?("Date") && givenTime == nil) 
      return date <=> givenDate.date
    else
      return date <=> Date.new(givenDate, givenTime).date
    end
  end
end

class MyTime
  attr_reader :seconds
  def initialize(time)
    splitTime = time.split(/:/)
    hours = splitTime[0]
    minutes = splitTime[1]
    @seconds = hours.to_i*3600 + minutes.to_i*60 
  end
end

test1 = Date.new("2011-03-12", "10:30")
test2 = Date.new("2011-03-12", nil)
puts test1.date
puts test2.date
puts test1.addTimeToDate("17:55")
timeToAdd = MyTime.new("17:55")
puts test1.addTimeToDate(timeToAdd)
puts test1.compare("2011-03-12", "10:29")
puts test1.compare(test1, nil)
