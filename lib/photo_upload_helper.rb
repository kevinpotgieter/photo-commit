require 'nokogiri'

class PhotoUploadHelper

  CREATE_ALBUM_REL = "http://schemas.google.com/g/2005#post"
  CREATE_NEW_IMAGE_REL = "http://schemas.google.com/g/2005#feed"
  XML_NAMESPACE_DEFAULT = "http://www.w3.org/2005/Atom"

  CREATE_ALBUM_TEMPLATE_NAME = "create_album_title.xml"

  def getCreateAlbumLink(xmlDoc)
    postLink = xmlDoc.xpath("//feed:link[@rel=\"#{CREATE_ALBUM_REL}\"]", "feed" => "#{XML_NAMESPACE_DEFAULT}").first()
    puts "POST link: #{postLink.xpath('@href').to_s}" if $DEBUG
    puts "Album Creation Link : #{postLink.xpath('@href').to_s}" if $DEBUG
    postLink.xpath('@href').to_s
  end

  def createNewAlbumTemplateForSubmit(albumName)
    f = File.open("#{File.dirname(__FILE__)}/#{CREATE_ALBUM_TEMPLATE_NAME}", 'r')
    createTemplateXml = Nokogiri::XML(f)
    f.close

    titleElement = createTemplateXml.at_css "title"
    titleElement.content = albumName
    createTemplateXml
  end

  def getUploadNewImageLink(xmlDoc, albumName)
    xmlDoc.xpath("//feed:entry", "feed" => "#{XML_NAMESPACE_DEFAULT}").collect do |element|
      actualAlbumName = element.at_css("title").content()
      createLink = element.css("link[rel='#{CREATE_NEW_IMAGE_REL}']").xpath('@href').text()

      puts "actualAlbumName : #{actualAlbumName}" if $DEBUG
      puts "createLink : #{createLink}" if $DEBUG

      if(albumName.eql?(actualAlbumName))
        return createLink
      end

    end

    return nil
  end
end