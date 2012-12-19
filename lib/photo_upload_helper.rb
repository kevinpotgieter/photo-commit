require 'nokogiri'

class PhotoUploadHelper

  def doesAlbumExist(xmlDoc, albumName)
    albumsList = xmlDoc.xpath('//feed:title[text()="Instant Upload"]', 'feed' => 'http://www.w3.org/2005/Atom')[0].content()
    albumsList.eql? albumName
  end
end