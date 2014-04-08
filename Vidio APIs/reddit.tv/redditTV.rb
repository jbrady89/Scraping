require 'httparty'
require 'securerandom'
require 'uri'

class Youtube
	include HTTParty
	base_uri 'https://www.googleapis.com/youtube/v3'
end

class Reddit


	Reddit_channels = [
					"videos", 
					"music", 
					"vicevideo", 
					"television", 
					"games", 
					"sports", 
					"documentaries", 
					"fullmoviesonyoutube", 
					"redditpicks", 
					"thenewyorktimes", 
					"fringediscussion", 
					"kidsafevideos", 
					"listentothis", 
					"hiphopheads", 
					"classicalmusic", 
					"jazz", 
					"sciencevideos", 
					"todayilearned", 
					"learnuselesstalents", 
					"deepintoyoutube"
				]

	def self.get_reddit_links
		video_id = []
		Reddit_channels.each do |channel_link|
			channel_uri = "#/r/" + channel_link
			output = `phantomjs rtv.js #{channel_uri} &`
			output.gsub!(/\n/, '')
			links = output.split(',')
			#p links
			links.each do |page_link|
				#id = page_link
				video_id.push page_link
				#result = self.get('/videos?part=snippet&id=' + id + '&key=AIzaSyBi5KmDUjrcysyFgQgTddYMx0bJgGPxjFQ')
				#p result
			end
		end
		video_id
		#p "Total: " + video_id.uniq.length.to_s 
	end
end

output = Reddit.get_reddit_links
output.each do |id|
	#begin
		#TODO add requests for statistics, content_details 
	response = Youtube.get('/videos?part=snippet&id=' + id + '&key=AIzaSyBi5KmDUjrcysyFgQgTddYMx0bJgGPxjFQ')
	response = JSON.parse(response.body)
	hash = response['items'][0]
	unless hash == nil
		p hash['snippet']
	end
	#rescue
	#	next
	#end
end

