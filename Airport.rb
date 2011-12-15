class Airport
  attr_reader :code

  def initialize(code)
    raise "Missing code" if code.nil? # code is compulsory
    @code = code
    @Conn = []
  end
  
  def connections
    return @Conn
  end
  
  def addConnection(conn)
    @Conn.push(conn)
  end
  
  def equals(airp)
    return (@code == airp.code)
  end
  
  def to_s
    return @code.to_s
  end
end
