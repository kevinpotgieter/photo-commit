require 'photo_upload_helper.rb'

class GoogleApiHelper

  def initialize(username, password)
    @username = username
    @password = password
    @photoUploadHelper = PhotoUploadHelper.new
  end

  private
  attr_accessor :authorisationHash
  attr_accessor :username, :password
  attr_accessor :photoUploadHelper

  LOGIN_URL = "https://www.google.com/accounts/ClientLogin"
  HOME_URL = "https://picasaweb.google.com/data/feed/api/user/default"

  def login()
    c = Curl::Easy.http_post(LOGIN_URL,
                             Curl::PostField.content('Email', @username),
                             Curl::PostField.content('Passwd', @password),
                             Curl::PostField.content('accountType', 'GOOGLE'),
                             Curl::PostField.content('source', 'git-photo-commit'),
                             Curl::PostField.content('service', 'lh2'))



    authResponseHash = Hash[c.body_str.each_line.map { |l| l.chomp.split('=', 2) }]

    @authorisationHash = authResponseHash["Auth"]
    puts "Auth hash from login : #{authResponseHash["Auth"]}" if $DEBUG

  end

  def getListOfAlbums()
    if (@authorisationHash.to_s.empty?)
      login()
    end

    c = Curl.get(HOME_URL) do |http|
      http.headers['Authorization'] = constructAuthorisationString()
    end

    c.body_str
  end

  # This was being used in a lot of places, may as well move it to one method.
  def constructAuthorisationString
    "GoogleLogin auth=#{@authorisationHash}"
  end

  public
  def retrieveUploadImageLink(albumName)
    xmlDoc = Nokogiri::XML(getListOfAlbums)
    uploadImageLink = photoUploadHelper.getUploadNewImageLink(xmlDoc, albumName)
    # If we can obtain the upload Image Link to the Album, then it obviously exists
    return uploadImageLink
  end

  def createNewAlbum(albumName)
    # Try to retreive the POST link in order to create the album
    xmlDocListAlbums = Nokogiri::XML(getListOfAlbums)

    # Load the xml template which we'll change shortly
    createTemplateXml = photoUploadHelper.createNewAlbumTemplateForSubmit(albumName)

    postLink = photoUploadHelper.getCreateAlbumLink(xmlDocListAlbums)

    puts "Create Template for submit: #{createTemplateXml.to_s}" if $DEBUG

    # Setup the creation of the album
    c = Curl::Easy.http_post(postLink, createTemplateXml.to_s) do |http|
      http.headers['Authorization'] = constructAuthorisationString()
      http.headers['Content-Type'] = "application/atom+xml"
    end

    puts "Response from Creating Album: #{c.body_str}" if $DEBUG

    retrieveUploadImageLink(albumName)
  end

  def addImageToAlbum(albumLink, imageLocation)

    stringBinary = File.open(imageLocation, 'r') do |file|
      file.read
    end

    c = Curl::Easy.http_post(albumLink, stringBinary) do |http|
      http.headers['Authorization'] = constructAuthorisationString()
      http.headers['Content-Type'] = "image/jpeg"
    end

    puts "Response from image Upload: #{c.body_str} \nCode: #{c.response_code}" if $DEBUG
  end

end