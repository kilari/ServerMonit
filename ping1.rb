require 'rubygems'
require 'net/ping'
require '/home/kilari/work/ruby/vpswork/sendalert'

module DataMod
class FetchDataClass
	
	def fetch
	$ipstore = []
	File.open('/home/kilari/work/ruby/vpswork/data', 'r').each do |ip|
	ip.scan(/\S+/) do |ip1|
	$ipstore << ip1
	end
	end
	
	end
end

class PingClass
        def httpcheck(host = "74.63.10.108")
	if Net::PingTCP.new(host, 80).ping
	puts "#{host} is alive"

	else 
	puts "I belive #{host} dead, sending alert"
	SendAlert::SendMail.downalert(host)

	end
	end
end

class DataInitClass
        
	def init()     
	fcd = FetchDataClass.new()
	fcd.fetch
	$ipstore.each do |ipsend|
	PingClass.new.httpcheck(ipsend)
	end
	end
end
end
