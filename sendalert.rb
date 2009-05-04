require '/home/kilari/work/ruby/vpswork/smtp-tls'
require 'net/smtp'

module SendAlert

def self.alert(from, to, msg)
from = from
to = to
msg = msg
 smtp = Net::SMTP.start('smtp.gmail.com', 25, 'gmail.com', from, 'kilarivamsikrishna123', :login)
        smtp.send_message msg, from, to
        smtp.finish

end

	def self.downalert(host='rptest.railsplayground.net', to="vamsikilari@gmail.com")
	to = to
	host = host
	@time = Time.gm(*Time.now.to_a)
	msgstr = <<_END_OF_MESSAGE
	From: ALERT <vpsdownalert@gmail.com>     
	TO: #{@to}
	Subject: Down Alert

	#{host} IS DOWN from #{@time} 
_END_OF_MESSAGE
SendAlert.alert("vpsdownalert@gmail.com", to, msgstr)

	end

	def self.upalert(host='rptest.railsplayground.net', to="vamsikilari@gmail.com")
	to = to 
	host = host
        time = Time.gm(*Time.now.to_a)
        msgstr = <<_END_OF_MESSAGE
        From: UPALERT <vpsupalert@gmail.com>     
        TO: #{@to}
        Subject: UP Alert

        #{host} IS UP at #{@time} 
_END_OF_MESSAGE
	SendAlert.alert('vpsupalert@gmail.com', to, msgstr)
	end

end

