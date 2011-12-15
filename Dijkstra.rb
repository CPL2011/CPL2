require './pqueue'
require './adameus'
require './Airport'
require './Date'
require './Flight'
class MultiDijkstraHop

def initialize(date,priceClass)
@date = date
@airports = []
@INFINITY = 1 << 32
@loaded = false
@maxdays = 3
@ad = Adameus.new
@pc = priceClass
end

  def findAirport(startCode)
    @airports.each do |airport|
      if(airport.code == startCode.to_s)
        return airport
      end
    end
    return "Airport not found"
  end
  
  def findHops(rootCode, goalCode, proc)
	if not @loaded
		self.loadGraph
		@loaded = true
    end
    root = findAirport(rootCode)
    goal = findAirport(goalCode)
    return dijkstra(root,goal,proc)
  end
  
  def loadGraph 
    
    @airports = []
    @ad.airports.split(/\n/).each do |airport|
      a = Airport.new(airport[0,3])
      @airports.push(a)
    end
    @airports.each do |airport|
    loadAirport(airport,@ad.destinations(airport.code))
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
def getFlight(source,dest)
	c = @ad.connections(source,dest,@date)
	if c.nil? then return nil
	else
	f = Flight.new(c,@date)
	f.price(@pc)
	if(f.seats==0) then return nil 
	else return f
	end
	end
end
	
def dijkstra(source, destination, calcweight)
	visited = Hash.new				#hash of airports and booleans
	shortest_distances = Hash.new	#hash of airports and their distance to the source
	previous = Hash.new				#hash of airports and their predecessor in the dijkstra algorithm -- the values are tuples of airports and flights
	@airports.each do |a|
		visited[a] = false
		shortest_distances[a]=@INFINITY
		previous[a]= [nil,nil]
	end
	
	
	pq = PQueue.new(proc {|x,y| shortest_distances[x[0]] < shortest_distances[y[0]]})
	
	pq.push([source,nil]) 		#the priority queue contains a tuple of airports and the arrival time in that airport
	visited[source] = true
	shortest_distances[source] = 0
	node = pq.pop
	
	
	while node != destination and not node.nil?
		
		visited[node[0]] = true
		
		#if edges[v]
			node[0].connections.each do  |w|
			
				if visited[w]==false
					
					
					f = getFlight(node[0],w)
					#t = f.departureTime
					if not f.nil? then #and (node[1].compare(t.to_s,t.getTime)<0)
					
					weight = calcweight.call(f)
					
					
					if shortest_distances[w] >= shortest_distances[node[0]] + weight
						shortest_distances[w] = shortest_distances[node[0]] + weight
						previous[w] = [node[0],f]
						
						pq.push([w,nil])
					end
					end
				end
			end
		#end
		node = pq.pop
	end
	
	ret = []
	i = 0
	
	while destination != source
		
		f = previous[destination][1]

		ret[i] = f
		destination = previous[destination][0]
		
		i+=1
	end
	return ret.reverse
end

def find_shortest(rootCode,goalCode)
	self.findHops(rootCode, goalCode, lambda{|x|  1})
end

def find_cheapest(rootCode,goalCode)
findHops(rootCode, goalCode,lambda{|x|  x.price(@pc).to_i})
end



end

ds = MultiDijkstraHop.new(Date.new("2011-12-12","06:00"),'E')
l=ds.find_shortest('VIE','LAX')
p l[0].departure
l.each do |a|
p a.destination
end
l=ds.find_cheapest('VIE','LAX')
p l[0].departure
l.each do |a|
p a.destination
end

