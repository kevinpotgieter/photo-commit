$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

#require 'rubygems'
require 'optparse'
require 'curb'
require 'imagesnap'

require 'google_api_helper.rb'

#This is a class used as the entry point into the PicasaPhotoUploader when using it as a gem
class PicasaPhotoUploader
    def self.snapAndUpload emailAddress="", password="", albumName="", fullFilePathForPhoto=""
      ImageSnap.snap(fullFilePathForPhoto)

      apiHelper = GoogleApiHelper.new(emailAddress, password)

      #albumName = options[:album_name]
      #fileToUpload = options[:full_file_path]

      #Get list of albums
      addImageToAlbumLink = apiHelper.retrieveUploadImageLink(albumName)
      puts "Album Exists: #{!addImageToAlbumLink.nil?}"  if $DEBUG
      if(addImageToAlbumLink.nil?)
        addImageToAlbumLink = apiHelper.createNewAlbum(albumName)
      end

      apiHelper.addImageToAlbum(addImageToAlbumLink, fullFilePathForPhoto)

      puts "Successfully uploaded #{fullFilePathForPhoto} to album #{albumName}. Run with --debug switch to see other debug statements."
    end
end