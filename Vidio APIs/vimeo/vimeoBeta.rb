require 'HTTParty'
require 'securerandom'
require 'uri'
require 'time'
require 'active_support/all'
require 'oauth2'

CLIENT_ID = "bebedacec262f1c8490fe8efbee259a9547898eb"
CLIENT_SECRET = "11ae1c7df03482894ac3d665140d270d75c2f766"
TOKEN = "edb561bc411ac2ac53b482cd29a9c9be"
count = 0
site_path = 'https://api.vimeo.com'
redirect_uri = 'http://szl.it'
client = OAuth2::Client.new(CLIENT_ID, CLIENT_SECRET, {:site => site_path, :signature_method => "HMAC-SHA1", :scheme => :header })
token = OAuth2::AccessToken.new(client, TOKEN)
for i in 1..100
	page_number = i.to_s
	videos = token.get('/categories/music/videos?sort=plays&page=' + page_number + '&per_page=100')
	hash = JSON.parse(videos.body)
	hash["data"].each do |a|
		if a['created_time'] > 1.month.ago.to_s && a['stats']['plays'].to_i > 10000
			p a['stats'], a['created_time'], "last_month"
			count += 1
			elsif a['created_time'] > 1.week.ago.to_s && a['stats']['plays'].to_i > 1000
				p a['stats'], a['created_time'], "last_week"
				count += 1
			elsif a['created_time'] > 1.day.ago.to_s && a['stats']['plays'].to_i > 100
				p a['stats'], a['created_time'], "yesterday"
				count += 1
		end
	end
end
p count += 1
#code = client.auth_code.authorize_url(:redirect_uri => "http://localhost:3000")
#p code
#token = client.auth_code.get_token(code, :redirect_uri => "http://localhost:3000")

#response = token.get('https://api.vimeo.com/categories/music/videos?sort=date')

#puts response.body

