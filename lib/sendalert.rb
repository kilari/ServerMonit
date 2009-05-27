require 'net/smtp'
require 'resolv'
require File.dirname(__FILE__) + "/smtp-tls"
module SendAlert

	$downtime = Hash.new
        def alert(from, to, msg)
        from = from
        to = to
        msg = msg
        smtp = Net::SMTP.start('smtp.gmail.com', 25, 'gmail.com', from, '*****', :login)
        smtp.send_message msg, from, to
        smtp.finish
        end

        def downalert(host='rptest.railsplayground.net',starttime = Time.now, to="vamsikilari@gmail.com")
        to = to
        ip = host
	begin
        host = Resolv.getname(host)
        rescue
        host = host
        end
        $downtime["#{host}"] = starttime unless $downtime.has_key?("#{host}")
	msgstr = <<_END_OF_MESSAGE
        From:ALERT <vpsdownalert@gmail.com>,
        TO:#{to}
        Subject:Down Alert

        #{host}(#{ip}) is DOWN from #{$downtime["#{host}"]}
_END_OF_MESSAGE
        alert("vpsdownalert@gmail.com", to, msgstr)
	end

        def upalert(host='rptest.railsplayground.net',stoptime = Time.now, to="vamsikilari@gmail.com")
        to = to
        begin
        host = Resolv.getname(host)
        rescue
        host = host
        end
	uptime = ((caltime(host, stoptime))/60).to_i
        $downtime.delete("#{host}")
	time = Time.gm(*Time.now.to_a)
        msgstr = <<_END_OF_MESSAGE
        From: UPALERT <vpsupalert@gmail.com>,
        TO: #{to}
        Subject: UP Alert

        #{host} IS UP at #{time} after #{uptime} minutes of downtime
_END_OF_MESSAGE
        alert('vpsupalert@gmail.com', to, msgstr)
        end

	def caltime(host, stoptime = Time.now)
	stoptime - $downtime["#{host}"]  
	end
end

