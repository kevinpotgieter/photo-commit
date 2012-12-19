class GoogleApiHelper

  def initialize(username, password)
    @username = username
    @password = password
  end

  private
  attr_accessor :authorisationHash
  attr_accessor :username, :password

  def login()
    c = Curl::Easy.http_post("https://www.google.com/accounts/ClientLogin",
                             Curl::PostField.content('Email', @username),
                             Curl::PostField.content('Passwd', @password),
                             Curl::PostField.content('accountType', 'GOOGLE'),
                             Curl::PostField.content('source', 'git-photo-commit'),
                             Curl::PostField.content('service', 'lh2'))

    c.perform
    #puts c.body_str

    authResponseHash = Hash[c.body_str.each_line.map { |l| l.chomp.split('=', 2) }]

    #p authResponseHash

    @authorisationHash = authResponseHash["Auth"]
    puts "Auth hash from login : #{authResponseHash["Auth"]}"

  end

  public
  def getListOfAlbums()
    if(@authorisationHash.to_s.empty?)
      login()
    end

    c = Curl.get("http://picasaweb.google.com/data/feed/api/user/default") do|http|
      http.headers['Authorization'] = "GoogleLogin auth=#{@authorisationHash}"
    end

    c.body_str
  end


end