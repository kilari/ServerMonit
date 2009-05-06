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
	puts "alive #{host} from pingclass"
#	puts "#{host} is alive"

	else 
#	puts "I belive #{host} dead, sending alert"
	puts "Down #{host} from pingclass"
	$downips << host
	$ipstore.delete_at($ipstore.index(host))

#	SendAlert::SendMail.downalert(host)

	end
	end
end

class DownPingClass
	
	$downips = []
	def downhttpcheck(host)
        unless $downips.empty?
	if Net::PingTCP.new(host, 80).ping
	$ipstore << host
	$downips.delete_at($downips.index(host))
	puts "up #{host} from downpingclass"
#	SendAlert::SendMail.upalert(host)
	else 
	puts "down #{host} from downpingclass"
#	SendAlert::SendMail.downalert(host)
	end
	end
	end
end

class DataInitClass
        
	def StoreToPool
	fcd = FetchDataClass.new()
	fcd.fetch	
	end

	def init()     
#	fcd = FetchDataClass.new()
#	fcd.fetch
	unless $downips.empty? 
#	if !$downips.empty?
	$downips.each do |downip|
	DownPingClass.new.downhttpcheck(downip) #unless $downips.empty?
	end
	end 
	$ipstore.each do |ipsend|
	PingClass.new.httpcheck(ipsend)
	end
	end	
end

class ShowPool
	def downpool
	$downips.inspect
	end
	def uppool
	$ipstore.inspect
	end
end
end
