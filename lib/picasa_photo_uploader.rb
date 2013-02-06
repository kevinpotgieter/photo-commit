#This file is used for command line usage, where you can run in debug mode. It delegates to the Class which handles gem usage.
$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'PicasaPhotoUploader.rb'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: picasa_photo_uploader.rb [options]"

  opts.on('-u', '--username USERNAME/EMAIL', 'Username/Email') { |v| options[:email_address] = v }
  opts.on('-p', '--password PASSWORD', 'Password') { |v| options[:password] = v }
  opts.on('-n', '--albumname ALBUM_NAME', 'Album Name') { |v| options[:album_name] = v }
  opts.on('-f', '--file FILE', 'Full File Path') { |v| options[:full_file_path] = v }

end.parse!

PicasaPhotoUploader.snapAndUpload(options[:email_address], options[:password],options[:album_name], options[:full_file_path])





