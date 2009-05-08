require File.dirname(__FILE__) + '/lib/ping1'

module InitModd
class InitClass

	def initialize
	@obj = DataMod::DataInitClass.new
	end
	
	def pulldata
	@obj.storetopool
	end
	
	def start
	@obj.init
	end
end

check = InitClass.new
check.pulldata

loop do
check.start
sleep 60
end
end
