#$:.unshift(File.join(File.dirname(__FILE__), '..', 'ext'))
$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rubygems'
require 'optparse'
require 'curb'

require 'google_api_helper.rb'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: upload_photo.rb [options]"

  opts.on('-u', '--username USERNAME/EMAIL', 'Username/Email') { |v| options[:email_address] = v }
  opts.on('-p', '--password PASSWORD', 'Password') { |v| options[:password] = v }
  opts.on('-n', '--albumname ALBUM_NAME', 'Album Name') { |v| options[:album_name] = v }
  opts.on('-f', '--file FILE', 'Full File Path') { |v| options[:full_file_path] = v }

end.parse!

apiHelper = GoogleApiHelper.new(options[:email_address], options[:password])

albumName = options[:album_name]
fileToUpload = options[:full_file_path]

#Get list of albums
addImageToAlbumLink = apiHelper.retrieveUploadImageLink(albumName)
puts "Album Exists: #{!addImageToAlbumLink.nil?}"  if $DEBUG
if(addImageToAlbumLink.nil?)
  addImageToAlbumLink = apiHelper.createNewAlbum(albumName)
end

apiHelper.addImageToAlbum(addImageToAlbumLink, fileToUpload)

puts "Successfully uploaded #{fileToUpload} to album #{albumName}. Run with --debug switch to see other debug statements."



