require 'httparty'

class Youtube
	include HTTParty
	base_uri 'https://www.googleapis.com/youtube/v3'
end

class Reddit
	Reddit_channels = 	[
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
		# get videos for all channels
		Reddit_channels.each do |channel_link|
			channel_uri = "#/r/" + channel_link
			#channel_uri contains a string for use in rtv.js starting on line 2
			output = `phantomjs rtv.js #{channel_uri} &`
			#p output
			#video_id.push(output)
			# remove new line characters

			output.gsub!(/\n/, '')
			# create an array using the output
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
p output
#p output.length.to_s
#p output.uniq
count = 0

# iterate over each item in the output array
# if it is a youtube link, more data is fetched using the youtube data API
output.each do |id|

	snippet    =	Youtube.get('/videos?part=snippet&id=' + id + '&key=#{key}')
	details    =	Youtube.get('/videos?part=contentDetails&id=' + id + '&key=#{key}#{key}')
	statistics =	Youtube.get('/videos?part=statistics&id=' + id + '&key=#{key}')
	

	[ snippet,  details, statistics ].each do |vid_info|
		begin
			# continue unless the query returns nothing
			# this will be the case for non youtube videos
			unless vid_info == nil

				parsed = JSON.parse(vid_info.body)
				hash = parsed['items']
				p hash == nil

				# unless there is no information
				# print the data
				unless hash == nil
					count += 1
					p "data: " + hash[0].to_s
				end
			end
		rescue
			# go to the next item if current one is a non YT link
			next
		end
	end
	p count
end
