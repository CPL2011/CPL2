require './pqueue'
require './adameus'
require './Airport'
class MultiDijkstraHop

def initialize
@airports = []
@INFINITY = 1 << 32
@loaded = false
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
    ad = Adameus.new
    @airports = []
    ad.airports.split(/\n/).each do |airport|
      a = Airport.new(airport[0,3])
      @airports.push(a)
    end
    
    @airports.each do |airport|
    
      loadAirport(airport,ad.destinations(airport.code))
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
  
def dijkstra(source, destination, calcweight)
	visited = Hash.new
	shortest_distances = Hash.new
	previous = Hash.new
	@airports.each do |a|
		visited[a] = false
		shortest_distances[a]=@INFINITY
		previous[a]= nil
	end
	
	
	pq = PQueue.new(proc {|x,y| shortest_distances[x] < shortest_distances[y]})
	
	pq.push(source)
	visited[source] = true
	shortest_distances[source] = 0
	node = pq.pop
	
	
	while node != destination and not node.nil?
		
		visited[node] = true
		
		#if edges[v]
			node.connections.each do  |w|
		
				
				if visited[w]==false
					
					weight = calcweight.call(node,w)
					
					
					if shortest_distances[w] >= shortest_distances[node] + weight
						shortest_distances[w] = shortest_distances[node] + weight
						previous[w] = node
						pq.push(w)
					end
				end
			end
		#end
		node = pq.pop
	end
	
	ret = [destination]
	i = 1
	while destination != source
		destination = previous[destination]
		ret[i] = destination
		i+=1
	end
	return ret.reverse
end

def find_shortest(rootCode,goalCode)
	self.findHops(rootCode, goalCode, lambda{|x,y|  1})
end

def find_cheapest(rootCode,goalCode)
#findHops(rootCode, goalCode,Proc.new{|x,y|  1})
end



end
ds = MultiDijkstraHop.new
l=ds.find_shortest('VIE','LAX')
p l

