require 'HTTParty'
require 'active_support/all'
require 'oauth2'

CLIENT_ID = "bebedacec262f1c8490fe8efbee259a9547898eb"
CLIENT_SECRET = ""
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
	too_old = false
	p category_name
	for i in 1..300
		page_number = i.to_s
		videos = token.get('/categories/' + cat_uri + '/videos?sort=date&page=' + page_number + '&per_page=100')
		hash = JSON.parse(videos.body)
		#p hash['data']
		hash["data"].each do |a|
			unless a['created_time'] < 1.months.ago.to_s
				if a['created_time'] > 1.month.ago.to_s && a['stats']['plays'].to_i > 5000
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
			else
				too_old = true
			end
		end
		if too_old == true
			p "breaks"
			break
		end
		p i
	end
end
p "Month: " + last_month.uniq.length.to_s, "Week: " + last_week.uniq.length.to_s, "yesterday: " + yesterday.uniq.length.to_s
p last_month.length, last_week.length, yesterday.length

