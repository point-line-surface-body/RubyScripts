#!/usr/bin/ruby
# encoding:GBK
# 
# Sending Email using stmp in ruby
#
#

require 'net/smtp'	

SMTP_SERVER = 'CASArray.ad4.ad.alcatel.com' #change to your server

def send_emails(sender_address, recipients, subject, message_body)
	recipients.each do |recipient_address|
		message_header =''
		message_header << "From: <#{sender_address}>\r\n"
		message_header << "To: <#{recipient_address}>\r\n"
		message_header << "CC: 'nuaays@gmail.com'\r\n"
		message_header << "BCC:'nuaays@qq.com'\r\n"
		message_header << "Subject: #{subject}\r\n"
		message_header << "Date: " + Time.now.to_s + "\r\n"
		message_header << "Importance: 3\r\n"
		message = message_header + "\r\n" + message_body + "\r\n"
		Net::SMTP.start(SMTP_SERVER, 25) do |smtp|
			smtp.send_message(message, sender_address, recipient_address)
		end
	end
end
send_emails('lingling.du@alcatel-sbell.com.cn',['sen.b.yang@alcatel-sbell.com.cn'],'test Email Sent from Ruby',"Hi there this is a test email hope you like it")



#method 1
=begin
msgstr = <<EOF
From: from@example.org
To: to@example.org
Cc: cc@example.org
Subject: Test BCC

This is a test message.
EOF

Net::SMTP.start(smtp_server, 25) do |smtp|
  smtp.send_message msgstr, 'from@example.org', 
    'to@example.org', 'cc@example.org', 'bcc@example.org'
end
=end



#method 2 mailfactory
=begin
#http://rubygems.org/gems/mime-types
#http://rubygems.org/gems/mailfactory
#http://mailfactory.rubyforge.org/

require 'net/smtp'
require 'rubygems'
require 'mailfactory'

def sendemail(from,to,subject,body,file)
	#SMTP_SERVER = 'CASArray.ad4.ad.alcatel.com' #change to your server
	mail = MailFactory.new()
	mail.from = from
	mail.to = to
	#mail.from = "lingling.du@alcatel-sbell.com.cn"
	#mail.to = ['sen.b.yang@alcatel-sbell.com.cn','nuaays@gmail.com'].join(',')
	mail.subject = subject
	mail.text = body
	#mail.html = "A little something <b>special</b> for people with HTML readers"
	mail.attach(file)
	#mail.attach("D:\\test.rb")
	#msgstr = message_body + "\r\n"
	Net::SMTP.start('CASArray.ad4.ad.alcatel.com',25) do |smtp|
		smtp.send_message(mail.to_s, mail.from, mail.to)
	end
	=begin
	smtp = Net::SMTP.new('CASArray.ad4.ad.alcatel.com', 25)
	smtp.enable_ssl
	smtp.start('alcatel-sbell.com.cn','sen.b.yang@alcatel-sbell.com.cn','nuaays1987!', :login) do
  		smtp.send_message(mail.to_s, mail.from, mail.to)
	end
	=end
end


sendemail('lingling.du@alcatel-sbell.com.cn','sen.b.yang@alcatel-sbell.com.cn','Test Ruby Email','Just a Test',"D:\\test.rb")
=end


# method 3
=begin
SMTP_HOST = "127.0.0.1"
def send(from, to, subject, msg)
  mail = "To: #{to}\r\n" +
         "From: #{from}\r\n" +
         "Subject: #{subject}\r\n" +
         "\r\n" +msg
  Net::SMTP.start(SMTP_HOST) do |smtp|
    smtp.send_mail(mail, from, to)
  end
end
from = "nuaays@gmail.com"
to = ["sen.b.yang@alcatel-sbell.com.cn"]
send(from, to, "test", "Just a test!\ntest")
=end

# method 4
=begin
require 'simplemail'
mail = SimpleMail.new
mail.to = "sen.b.yang@alcatel-sbell.com.cn"
mail.from = "lingling.du@alcatel-sbell.com.cn"
mail.sender = "bounce@rubycookbook.org"
mail.subject = "This is a test"
mail.text = "This is some text in the text."
mail.html = "<b>big html stuff</b>"
mail.headers["X-Foobar"] = "Baz"
mail.attachementst << "D:\\test.rb"
mail.send
=end




#Reference
#http://www.ruby-doc.org/stdlib-1.9.3/libdoc/net/smtp/rdoc/Net/SMTP.html
#http://www.ensta-paristech.fr/~diam/ruby/online/ruby-doc-stdlib/libdoc/net/smtp/rdoc/index.html
#http://www.tutorialspoint.com/ruby/ruby_sending_email.htm
#https://www.ruby-toolbox.com/categories/e_mail