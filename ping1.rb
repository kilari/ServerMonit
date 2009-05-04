require 'rubygems'
require 'net/ping'
require '/home/kilari/work/ruby/vpswork/sendalert'

module Ping

	def self.httpcheck(host = "74.63.10.108")
        @host = host
	if Net::PingTCP.new(host, 80).ping
	puts "Its alive"

	else 
	puts "I belive its dead, sending alert"
	SendAlert.downalert()

	end
	end
end
