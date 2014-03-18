#require 'youtube_it'
require 'json'
require 'httparty'
require 'time'
require 'active_support/all'
require 'open-uri'

#get access
=begin
Client = YouTubeIt::Client.new( :dev_key => "AI39si5qsnms-VikuiGLOJRi2VTUtOUCj3ktESLrBjmyykgJ18SBwVu33_1xpL4F-ew_nEwbqE_usiSuRCJYTvIz31SV8Oz5AA" )
#categories = [ :animals, :autos, :comedy, :education, :entertainment, :film, :games, :howto, :music, :news, :nonprofit, :people, :shows, :sports, :tech, :travel ]
#most_viewed = Client.videos_by(:most_viewed)
#parsed = JSON.parse( most_viewed )

	videos = Array.new
    Client.videos_by( :top_rated, :region => "US", :categories => ["News", "People"], :per_page => 50).videos.each do |video|
    	p video.title
    	p video.categories[0].term
    	videos.push( video ) 
   	end
=end

class Youtube
	include HTTParty
	base_uri 'https://www.googleapis.com/youtube/v3'
end

# to test different queries, visit http://www.dailymotion.com/doc/api/explorer#/video

	#result = Youtube.get('/feeds/api/standardfeeds/most_popular?alt=json&time=all_time')
	#feed = result['feed']
	#feed['entry'].each do |video|
	#	p video['category'][1]['term']
	#	p video['title']['$t']
	#end

	timeframe = [ 1.week.ago, 1.month.ago ]
	count = 0
	timeframe.each do |time_period|
		time = URI::encode(time_period.strftime('%FT%TZ'))
		#p time_period
		i = 0
		low_views = false
			for i in 0..4
				if i == 0 
					#puts nextPage
				    result = Youtube.get('/search?part=snippet&q=Technology&publishedAfter=' + time.to_s + '&order=viewCount&maxResults=50&key=AIzaSyBi5KmDUjrcysyFgQgTddYMx0bJgGPxjFQ')
				    nextPage = result.parsed_response["nextPageToken"]
				    #time = Time.parse(page["snippet"]["publishedAt"]) 
				    result.parsed_response['items'].each do |video|
			    		count += 1

			    		#p video, count, "\n"
			    		id = video['id']['videoId']
			    		#p id, video, count, "\n"
			    		#p video['snippet']['title']
			    		description = video['snippet']['description']
			    		if description && description.length == 160 || description.match( /\.\.\.$/ )
			    			#more_info = Youtube.get('/videos?part=snippet&id=' + id + '&key=AIzaSyBi5KmDUjrcysyFgQgTddYMx0bJgGPxjFQ')
			    			#p more_info.parsed_response['items'][0]['snippet']['description']
			    		end
			    		if result.parsed_response['items'].last == video
			    			last_video = Youtube.get('/videos?part=statistics&id=' + id + '&key=AIzaSyBi5KmDUjrcysyFgQgTddYMx0bJgGPxjFQ')
			    			#p last_video.parsed_response['items'][0]['statistics']['viewCount']
			    			low_views = last_video.parsed_response['items'][0]['statistics']['viewCount'].to_i < 1000
			    			#throw :done if low_views == true
			    			#p last_video.parsed_response['items'][0]['statistics']['viewCount'].to_i < 1000 
			    		end

				    end
				    #p i
				else
					#puts nextPage
					#puts '#{1.week.ago}'
					
					#'/search?part=snippet&q=Technology&publishedAfter=2014-02-10T00:00:00Z&orderby=viewCount&max-results=50&key=AIzaSyBi5KmDUjrcysyFgQgTddYMx0bJgGPxjFQ'
					result = Youtube.get('/search?part=snippet&q=Technology&publishedAfter=' + time.to_s + '&order=viewCount&pageToken=' + nextPage + '&maxResults=50&key=AIzaSyBi5KmDUjrcysyFgQgTddYMx0bJgGPxjFQ')

					nextPage = result.parsed_response["nextPageToken"] 
				    result.parsed_response['items'].each do |video|
				    	count += 1
				    	#puts video, count, "\n"
				    	id = video['id']['videoId']
				    	#p video['snippet']['title']
			    		#p id
			    		#p id, video, count, "\n"
			    		if result.parsed_response['items'].last == video
			    			last_video = Youtube.get('/videos?part=statistics&id=' + id + '&key=AIzaSyBi5KmDUjrcysyFgQgTddYMx0bJgGPxjFQ')
			    			#p last_video.parsed_response['items'][0]['statistics']['viewCount'].to_i
			    			low_views = last_video.parsed_response['items'][0]['statistics']['viewCount'].to_i < 1000
			    			#throw :done if low_views == true
			    			#p last_video.parsed_response['items'][0]['statistics']['viewCount'].to_i < 1000 
			    		end
				    end
				    #p i
				end
				#p i, "\n"
				#i += 1
				break if low_views == true
			end
		#end

	end
	category_id = { :film_and_animation => 1, 
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
	category_id.each do |key, value|
		categoryId = value.to_s
		categoryName = key
		p categoryName
		timeframe = [ 1.week.ago, 1.month.ago ]
		count = 0
		timeframe.each do |time_period|
			time = URI::encode(time_period.strftime('%FT%TZ'))
			p "Time Period: " + time_period.to_s
			low_views = false
				for i in 0..4
					if i == 0 
						#puts nextPage
					    category = Youtube.get('/search?part=snippet&order=viewCount&type=video&regionCode=US&videoCategoryId=' + categoryId + '&publishedAfter=' + time.to_s + '&maxResults=50&key=AIzaSyBi5KmDUjrcysyFgQgTddYMx0bJgGPxjFQ')
						nextPage = category.parsed_response["nextPageToken"]
						category['items'].each do |video|
							count += 1
							id = video['id']['videoId']
							#p video['snippet']['title']
							#p id
							if category.parsed_response['items'].last == video
								last_video = Youtube.get('/videos?part=statistics&id=' + id + '&key=AIzaSyBi5KmDUjrcysyFgQgTddYMx0bJgGPxjFQ')
								p "view count: " + last_video.parsed_response['items'][0]['statistics']['viewCount']
								low_views = last_video.parsed_response['items'][0]['statistics']['viewCount'].to_i < 1000
								p "video count: " + count.to_s
								#throw :done if low_views == true
								#p last_video.parsed_response['items'][0]['statistics']['viewCount'].to_i < 1000 
							end
						end
					else
						#puts nextPage
						#puts '#{1.week.ago}'
						
						#'/search?part=snippet&q=Technology&publishedAfter=2014-02-10T00:00:00Z&orderby=viewCount&max-results=50&key=AIzaSyBi5KmDUjrcysyFgQgTddYMx0bJgGPxjFQ'
						category = Youtube.get('/search?part=snippet&order=viewCount&type=video&regionCode=US&videoCategoryId=' + categoryId + '&publishedAfter=' + time.to_s + '&maxResults=50&pageToken=' + nextPage + '&key=AIzaSyBi5KmDUjrcysyFgQgTddYMx0bJgGPxjFQ')
						nextPage = category.parsed_response["nextPageToken"]
						category['items'].each do |video|
							id = video['id']['videoId']
							#p video['snippet']['title']
							#p id
							count += 1
							if category.parsed_response['items'].last == video
								last_video = Youtube.get('/videos?part=statistics&id=' + id + '&key=AIzaSyBi5KmDUjrcysyFgQgTddYMx0bJgGPxjFQ')
								p "view count: " + last_video.parsed_response['items'][0]['statistics']['viewCount']
								low_views = last_video.parsed_response['items'][0]['statistics']['viewCount'].to_i < 1000
								p "video count: " + count.to_s
								#throw :done if low_views == true
								#p last_video.parsed_response['items'][0]['statistics']['viewCount'].to_i < 1000 
							end
						end
					    #p i
					end
					p i
					p
					#i += 1
					break if low_views == true
				end
			#end
		end	
	end
=begin
	time = URI::encode(1.week.ago.strftime('%FT%TZ'))
	category = Youtube.get('/search?part=snippet&order=viewCount&type=video&videoCategoryId=1&publishedAfter=' + time.to_s + '&maxResults=50&pageToken=CAUQAA&key=AIzaSyBi5KmDUjrcysyFgQgTddYMx0bJgGPxjFQ')
	category['items'].each do |video|
		id = video['id']['videoId']
		p video['snippet']['title']
		p id
		if category.parsed_response['items'].last == video
			last_video = Youtube.get('/videos?part=statistics&id=' + id + '&key=AIzaSyBi5KmDUjrcysyFgQgTddYMx0bJgGPxjFQ')
			p last_video.parsed_response['items'][0]['statistics']['viewCount'].to_i
			#low_views = last_video.parsed_response['items'][0]['statistics']['viewCount'].to_i < 1000
			#throw :done if low_views == true
			#p last_video.parsed_response['items'][0]['statistics']['viewCount'].to_i < 1000 
		end
	end
=begin
	result["list"].each do |a|
		if a['views_total'] > 10000
			count += 1
			id = a["id"]
			details = DailyMotion.get('/video/' + id + '/?fields=description,duration,url,title,owner.screenname,owner.url,comments_total,tags,thumbnail_720_url,views_last_day')
			puts details, "\n", n, count
		end
	end
=end

