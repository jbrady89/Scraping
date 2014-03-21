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
	#result = access_token.get("/api/rest/v2?format=json&method=vimeo.categories.getAll&page=1&per_page=50")

	#p response = JSON.parse(result.body)

	#response['categories']['category'].each do |a|
		#p "Name: " + a['name'], "Total Videos: " + a['total_videos']
	#end
	vidios = []
	yesterday = []
	last_week = []
	last_month = []
	timeframe = { "today" => 1.day.ago, "last_week" => 1.week.ago, "last_month" => 1.month.ago }
	#timeframe.each do |time_key, time_period|
		categories.each do |cat_key, value|
			begin
				#category_name = category.gsub(/\s+/, "")
				#category_name = category_name.gsub("&", "%2526").gsub("%20", "%2520")
				p value
				for i in 1..100
					result = access_token.get("/api/rest/v2?format=json&method=vimeo.categories.getRelatedVideos&category=" + value + "&page=" + i.to_s + "&per_page=100")
					response = JSON.parse(result.body)
					#p response, '---'
					response['videos']['video'].each do |a|
						id = a['id']
						upload_date = a['upload_date']
						if upload_date > 1.day.ago.to_s
								#p 'last week'
								response = access_token.get('/api/rest/v2?format=json&method=vimeo.videos.getInfo&video_id=' + id)
								vid_info = JSON.parse(response.body)
								p vid_info['video']
								views = vid_info['video'][0]['number_of_plays']
								if views.to_i > 100
									p views
									vidios.push(id)
									yesterday.push(id)
									p views
									p "total: " + vidios.uniq.length.to_s, "yesterday: " + yesterday.uniq.length.to_s, "last week: " + last_week.uniq.length.to_s, "last month: " + last_month.uniq.length.to_s
								end
							elsif upload_date > 1.week.ago.to_s
								#p 'last month'
								
								response = access_token.get('/api/rest/v2?format=json&method=vimeo.videos.getInfo&video_id=' + id)
								vid_info = JSON.parse(response.body)
								p vid_info['video']
								views = vid_info['video'][0]['number_of_plays']
								if views.to_i > 1000
									vidios.push(id)
									last_week.push(id)
									p views
									p "total: " + vidios.uniq.length.to_s, "yesterday: " + yesterday.uniq.length.to_s, "last week: " + last_week.uniq.length.to_s, "last month: " + last_month.uniq.length.to_s
								end
							elsif upload_date > 1.month.ago.to_s
								#p 'yesterday'
								
								response = access_token.get('/api/rest/v2?format=json&method=vimeo.videos.getInfo&video_id=' + id)
								vid_info = JSON.parse(response.body)
								p vid_info['video']
								views = vid_info['video'][0]['number_of_plays']
								if views.to_i > 10000
									vidios.push(id)
									last_month.push(id)
									p views
									p "total: " + vidios.uniq.length.to_s, "yesterday: " + yesterday.uniq.length.to_s, "last week: " + last_week.uniq.length.to_s, "last month: " + last_month.uniq.length.to_s
								end
						end
					end
				end
			rescue 
				next
			end
		end
	#end
	p "total: " + vidios.uniq.length.to_s, "yesterday: " + yesterday.uniq.length.to_s, "last week: " + last_week.uniq.length.to_s, "last month: " + last_month.uniq.length.to_s

	#puts response.keys#['videos']['video'].each do |a|
		#puts a['id'], a['title']
	#end
=begin
	count = 0
	response['categories']['category'].each do |a|
		#p a
		name = a['name']
		name = URI.escape(name)
		#puts name
		for i in 1..100
			new_result = access_token.get('/api/rest/v2?format=json&method=vimeo.categories.getRelatedVideos&category=' + name + "&page=" + i.to_s + "&per_page=50")
			new_response = new_result.body
			#channels = new_response['channels']

			parsed = JSON.parse(new_response, symbolize_names: true)
			#puts parsed[:videos].keys
			#thekeys = parsed[:channels][:channel][0].keys
			#puts thekeys, "\n"

			unless parsed[:videos] == nil

				parsed[:videos][:video].each do |video|
					
					

					if Time.parse(video[:upload_date]) > 1.week.ago
						
						#puts video[:id]
						vid_info = access_token.get('/api/rest/v2?format=json&method=vimeo.videos.getInfo&video_id=' + video[:id].to_s)
						vid_response = vid_info.body
						parsed_vid_info = JSON.parse(vid_response)
						#puts parsed_vid_info["video"][0]["number_of_plays"]
						if parsed_vid_info["video"][0]["number_of_plays"].to_i > 1000
							count += 1
							#puts parsed_vid_info["video"][0]["number_of_plays"]
							#puts count
							
						end
					end
				end
			end
		end
	end
=end