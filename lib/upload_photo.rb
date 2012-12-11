#$:.unshift(File.join(File.dirname(__FILE__), '..', 'ext'))
#$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
#require 'curb'
#
#$EMAIL = '<YOUR GMAIL LOGIN>'
#$PASSWD = '<YOUR GMAIL PASSWORD>'
#
#url = 'https://www.google.com/accounts/ServiceLoginAuth'
#
#fields = [
#  Curl::PostField.content('ltmpl','m_blanco'),
#  Curl::PostField.content('ltmplcache', '2'),
#  Curl::PostField.content('continue',
#                          'http://mail.google.com/mail/?ui.html&amp;zy=l'),
#  Curl::PostField.content('service', 'mail'),
#  Curl::PostField.content('rm', 'false'),
#  Curl::PostField.content('rmShown', '1'),
#  Curl::PostField.content('PersistentCookie', ''),
#  Curl::PostField.content('Email', $EMAIL),
#  Curl::PostField.content('Passwd', $PASSWD)
#]
#
#c = Curl::Easy.http_post(url, *fields) do |curl|
#  # Gotta put yourself out there...
#  curl.headers["User-Agent"] = "Curl/Ruby"
#
#  # Let's see what happens under the hood
#  curl.verbose = true
#
#  # Google will redirect us a bit
#  curl.follow_location = true
#
#  # Google will make sure we retain cookies
#  curl.enable_cookies = true
#end
#
#puts "FINISHED: HTTP #{c.response_code}"
#puts c.body_str

require 'rubygems'
require 'optparse'
require 'curb'
#https://www.google.com/accounts/ClientLogin \
#--data-urlencode Email=brad.gushue@example.com --data-urlencode Passwd=new+foundland \
#-d accountType=GOOGLE \
#-d source=Google-cURL-Example \
#-d service=lh2

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: upload_photo.rb [options]"

  opts.on('-u', '--username USERNAME/EMAIL', 'Username/Email') { |v| options[:email_address] = v }
  opts.on('-p', '--password PASSWORD', 'Password') { |v| options[:password] = v }

end.parse!


c = Curl::Easy.http_post("https://www.google.com/accounts/ClientLogin",
                         Curl::PostField.content('Email', options[:email_address]),
                         Curl::PostField.content('Passwd', options[:password]),
                         Curl::PostField.content('accountType', 'GOOGLE'),
                         Curl::PostField.content('source', 'Google-cURL-Example'),
                         Curl::PostField.content('service', 'lh2'))

c.perform
puts c.body_str