require 'rubygems'
require 'net/ping'
require File.dirname(__FILE__) + "/sendalert"
module DataMod
class FetchDataClass
	
	def fetch
	$upips = []
	File.open(File.dirname(__FILE__) + '/data', 'r').each do |ip|
	ip.scan(/\S+/) do |ip1|
	$upips << ip1
	end
	end
	
	end
end

class PingClass
        def httpcheck(host = "74.63.10.108")
	if Net::PingTCP.new(host, 80).ping
	puts "alive #{host} from pingclass"
	
	else 
	puts "Down #{host} from pingclass"
	$downips << host
	$upips.insert($upips.index(host), nil)
	$upips.delete_at($upips.index(host))

	SendAlert::SendMail.downalert(host)

	end
	end
end

class DownPingClass
	$downips = []
	def downhttpcheck(host)
	if Net::PingTCP.new(host, 80).ping
	$upips << host
	$downips.insert($downips.index(host), nil)
	$downips.delete_at($downips.index(host))
	puts "up #{host} from downpingclass"
	SendAlert::SendMail.upalert(host)

	else 
	puts "down #{host} from downpingclass"
	SendAlert::SendMail.downalert(host)

	end
	end
end

class DataInitClass
        
	def storetopool
	fcd = FetchDataClass.new()
	fcd.fetch	
	end

	def init()     
	unless $downips.empty? 
	$downips.each do |downip|
	unless downip == "nil"
        DownPingClass.new.downhttpcheck(downip) 
        end
        end
	end
        $upips.each do |ipsend|
	unless ipsend == "nil"
        PingClass.new.httpcheck(ipsend)
        end
	end
	$downips = $downips.compact
	$upips = $upips.compact
	end	

	def downpool
	$downips.inspect
	end
	def uppool
	$upips.inspect
	end
	def showhash
	SendAlert::SendMail.showhash	
	end
end
end
