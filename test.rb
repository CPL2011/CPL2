require 'net/telnet'

host = Net::Telnet.new('Host' => 'localhost', 'Port' => 12111)
host.puts("A")

puts host.waitfor(true)

host.close