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

	timeframe = [ 1.day.ago, 1.week.ago, 1.month.ago ]
	count = 0
	timeframe.each do |time_period|
		time = URI::encode(time_period.strftime('%FT%TZ'))
		#p time_period
		i = 0
		low_views = false
			for i in 0..9
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
				p count
				#i += 1
				break if low_views == true
			end
		#end
		
	end