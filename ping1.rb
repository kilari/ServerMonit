require 'rubygems'
require 'net/ping'
require '/home/kilari/work/ruby/vpswork/sendalert'

module FetchData

def self.fetch
$ipstore = []
File.open('/home/kilari/work/ruby/vpswork/data', 'r').each do |ip|
ip.scan(/\S+/) do |ip1|
$ipstore << ip1
end
end
end
end


module Ping

        def self.httpcheck(host = "74.63.10.108")
        #host = host
	if Net::PingTCP.new(host, 80).ping
	puts "#{host} is alive"

	else 
	puts "I belive #{host} dead, sending alert"
	SendAlert.downalert(host)

	end
	end
end

loop do 
FetchData.fetch()
$ipstore.each do |ipsend|
Ping.httpcheck(ipsend)
end
sleep 30
end
