require '/home/kilari/work/ruby/vpswork/smtp-tls'
require 'net/smtp'

module SendAlert

	def self.downalert(to="vamsikilari@gmail.com", host='rptest.railsplayground.net')
	@to = to
	@host = host
	@time = Time.gm(*Time.now.to_a)
	msgstr = <<_END_OF_MESSAGE
	From: ALERT <vpsdownalert@gmail.com>     
	
	TO: #{@to}
	Subject: Down Alert

	#{host} IS DOWN from #{@time} 
_END_OF_MESSAGE
        smtp = Net::SMTP.start('smtp.gmail.com', 25, 'gmail.com', 'vpsdownalert@gmail.com', 'kilarivamsikrishna123', :login)
        smtp.send_message msgstr, 'vpsdownalert@gmail.com', @to
        puts "Alert sent"
	smtp.finish

	end

	def upalert
	end

end

