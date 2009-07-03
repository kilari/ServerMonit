require 'net/smtp'
require File.dirname(__FILE__) + "/smtp-tls"

filename = "/tmp/test.xls"
mail=<<EOF
Subject: Server Status
From: Kilari <vpsupalert@gmail.com>
To: Kilari <vamsikilari@kilari.co.in>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary=\"0016e6434bcaa1decwd32d5e6\"
--0016e6434bcaa1decwd32d5e6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

Server Report.
--0016e6434bcaa1decwd32d5e6
Content-Type: application/vnd.ms-excel; name=\"#{filename}\"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="#{filename}"

#{[File.read('/tmp/test.xls')].pack('m')}
--0016e6434bcaa1decwd32d5e6--
EOF
begin 
  Net::SMTP.start('smtp.gmail.com', 25, 'gmail.com', 'vpsupalert@gmail.com', '*********', :login) do |smtp|
smtp.sendmail(mail, 'vpsupalert@gmail.com',['vamsikilari@kilari.co.in']) 
 end
rescue 
end 
