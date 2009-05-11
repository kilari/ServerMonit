require 'rubygems'
require 'net/ping'
require File.dirname(__FILE__) + "/sendalert"
module DataMod
class FetchDataClass
	
#This method will fetch the IP's from the lib/data file and store it to the upips Array.
	def fetch
	$upips = []
	if File.size?(File.dirname(__FILE__) + '/../config/data') #checks if the file is present and not empty
	File.open(File.dirname(__FILE__) + '/../config/data', 'r').each do |ip|
	ip.scan(/\S+/) do |ip1|
	$upips << ip1
	end
	end
	else
	puts "Data file not present or is empty"
	exit 1
	end
	end
end

class PingClass
        def httpcheck(host = "74.63.10.108")
	begin
	if Net::PingTCP.new(host, 80).ping #will ping the host on the specified port.
	puts "alive #{host} from pingclass"
	
	else 
	starttime = Time.now
	puts "Down #{host} from pingclass"
#If the host is down , it will push the IP to the downips Array and place a nil value at that index and delete the host. This is done bcoz if the IP is directly deleted the next IP's index will be decreased and will be skiped from checking in the clalling methods block.
	$downips << host
	$upips.insert($upips.index(host), nil)
	$upips.delete_at($upips.index(host))
	SendAlert::SendMail.downalert(host,starttime)
	end

	rescue
	end

	end
end

class DownPingClass
	$downips = []
	def downhttpcheck(host)
	begin
	if Net::PingTCP.new(host, 80).ping
#If the host is up, it will push the IP to the upips Array and place a nil value at that index and delete the host. This
#is done bcoz if the IP is directly deleted the next IP's index will be decreased and will be skiped from checking in the calling methods block.
	stoptime = Time.now
	$upips << host
	$downips.insert($downips.index(host), nil)
	$downips.delete_at($downips.index(host))
	puts "up #{host} from downpingclass"
	SendAlert::SendMail.upalert(host, stoptime)

	else 
	puts "down #{host} from downpingclass"
	SendAlert::SendMail.downalert(host)

	end
	rescue
	end
	end
end

class DataInitClass
       
#Will store the IP's from lib/data file to upips Array for the first time when the Daemon starts.
	def storetopool
	fcd = FetchDataClass.new()
	fcd.fetch	
	end

#This is the main method which will iterate.
	def init()     
	unless $downips.empty? #checks if the downips Array is empty.
	$downips.each do |downip|
	unless downip == "nil" #Checks if the donwips Array contains any nil values.
        DownPingClass.new.downhttpcheck(downip) 
        end
        end
	end
        $upips.each do |ipsend|
	unless ipsend == "nil" #Checks if the upips Array contains any nil values.
        PingClass.new.httpcheck(ipsend)
        end
	end
	$downips = $downips.compact #Will remove the nil values, inserted when a IP is up again, from the array.
	$upips = $upips.compact     #Will remove nil values from the array.
	end	

	def downpool 	#Helper methods to show the downips Array when required.
	$downips.inspect
	end
	def uppool	#Helper method to show the upips Array when required.
	$upips.inspect
	end
	def showhash	#Helper method to show the downtime Hash
	SendAlert::SendMail.showhash	
	end
end
end
