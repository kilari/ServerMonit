require 'net/smtp'
require 'resolv'
require File.dirname(__FILE__) + "/smtp-tls"
module SendAlert

class SendMail
	$downtime = Hash.new
        def self.alert(from, to, msg)
        from = from
        to = to
        msg = msg
        smtp = Net::SMTP.start('smtp.gmail.com', 25, 'gmail.com', from, 'passwd', :login)
        smtp.send_message msg, from, to
        smtp.finish
        end

        def self.downalert(host='rptest.railsplayground.net', to="vamsikilari@gmail.com",starttime = Time.now)
        to = to
        begin
        host = Resolv.getname(host)
        rescue
        host = host
        end
        time = Time.gm(*Time.now.to_a)
        $downtime["#{host}"] = starttime unless $downtime.has_key?("#{host}")
	msgstr = <<_END_OF_MESSAGE
        From: ALERT <vpsdownalert@gmail.com>,
        TO: #{to}
        Subject: Down Alert

        #{host} IS DOWN from #{time}
_END_OF_MESSAGE
        SendMail.alert("vpsdownalert@gmail.com", to, msgstr)
        end

        def self.upalert(host='rptest.railsplayground.net', to="vamsikilari@gmail.com")
        to = to
        begin
        host = Resolv.getname(host)
        rescue
        host = host
        end
	stoptime = Time.now
	uptime = ((SendMail.caltime(host, stoptime))/60).to_i
        $downtime.delete("#{host}")
	time = Time.gm(*Time.now.to_a)
        msgstr = <<_END_OF_MESSAGE
        From: UPALERT <vpsupalert@gmail.com>,
        TO: #{to}
        Subject: UP Alert

        #{host} IS UP at #{time} after #{uptime} minutes of downtime
_END_OF_MESSAGE
        SendMail.alert('vpsupalert@gmail.com', to, msgstr)
        end

	def self.caltime(host, stoptime = Time.now)
	stoptime - $downtime["#{host}"]  
	end
	def self.showhash
	$downtime.each { |key, value| puts "#{key} => #{value}"}  
	end 
end
end

