require 'json'
require 'httparty'
require 'time'
require 'active_support/all'
require 'open-uri'

class Youtube
	include HTTParty
	base_uri 'https://www.googleapis.com/youtube/v3'
end

category_id = 	{ 	
					"film_and_animation" => 1, 
					"autos_and_vehicles" => 2,
					"music" => 10, 
					"pets_and_animals" => 15,
					"sports" => 17,
					#:short_movies => 18,
					"travel_and_events" => 19,
					"gaming" => 20,
					#:videoblogging => 21,
					"people_and_blogs" => 22,
					"comedy" => 23,
					"entertainment" => 24,
					"news_and_politics" => 25,
					"howto_and_style" => 26,
					"education" => 27,
					"science_and_technology" => 28,
					"nonprofits_and_activism" => 29,
					"movies" => 30,
					#:anime_and_animation => 31,
					#:action_and_adventure => 32,
					#:classics => 33,
					#:comedy2 => 34,
					#:documentary => 35,
					#:drama => 36,
					#:family => 37,
					#:foreign => 38,
					#:horror => 39,
					#:scifi_fantasy => 40,
					#:thriller => 41,
					#:shorts => 42,
					"shows" => 43,
					"trailers" => 44
				}

low_views = false
vidio_ids = []
vidio_info = []
=begin
	def check_views(time_period, category, count, time_key, low_views, vidio_ids, vidio_info, categoryName)
	category['items'].each do |video|
		#p time_key
		#p time_key == :last_week
		
			id = video['id']['videoId']
			vidio_ids.push(id)
			details = { "category" => categoryName.to_s, "vidio_id" => id, "title" => video['snippet']['title'], "description"=> video['snippet']['description'] }
			vidio_info.push(details)
			count += 1

			# remove condition to make it run the queries on every video
			if category.parsed_response["items"].last == video

				last_video = Youtube.get('/videos?part=contentDetails&id=' + id + '&key=AIzaSyBi5KmDUjrcysyFgQgTddYMx0bJgGPxjFQ')
				#p last_video
				video_details = last_video["items"][0]["contentDetails"]
				p video_details
				duration = video_details["duration"]
				p duration
				last_video = Youtube.get('/videos?part=snippet&id=' + id + '&key=AIzaSyBi5KmDUjrcysyFgQgTddYMx0bJgGPxjFQ')
				#p last_video["items"][0]["snippet"]
				snippet = last_video["items"][0]["snippet"]
				p  snippet
				published_at = snippet["publishedAt"]
				published_at = DateTime.parse(published_at)
				channel_id = snippet["channelId"]
				title = snippet["title"]
				description = snippet["description"]
				thumbnail = snippet["thumbnails"]["high"]["url"]
				channel_title = snippet["channelTitle"]
				category_id = snippet["categoryId"]
				p published_at, channel_id, title, description, categoryName, thumbnail, channel_title, category_id
				last_video = Youtube.get('/videos?part=statistics&id=' + id + '&key=AIzaSyBi5KmDUjrcysyFgQgTddYMx0bJgGPxjFQ')
				statistics = last_video["items"][0]["statistics"]
				views = statistics["viewCount"]
				likes = statistics["likeCount"]
				dislikes = statistics["dislikeCount"]
				favorites = statistics["favoriteCount"]
				comments = statistics["commentCount"]
				#p views, likes, dislikes, favorites, comments
				p

				last_video = Youtube.get('/videos?part=statistics&id=' + id + '&key=AIzaSyBi5KmDUjrcysyFgQgTddYMx0bJgGPxjFQ')

				viewCount = last_video.parsed_response['items'][0]['statistics']['viewCount'].to_i

				if time_key == "last_month" && viewCount < 100000
					low_views = true
					#p 'low_views: ' + low_views.to_s
				
				elsif time_key == "last_week" && viewCount < 10000
					low_views = true
					#p 'low_views: ' + low_views.to_s
				
				elsif time_key == "today" && viewCount < 1000
					low_views = true
					#p 'low_views: ' + low_views.to_s
				end
				#p "view count: " + last_video.parsed_response['items'][0]['statistics']['viewCount']
				#p defined? low_views
				#p "video count: " + count.to_s
			end
			#p "video count for #{category}: " + count.to_s

	end
	vars = { "views" => low_views, "vidCount" => count }
	return vars
end

vars = {}
timeframe = { "today" => 1.day.ago, "last_week" => 1.week.ago, "last_month" => 1.month.ago }
count = 0
category_id.each do |key, value|
	categoryId = value.to_s
	categoryName = key
	p categoryName
	timeframe.each do |time_key, time_period|
			time = URI::encode(time_period.strftime('%FT%TZ'))
			p "Time Period: " + time_period.to_s
			low_views = false
			count = vars["vidCount"] ? vars["vidCount"] : 0
			for i in 0..9
				if i == 0 

				    category = Youtube.get('/search?part=snippet&order=viewCount&type=video&regionCode=US&videoCategoryId=' + categoryId + '&publishedAfter=' + time.to_s + '&maxResults=50&key=AIzaSyBi5KmDUjrcysyFgQgTddYMx0bJgGPxjFQ')
					nextPage = category.parsed_response["nextPageToken"]
					vars = check_views time_period, category, count, time_key, low_views, vidio_ids, vidio_info, categoryName
					p i, "total: " + vars[:vidCount].to_s, "this period: " + (i + 50).to_s					
				else
					count = vars["vidCount"]
					category = Youtube.get('/search?part=snippet&order=viewCount&type=video&regionCode=US&videoCategoryId=' + categoryId + '&publishedAfter=' + time.to_s + '&maxResults=50&pageToken=' + nextPage + '&key=AIzaSyBi5KmDUjrcysyFgQgTddYMx0bJgGPxjFQ')
					nextPage = category.parsed_response["nextPageToken"]
					vars = check_views time_period, category, count, time_key, low_views, vidio_ids, vidio_info, categoryName
					p i, "total: " + vars[:vidCount].to_s, "this period: " + (i * 50).to_s						
				end
				#p i, vars[:vidCount]
				#p defined? low_views
				#p i, "total: " + vars[:vidCount].to_s, "this period: " + (i * 50).to_s
				if vars["views"] == true
					p "break"
					p 
					break
				end
			end
		#puts "video count: " + count.to_s
		#p i, "total: " + vars[:vidCount].to_s, "this period: " + (i * 50).to_s
	end	
end
p vidio_ids.uniq.length
#p vidio_info.uniq
=end
category = Youtube.get('/channels?key=AIzaSyBi5KmDUjrcysyFgQgTddYMx0bJgGPxjFQ&forUsername=PewDiePie&part=id')
channel_id = category['items'][0]['id']
end_of_results = false
for i in 0..9

	if i == 0
		channel_videos = Youtube.get('/search?key=AIzaSyBi5KmDUjrcysyFgQgTddYMx0bJgGPxjFQ&channelId=' + channel_id.to_s + '&part=snippet&maxResults=50')
		p channel_videos
		next_page = channel_videos.parsed_response["nextPageToken"]
		p next_page
		#channel_videos[0].each do |entry|
			#p entry
		#end
	else
			channel_videos = Youtube.get('/search?key=AIzaSyBi5KmDUjrcysyFgQgTddYMx0bJgGPxjFQ&channelId=' + channel_id.to_s + '&part=snippet&maxResults=50&pageToken=' + next_page)
			next_page = channel_videos.parsed_response["nextPageToken"]
			if next_page == nil
				end_of_results = true

			else p next_page
			end
	end
	if end_of_results
		p 'break'
		break
	end
end

