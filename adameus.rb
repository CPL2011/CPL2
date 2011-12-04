require 'net/telnet'

class Adameus
  def initialize
    @answer = ''
  end
  
  def open_host
    @host = Net::Telnet.new('Host' => 'localhost', 'Port' => 12111)
  end
  
  def close_host
    if(@host.respond_to?(:close))
      @host.close
    end
  end
  
  def query_host(query)
    open_host
    @host.puts(query)
    @answer = @host.waitfor(true)
    close_host
  end
  
  def version
    query_host("V")
    @answer
  end
  
  def airlines
    query_host("A")
    @answer
  end
  
  def airports
    query_host("P")
    @answer
  end
  
  private :open_host, :close_host, :query_host
end