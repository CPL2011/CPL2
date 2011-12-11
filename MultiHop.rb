class MultiHop
  @airports = []
  
  def findAirport(startCode)
    @airports.each do |airport|
      if(airport.code == startCode.to_s)
        return airport
      end
    end
    return "Airport not found"
  end
  
  def findHops
    self.loadGraph
    root = findAirport('PEK')
    goal = findAirport('AKL')
    
    return IDDFS(root,goal)
  end
  
  def IDDFS(root, goal)
    depth = 0
    solution = nil
    while(solution == nil && depth < 50)
      solution = DLS(root, goal, depth)
      depth = depth + 1
    end
    return solution
  end

  def DLS(node, goal, depth)
    if ( depth >= 0 ) 
      if ( node.equals(goal) )
        t = []
        return t.push(node)
      end
      
      node.connections.each do |child|
        t = DLS(child, goal, depth-1)
        if(t != nil)
          t.push(node)
        end
        return t
      end
    end
    return nil
  end
  
  def loadGraph
    ad = Adameus.new
    @airports = []
    ad.airports.split(/\n/).each do |airport|
      a = Airport.new
      a.init
      a.setCode(airport[0,3])
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
end

class Airport
  def init
    @Code = ""
    @Conn = []
  end
  
  def connections
    return @Conn
  end
  
  def addConnection(conn)
    @Conn.push(conn)
  end
  
  def code
    return @Code
  end
  
  def setCode(code)
    @Code = code
  end
  
  def equals(airp)
    return (@Code == airp.code)
  end
  
  def to_s
    return @Code
  end
end