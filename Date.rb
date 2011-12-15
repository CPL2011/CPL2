# -*- coding: utf-8 -*-
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

  # provides a string representation of the time associated with this date
  # following the syntax: "HH:MM"
  def time_to_s
    return (date.to_s.split(/ /)[1])[0,5]
  end

  # provides a string representation of the date
  # following the syntax: "YYYY-MM-DD"
  def to_s
    return date.to_s.split(/ /)[0]
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

  # provides a string representation of this time objectµ
  # following the syntax "HH:MM"
  def to_s 
    return (seconds/3600).to_s + ":" + ((seconds%3600)/60).to_s
  end
end

#-SOME-TESTS--------------------------------------------------------------------
test1 = Date.new("2011-03-12", "10:30")
#test2 = Date.new("2011-03-12", nil)
#puts test1.date
#puts test2.date
##puts test1.addTimeToDate("17:55")
#timeToAdd = MyTime.new("17:55")
##puts test1.addTimeToDate(timeToAdd)
#puts test1.compare("2011-03-12", "10:29")
#puts test2.compare(test1, nil)
#puts timeToAdd
#puts test1
puts test1.time_to_s
puts test1.to_s
#-------------------------------------------------------------------------------
