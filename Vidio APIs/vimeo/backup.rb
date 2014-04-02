require 'HTTParty'
require 'securerandom'
require 'uri'
require 'time'
require 'active_support/all'
require 'oauth'


class VimeoVideos
	include HTTParty
	base_uri 'vimeo.com'
end


CONSUMER_KEY = "bebedacec262f1c8490fe8efbee259a9547898eb"
SECRET = "11ae1c7df03482894ac3d665140d270d75c2f766"
TOKEN = "4c9903b8ecf4589d5cd0cdfb01129b02"
TOKEN_SECRET = "870fec4bc472c222ffddb8b8fe40ae85cc23fb59"

categories = 	{
					'Activism & Non Profits' => 'activism',
					'Animation & Motion Graphics' => 'animation', 
					'Art' => 'art',
					'Branded' => 'branded', 
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

consumer = OAuth::Consumer.new( CONSUMER_KEY,SECRET, {:site => "http://vimeo.com", :signature_method => "HMAC-SHA1", :scheme => :header })
access_token = OAuth::AccessToken.new( consumer, TOKEN,TOKEN_SECRET)
vidios = []
yesterday = []
last_week = []
last_month = []
timeframe = { "today" => 1.day.ago, "last_week" => 1.week.ago, "last_month" => 1.month.ago }
categories.each do |cat_key, value|
	begin
		#category_name = category.gsub(/\s+/, "")
		#category_name = category_name.gsub("&", "%2526").gsub("%20", "%2520")
		p value
		#count = 0
		for i in 1..100
			p i
			result = access_token.get("/api/rest/v2?format=json&method=vimeo.categories.getRelatedVideos&category=" + value + "&page=" + i.to_s + "&per_page=100")
			response = JSON.parse(result.body)
			response['videos']['video'].each do |a|
				#count += 1
				#p count
				id = a['id']
				upload_date = a['upload_date']
				if upload_date > 24.hours.ago.to_s
						response = access_token.get('/api/rest/v2?format=json&method=vimeo.videos.getInfo&video_id=' + id)
						vid_info = JSON.parse(response.body)
						#p vid_info['video']
						views = vid_info['video'][0]['number_of_plays']
						p "yesterday", views
						if views.to_i > 100
							#p views
							vidios.push(id)
							yesterday.push(id)
							p "true"
							p "total: " + vidios.uniq.length.to_s, "yesterday: " + yesterday.uniq.length.to_s, "last week: " + last_week.uniq.length.to_s, "last month: " + last_month.uniq.length.to_s
						end
				end
				if upload_date > 1.week.ago.to_s
						response = access_token.get('/api/rest/v2?format=json&method=vimeo.videos.getInfo&video_id=' + id)
						vid_info = JSON.parse(response.body)
						#p vid_info['video']
						views = vid_info['video'][0]['number_of_plays']
						p "last_week", views
						if views.to_i > 1000
							vidios.push(id)
							last_week.push(id)
							#p "last week", views
							p "true"
							p "total: " + vidios.uniq.length.to_s, "yesterday: " + yesterday.uniq.length.to_s, "last week: " + last_week.uniq.length.to_s, "last month: " + last_month.uniq.length.to_s
						end
				end
				if upload_date > 1.month.ago.to_s
						response = access_token.get('/api/rest/v2?format=json&method=vimeo.videos.getInfo&video_id=' + id)
						vid_info = JSON.parse(response.body)
						#p vid_info['video']
						views = vid_info['video'][0]['number_of_plays']
						p "last_month", views
						if views.to_i > 10000
							vidios.push(id)
							last_month.push(id)
							p "last month", views
							p "total: " + vidios.uniq.length.to_s, "yesterday: " + yesterday.uniq.length.to_s, "last week: " + last_week.uniq.length.to_s, "last month: " + last_month.uniq.length.to_s
						end
				end
			end
		end
	rescue 
		next
	end
end
p "total: " + vidios.uniq.length.to_s, "yesterday: " + yesterday.uniq.length.to_s, "last week: " + last_week.uniq.length.to_s, "last month: " + last_month.uniq.length.to_s
