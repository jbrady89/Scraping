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
		video_id.uniq
		#p "Total: " + video_id.uniq.length.to_s 
	end
end

output = Reddit.get_reddit_links
p output.length.to_s
responses = []
count = 0
output.each do |id|

	
	snippet =	Youtube.get('/videos?part=snippet&id=' + id + '&key=AIzaSyBi5KmDUjrcysyFgQgTddYMx0bJgGPxjFQ')
	details =	Youtube.get('/videos?part=contentDetails&id=' + id + '&key=AIzaSyBi5KmDUjrcysyFgQgTddYMx0bJgGPxjFQ')
	statistics =	Youtube.get('/videos?part=statistics&id=' + id + '&key=AIzaSyBi5KmDUjrcysyFgQgTddYMx0bJgGPxjFQ')
	

	[ snippet,  details, statistics ].each do |vid_info|
		unless vid_info == nil
			parsed = JSON.parse(vid_info.body)
			count += 1
			#p response, '---', response['items']
			hash = parsed['items'][0]
			unless hash == nil
				p hash
			end
		end
	end
	p count
end