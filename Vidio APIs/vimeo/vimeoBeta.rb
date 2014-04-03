require 'HTTParty'
require 'securerandom'
require 'uri'
require 'time'
require 'active_support/all'
require 'oauth2'


class Vimeo
	include HTTParty
	base_uri 'http://api.vimeo.com'
end


CONSUMER_KEY = "bebedacec262f1c8490fe8efbee259a9547898eb"
SECRET = "11ae1c7df03482894ac3d665140d270d75c2f766"
TOKEN = "4c9903b8ecf4589d5cd0cdfb01129b02"
TOKEN_SECRET = "870fec4bc472c222ffddb8b8fe40ae85cc23fb59"

#trying to use beta..doesn't work

client = OAuth2::Client.new(
	CONSUMER_KEY, 
	SECRET, 
	{:site => 'http://vimeo.com', :signature_method => "HMAC-SHA1", :accept => "application/vnd.vimeo.*+json;version=3.0", :scheme => :header}
)

access_token = OAuth2::AccessToken.new(client, TOKEN)
#p access_token
#parsed = OAuth2::Response.methods
#p parsed
video = access_token.get('/categories/music/videos?sort=date')
p video.body
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
