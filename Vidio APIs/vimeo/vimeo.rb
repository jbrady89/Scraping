require 'HTTParty'
require 'securerandom'
require 'uri'
require 'time'
require 'active_support/all'
require 'oauth'


class Vimeo
	include HTTParty
	base_uri 'vimeo.com'
end


CONSUMER_KEY = "bebedacec262f1c8490fe8efbee259a9547898eb"
SECRET = ""
TOKEN = "4c9903b8ecf4589d5cd0cdfb01129b02"
TOKEN_SECRET = ""

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
p access_token
vidios = []
yesterday = []
last_week = []
last_month = []
timeframe = { "today" => 1.day.ago, "last_week" => 1.week.ago, "last_month" => 1.month.ago }
count = 0
categories.each do |cat_key, value|
	begin
		#category_name = category.gsub(/\s+/, "")
		#category_name = category_name.gsub("&", "%2526").gsub("%20", "%2520")
		p value

		for i in 1..500
			result = access_token.get("/api/rest/v2?format=json&method=vimeo.categories.getRelatedVideos&category=" + value + "&page=" + i.to_s + "&per_page=100")
			response = JSON.parse(result.body)
			response['videos']['video'].each do |a|
				id = a['id']
				upload_date = a['upload_date']
				count += 1
				#p count
				if upload_date > 1.day.ago.to_s
						response = access_token.get('/api/rest/v2?format=json&method=vimeo.videos.getInfo&video_id=' + id)
						vid_info = JSON.parse(response.body)
						#p vid_info['video'][0]['title'], 
						#	vid_info['video'][0]['description'] , 
						#	vid_info['video'][0]['upload_date'], 
						#	vid_info['video'][0]['number_of_plays'], 
						#	vid_info['video'][0]['number_of_likes'], 
						#	vid_info['video'][0]['duration']
						views = vid_info['video'][0]['number_of_plays']
						if views.to_i > 100
							p views
							vidios.push(id)
							yesterday.push(id)
							#p views
							p "total: " + vidios.uniq.length.to_s, "yesterday: " + yesterday.uniq.length.to_s, "last week: " + last_week.uniq.length.to_s, "last month: " + last_month.uniq.length.to_s
						end
					elsif upload_date > 1.week.ago.to_s
						response = access_token.get('/api/rest/v2?format=json&method=vimeo.videos.getInfo&video_id=' + id)
						vid_info = JSON.parse(response.body)
						#p vid_info['video']
						#p vid_info['video'][0]['title'], 
						#	vid_info['video'][0]['description'] , 
						#	vid_info['video'][0]['upload_date'], 
						#	vid_info['video'][0]['number_of_plays'], 
						#	vid_info['video'][0]['number_of_likes'], 
						#	vid_info['video'][0]['duration']
						views = vid_info['video'][0]['number_of_plays']
						if views.to_i > 1000
							vidios.push(id)
							last_week.push(id)
							p views
							p "total: " + vidios.uniq.length.to_s, "yesterday: " + yesterday.uniq.length.to_s, "last week: " + last_week.uniq.length.to_s, "last month: " + last_month.uniq.length.to_s
						end
					elsif upload_date > 1.month.ago.to_s
						response = access_token.get('/api/rest/v2?format=json&method=vimeo.videos.getInfo&video_id=' + id)
						vid_info = JSON.parse(response.body)
						#p vid_info['video']
						#p vid_info['video'][0]['title'], 
						#	vid_info['video'][0]['description'] , 
						#	vid_info['video'][0]['upload_date'], 
						#	vid_info['video'][0]['number_of_plays'], 
						#	vid_info['video'][0]['number_of_likes'], 
						#	vid_info['video'][0]['duration']
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
p "total: " + vidios.uniq.length.to_s, "yesterday: " + yesterday.uniq.length.to_s, "last week: " + last_week.uniq.length.to_s, "last month: " + last_month.uniq.length.to_s

=begin
#trying to use beta..doesn't work

client = OAuth2::Client.new(
	CONSUMER_KEY, 
	SECRET, 
	:site => 'http://api.vimeo.com'
)

access_token = OAuth2::AccessToken.new(client, TOKEN)
p access_token
#video = access_token.get('/categories/')
#p video
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
=end
