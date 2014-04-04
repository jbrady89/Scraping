require 'HTTParty'
require 'securerandom'
require 'uri'
require 'time'
require 'active_support/all'
require 'oauth2'

CLIENT_ID = "bebedacec262f1c8490fe8efbee259a9547898eb"
CLIENT_SECRET = "11ae1c7df03482894ac3d665140d270d75c2f766"
TOKEN = "edb561bc411ac2ac53b482cd29a9c9be"

categories = 	{
					'Activism & Non Profits' => 'activism',
					'Animation & Motion Graphics' => 'animation', 
					'Art' => 'art',
					'Comedy' => 'comedy',
					'Education & DIY' => 'education', 
					'Everyday Life' => 'everyday',
					'Experimental' => 'experimental',
					'Fashion' => 'fashion',
					'Films' => 'films',
					'HD' => 'hd',
					'Music' => 'music',
					'Nature' => 'nature',
					'Products & Equipment' => 'productsandequipment',
					'Science & Tech' => 'technology',
					'Sports' => 'sports',
					'Travel & Events' => 'travel',
					'Vimeo Projects' => 'vimeoprojects',
					'Web Series' => 'webseries'
				}

count = 0
last_week = []
last_month = []
yesterday = []
site_path = 'https://api.vimeo.com'
client = OAuth2::Client.new(CLIENT_ID, CLIENT_SECRET, {:site => site_path, :signature_method => "HMAC-SHA1", :scheme => :header })
token = OAuth2::AccessToken.new(client, TOKEN)

categories.each do |category_name, cat_uri|
	begin
		p category_name
		for i in 1..150
			page_number = i.to_s
			videos = token.get('/categories/' + cat_uri + '/videos?sort=plays&page=' + page_number + '&per_page=100')
			hash = JSON.parse(videos.body)
			hash["data"].each do |a|
				if a['created_time'] > 1.month.ago.to_s && a['stats']['plays'].to_i > 10000
					p a['stats'], a['created_time'], "last_month"
					last_month.push(a['created_time'])
					count += 1
					elsif a['created_time'] > 1.week.ago.to_s && a['stats']['plays'].to_i > 1000
						p a['stats'], a['created_time'], "last_week"
						last_week.push(a['created_time'])
						count += 1
					elsif a['created_time'] > 1.day.ago.to_s && a['stats']['plays'].to_i > 100
						p a['stats'], a['created_time'], "yesterday"
						yesterday.push(a['created_time'])
						count += 1
				end
			end
			p i
		end
	rescue
		next
	end
end
p "Month: " + last_month.uniq.length.to_s, "Week: " + last_week.uniq.length.to_s, "yesterday: " + yesterday.uniq.length.to_s
p count
#11:02
#code = client.auth_code.authorize_url(:redirect_uri => "http://localhost:3000")
#p code
#token = client.auth_code.get_token(code, :redirect_uri => "http://localhost:3000")

#response = token.get('https://api.vimeo.com/categories/music/videos?sort=date')

#puts response.body

