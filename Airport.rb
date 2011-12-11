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
