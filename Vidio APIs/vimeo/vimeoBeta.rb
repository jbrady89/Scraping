require 'HTTParty'
require 'securerandom'
require 'uri'
require 'time'
require 'active_support/all'
require 'oauth2'


class Vimeo
	include HTTParty
	base_uri 'https://api.vimeo.com'
end


CLIENT_ID = "8259c0b83a073875ca9b180dad67a89b7d100393"
CLIENT_SECRET = "8259e78b8ff789dcc13543417059c60d0284aceb"
TOKEN = "5958de4639ca527ff7edd1082bb352c7"

#p JSON.parse(video.body)
#p client
#auth_url = client.auth_code.authorize_url(:redirect_uri => 'http://api.vimeo.com/oauth2/callback')
# => "https://example.org/oauth/authorization?response_type=code&client_id=client_id&redirect_uri=http://localhost:8080/oauth2/callback"
#p auth_url
#token = client.auth_code.get_token(auth_url, :redirect_uri => 'http://api.vimeo.com/oauth2/callback', :headers => {'Authorization' => 'Basic ' + SECRET})
#response = token.get('/api/resource', :params => { 'query_foo' => 'bar' })
#p token
#response.class.name
#result = Vimeo.get('/channels/staffpicks/videos?filter=content_rating&filter_content_rating=safe,unrated')
#p result
#response = JSON.parse(result.body)
#p response

require "oauth2"

site_path = 'https://api.vimeo.com'
redirect_uri = 'http://szl.it'
client = OAuth2::Client.new(CLIENT_ID, CLIENT_SECRET, {:site => site_path, :signature_method => "HMAC-SHA1", :scheme => :header })
p client
token = OAuth2::AccessToken.new(client, TOKEN)
videos = token.get('/categories/music/videos?sort=date')
hash = JSON.parse(videos.body)
p hash["data"].keys
#code = client.auth_code.authorize_url(:redirect_uri => "http://localhost:3000")
#p code
#token = client.auth_code.get_token(code, :redirect_uri => "http://localhost:3000")

#response = token.get('https://api.vimeo.com/categories/music/videos?sort=date')

#puts response.body

