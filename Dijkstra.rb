require './Airport'
require './pqueue'
require './Date'
require './Flight'

class MultiDijkstraHop

#This class provides the functionality find connected flights
#date: the departure date, a  Date object
#priceClass: Economy = 'E', Business = 'B', FirstClass = 'F' (with quotes)
def initialize(date,priceClass,seats)
@seats = seats
@date = date
@airports = []
@INFINITY = 1 << 32
@loaded = false
# @ad = Adameus.new
@pc = priceClass

end
#returns an airport object corresponding to the code
  def findAirport(startCode)
    @airports.each do |airport|
      if(airport.code == startCode.to_s)
        return airport
      end
    end
    return "Airport not found"
  end
#This is the method to call 
#rootCode = start airport code
#goalCode = destination airport code
#proc = a proc that takes a Flight object as first parameter, and an int as second
#this proc will calculate the cost to reach a destination through the given flight. the integer parameter is 
#the cost associated with the departure airport of that flight.
#
#the return value is an array of Flight objects
  def findHops(rootCode, goalCode, proc)
	if not @loaded then 
		self.loadGraph
		@loaded = true
	end 

    root = findAirport(rootCode)
    goal = findAirport(goalCode)
    return dijkstra(root,goal,proc)
  end
#loads the graph, finds the airport and stores the connections  
  def loadGraph 
    
    @airports = 
    $adameus.airports.split(/\n/).map do |airport|
       Airport.new(airport[0,3])
    end
    @airports.each do |airport|
    loadAirport(airport,$adameus.destinations(airport.code))
    end
  end
def loadAirport(airport,destinations)
      if(destinations != nil)
        destinations.split(/\n/).each do |des|
          @airports.each do |airport2|
            if(airport2.code == des[0,3])
              airport.addConnection(airport2)
            end
          end
        end
      end
  end 
  
 
 #returns all the flights from source to dest, given the date: dat.
 # If the time is after 18:00, flights from the next day will be included in the search ---->this needs to be done right!!
def getFlights(source,dest,dat)
	ret = []

	#if c.nil? then 
	#	dat = Date.new( (dat.addTimeToDate('24:00')).to_s ,nil)    	# TODO change the date to the next day to get other flights
	#	c = $adameus.connections(source,dest,dat)
	#	if c.nil? then return nil end
	#end


		c = $adameus.connections(source,dest,dat)
		if c.nil? then c="" end

		td = Date.new(dat.to_s,dat.time_to_s)
		td.addTimeToDate('06:00')

		if(!dat.isSameDay(td)) then
		t = $adameus.connections(source,dest,dat)
		if not t.nil? then c = c + t end 
		end


	if c.length == 0 then return nil end


	c.split(/\n/).each do |conn|
		f = Flight.new(conn,td.to_s)
		f.price(@pc)
		if (f.seats.to_i>=@seats) and (dat.compare(td.to_s,f.departureTime.to_s)==-1) then ret.push f end
	end
	return ret
end

#The dijkstra algorithm
#heavily modified from http://blog.linkedin.com/2008/09/19/implementing-di/
def dijkstra(source, destination, calcweight)
	visited = Hash.new				#hash of airports and booleans
	shortest_distances = Hash.new	#hash of airports and their distance to the source
	previous = Hash.new				#hash of airports and their predecessor in the dijkstra algorithm -- the values are tuples of airports and flights
	@airports.each do |a|
		visited[a] = false
		shortest_distances[a]=@INFINITY
		previous[a]= [nil,nil]
	end

	#info about priority queue: http://www.math.kobe-u.ac.jp/~kodama/tips-ruby-pqueue.html
	pq = PQueue.new(proc {|x,y| shortest_distances[x[0]] < shortest_distances[y[0]]})

	pq.push([source,@date]) 		#the priority queue contains a tuple of airports and the arrival time in that airport
	visited[source] = true
	shortest_distances[source] = 0



	while pq.size!=0
		node = pq.pop
		visited[node[0]] = true

		#if edges[v]
			node[0].connections.each do  |w|

				if visited[w]==false


					f = getFlights(node[0],w,node[1])
					if(not f.nil? and f.length!=0)
						weight = @INFINITY
						flight = nil

						f.each do |fl|			#get the least cost flight
							t = calcweight.call(fl,shortest_distances[node[0]])
							if t<weight then 
								weight = t 
								flight = fl
							end
						end

						if shortest_distances[w] > weight
							shortest_distances[w] =  weight
							previous[w] = [node[0],flight]
							arrdate = Date.new(flight.date.to_s,flight.departureTime.to_s)
							arrdate.addTimeToDate(flight.flightDuration)
							pq.push([w,arrdate])

						end
					end
				#end
				end
			end
		#end


	end

	ret = []

	while destination != source
		if destination.nil? then 
		p "No flights available, try an other day..."
		return nil
		end
		f = previous[destination][1]

		ret.push(f)
		destination = previous[destination][0]


	end

	return ret.reverse
end

def find_shortest(rootCode,goalCode)
	self.findHops(rootCode, goalCode, lambda{|flight,oldweight|  oldweight+1})
end

def find_cheapest(rootCode,goalCode)
	findHops(rootCode, goalCode,lambda{|flight,oldweight| oldweight+(flight.seatprice)})
end
def find_shortest_time(rootCode,goalCode)
	self.findHops(rootCode, goalCode, lambda{|flight,oldweight|  (Date.new(flight.date.to_s, flight.departureTime.to_s).addTimeToDate(flight.flightDuration)).to_i})
end

def find_expensive(rootCode,goalCode)
	findHops(rootCode, goalCode,lambda{|flight,oldweight|  oldweight-(flight.seatprice)})
end
#currently I have not seen this function behave different from shortest route....
#maybe just leave this out?
def find_optimal(rootCode,goalCode)
	findHops(rootCode, goalCode, 
		lambda{|flight,oldweight| 
			oldweight + (flight.date.date.to_i + (flight.flightDuration).seconds - @date.date.to_i)/1200 + 100 + flight.seatprice/5 
			# oldweight + (number of hours between arrival and departure + 100 (per hop))*3 + seatprice/5 (~25-250)
			})
end
end

#################TESTCODE######################
def printthis(l)
	if not l.nil? then
		p l[0].departure
		l.each do |a|
			p "departure " + a.date.to_s + '   ' +a.departureTime.to_s
			p "duration "+ a.flightDuration.to_s
			p a.destination
			p "price "+ a.seatprice.to_s
		end
	end
end

##BEST EXAMPLE -- start = AMS, dest=BCN
# start = 'TEG'
# dest = 'AKL'
# p 'FIND SHORTEST '+start+'->'+dest
# ds = MultiDijkstraHop.new(Date.new("2011-12-11","06:00"),'B',5)
# l=ds.find_shortest(start,dest)
# printthis(l)

# p 'FIND MOST QUICK '+start+'->'+dest
# l=ds.find_shortest_time(start,dest)
# printthis(l)

# p 'FIND CHEAPEST '+start+'->'+dest
# l=ds.find_cheapest(start,dest)
# printthis(l)

# p 'FIND MOST EXPENSIVE '+start+'->'+dest
# l=ds.find_expensive(start,dest)
# printthis(l)

# p 'FIND OPTIMAL '+start+'->'+dest
# l=ds.find_optimal(start,dest)
# printthis(l)
