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
					:film_and_animation => 1, 
					:autos_and_vehicles => 2,
					:music => 10, 
					:pets_and_animals => 15,
					:sports => 17,
					#:short_movies => 18,
					:travel_and_events => 19,
					:gaming => 20,
					#:videoblogging => 21,
					:people_and_blogs => 22,
					:comedy => 23,
					:entertainment => 24,
					:news_and_politics => 25,
					:howto_and_style => 26,
					:education => 27,
					:science_and_technology => 28,
					:nonprofits_and_activism => 29,
					:movies => 30,
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
					:shows => 43,
					:trailers => 44
				}
count = 0
category_id.each do |key, value|
	categoryId = value.to_s
	categoryName = key
	p categoryName
	timeframe = { :today => 1.day.ago, :last_week => 1.week.ago, :last_month => 1.month.ago }
	timeframe.each do |time_key, time_period|
		time = URI::encode(time_period.strftime('%FT%TZ'))
		p "Time Period: " + time_period.to_s
		low_views = false
		for i in 0..9
			if i == 0 
			    category = Youtube.get('/search?part=snippet&order=viewCount&type=video&regionCode=US&videoCategoryId=' + categoryId + '&publishedAfter=' + time.to_s + '&maxResults=50&key=AIzaSyBi5KmDUjrcysyFgQgTddYMx0bJgGPxjFQ')
				nextPage = category.parsed_response["nextPageToken"]
				category['items'].each do |video|
					begin
						count += 1
						id = video['id']['videoId']
						#p video['snippet']['title']
						#p id
						if category.parsed_response['items'].last == video

							last_video = Youtube.get('/videos?part=statistics&id=' + id + '&key=AIzaSyBi5KmDUjrcysyFgQgTddYMx0bJgGPxjFQ')
							viewCount = last_video.parsed_response['items'][0]['statistics']['viewCount'].to_i
							if time_key == :last_month && viewCount < 1000000
								low_views = true
							
							elsif time_key == :last_week && viewCount < 100000
								low_views = true
							
							elsif time_key == :today && viewCount < 10000
								low_views = true
							end
							#low_views = last_video.parsed_response['items'][0]['statistics']['viewCount'].to_i < 100000
							p "view count: " + last_video.parsed_response['items'][0]['statistics']['viewCount']
							p "video count: " + count.to_s
							#p low_views
							#throw :done if low_views == true
							#p last_video.parsed_response['items'][0]['statistics']['viewCount'].to_i < 1000 
						end
					rescue 
						next
					end
				end
			else
				#puts nextPage
				#puts '#{1.week.ago}'
				
				#'/search?part=snippet&q=Technology&publishedAfter=2014-02-10T00:00:00Z&orderby=viewCount&max-results=50&key=AIzaSyBi5KmDUjrcysyFgQgTddYMx0bJgGPxjFQ'
				category = Youtube.get('/search?part=snippet&order=viewCount&type=video&regionCode=US&videoCategoryId=' + categoryId + '&publishedAfter=' + time.to_s + '&maxResults=50&pageToken=' + nextPage + '&key=AIzaSyBi5KmDUjrcysyFgQgTddYMx0bJgGPxjFQ')
					if i == 9
						p category
					end
				nextPage = category.parsed_response["nextPageToken"]
				category['items'].each do |video|
					begin
						id = video['id']['videoId']
						#p video['snippet']['title']
						#p id
						count += 1
						if category.parsed_response['items'].last == video
							last_video = Youtube.get('/videos?part=statistics&id=' + id + '&key=AIzaSyBi5KmDUjrcysyFgQgTddYMx0bJgGPxjFQ')
							#p last_video
							viewCount = last_video.parsed_response['items'][0]['statistics']['viewCount'].to_i

							if time_period == 1.month.ago && viewCount < 1000000
								low_views = true
							
							elsif time_period == 1.week.ago && viewCount < 100000
								low_views = true
							
							elsif time_period == 1.day.ago && viewCount < 10000
								low_views = true
							end
							p "view count: " + last_video.parsed_response['items'][0]['statistics']['viewCount']
							#low_views = last_video.parsed_response['items'][0]['statistics']['viewCount'].to_i < 100000
							p "video count: " + count.to_s
							#p low_views
							#throw :done if low_views == true
							#p last_video.parsed_response['items'][0]['statistics']['viewCount'].to_i < 1000 
						end
					rescue
						next
					end
				end
			    #p i
			end
			p i, low_views
			if low_views == true
				p "break"
				break
			end
		end
	end	
end