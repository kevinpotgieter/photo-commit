Gem::Specification.new do |s|
  s.name        = 'picasa-photo-uploader'
  s.version     = '0.0.1'
  s.date        = '2012-12-27'
  s.summary     = "Upload photo taken to G+/Picasa Album"
  s.description = "A simple gem to take a photo and upload it to picasa albums"
  s.authors     = ["Kevin Potgieter"]
  s.email       = 'potgieter.kevin@gmail.com'
  s.files       = ["lib/PicasaPhotoUploader.rb"]
  s.homepage    =
    'http://rubygems.org/gems/picasa-photo-uploader'
  s.add_dependency('curb', '>= 0.8.3')
  s.add_dependency('nokogiri', '>= 1.5.5')
  s.add_dependency('imagesnap', '>= 0.0.1')
end