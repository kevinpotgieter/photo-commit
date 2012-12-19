#$:.unshift(File.join(File.dirname(__FILE__), '..', 'ext'))
$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
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
require 'nokogiri'

require 'photo_upload_helper.rb'
require 'google_api_helper.rb'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: upload_photo.rb [options]"

  opts.on('-u', '--username USERNAME/EMAIL', 'Username/Email') { |v| options[:email_address] = v }
  opts.on('-p', '--password PASSWORD', 'Password') { |v| options[:password] = v }
  opts.on('-an', '--albumname ALBUM_NAME', 'Album Name') { |v| options[:album_name] = v }

end.parse!

photoUploadHelper = PhotoUploadHelper.new
apiHelper = GoogleApiHelper.new(options[:email_address], options[:password])

#c = Curl::Easy.http_post("https://www.google.com/accounts/ClientLogin",
#                         Curl::PostField.content('Email', options[:email_address]),
#                         Curl::PostField.content('Passwd', options[:password]),
#                         Curl::PostField.content('accountType', 'GOOGLE'),
#                         Curl::PostField.content('source', 'git-photo-commit'),
#                         Curl::PostField.content('service', 'lh2'))
#
#c.perform
#puts c.body_str
#
#authResponseHash = Hash[c.body_str.each_line.map { |l| l.chomp.split('=', 2) }]
#
#p authResponseHash
#
#puts authResponseHash["Auth"]


doc = Nokogiri::XML(apiHelper::getListOfAlbums)

p doc

#Get list of albums
albumExists = photoUploadHelper::doesAlbumExist doc, options[:album_name]
puts "album exists: #{albumExists}"
if(!albumExists)
  #photoUploadHelper::createNewAlbum options[:album_name]
end

#Get the Post link to create new entries
postLink = doc.xpath('//feed:link[@rel="http://schemas.google.com/g/2005#post"]', 'feed' => 'http://www.w3.org/2005/Atom').first()

# get the link we need to post new albums etc.
puts "POST link: #{postLink.xpath('@href').to_s}"

#Get the Self link to see what template to use in order to get/create albums
selfLink = doc.xpath('feed:entry//link[@rel="self"]', 'feed' => 'http://www.w3.org/2005/Atom').first()

# get the link we need to post new albums etc.
puts "SELF link: #{selfLink.xpath('@href').to_s}"


