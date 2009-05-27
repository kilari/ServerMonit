require File.dirname(__FILE__) + '/lib/ping1'

class InitClass
include DataMod

	def pulldata
	fetch
	end
	
	def start
	init
	end
end

check = InitClass.new
check.pulldata

loop do
check.start
sleep 60
end
