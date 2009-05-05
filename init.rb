require '/home/kilari/work/ruby/vpswork/ping1'

module InitModd
class InitClass

	def init
	DataMod::DataInitClass.new.init
	end
	
end
loop do
InitClass.new.init
sleep 45
end
end
