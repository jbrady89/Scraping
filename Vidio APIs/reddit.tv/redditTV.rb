require 'httparty'

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
			links.each do |page_link|
				video_id.push page_link
			end
		end
		video_id
		#p "Total: " + video_id.uniq.length.to_s 
	end
end

output = Reddit.get_reddit_links
responses = []
output.each do |id|

	responses.push(
		Youtube.get('/videos?part=snippet&id=' + id + '&key=AIzaSyBi5KmDUjrcysyFgQgTddYMx0bJgGPxjFQ'), 
		Youtube.get('/videos?part=contentDetails&id=' + id + '&key=AIzaSyBi5KmDUjrcysyFgQgTddYMx0bJgGPxjFQ'),
		Youtube.get('/videos?part=statistics&id=' + id + '&key=AIzaSyBi5KmDUjrcysyFgQgTddYMx0bJgGPxjFQ')
	)

	responses.each do |response|
		unless response == nil
			response = JSON.parse(response.body)
			p response, '---', response['items']
			hash = response['items'][0]
			unless hash == nil
				#p hash
			end
		end
	end
end