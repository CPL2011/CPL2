class MultiHop
  
  def findFirst(startCode)
    airports = self.loadGraph
    airports.each do |airport|
      if(airport.code == startCode.to_s)
        puts(airport.code + startCode)
        return airport.code
      end
    end
    return "Airport not found"
  end
  
  def loadGraph
    ad = Adameus.new
    destinations = []
    airports = []
    ad.airports.split(/\n/).each do |airport|
      a = Airport.new
      a.setCode(airport[0,3])
      airports.push(a)
      puts(a.code)
    end
    
    airports.each do |airport|
      puts(airport.code)
    end
    airports.each do |airport|
      ad.destinations(airport.code).split(/\n/).each do |des|
        airports.each do |airport2|
          puts(airport2.code + des[0,3])
          if(airport2.code == des[0,3])
            airport.connections.push(airport2)
            puts("Added Airport")
          end
        end
      end
    end
    return airports
  end
end

class Airport
  @@Code = ""
  @@Conn = []
  
  def connections
    return @@Conn
  end
  
  def code
    return @@Code
  end
  
  def setCode(code)
    @@Code = code
  end
end