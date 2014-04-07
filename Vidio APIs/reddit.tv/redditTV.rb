require 'open-uri'
require 'nokogiri'
require 'HTTParty'

channels = [
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


class Reddit

	def getLinks channels
		video_id = []
		channels.each do |channel_link|
			channel_uri = "#/r/" + channel_link
			output = `phantomjs hello.js #{channel_uri} &`
			output.gsub!(/\n/, '')
			links = output.split(',')
			p links
			links.each do |page_link|
				video_id.push(page_link)
				#p page_link
=begin
				embedLink = `phantomjs player.js #{page_link} &`
				#p embedLink 
				unless embedLink[0..3] == "null"
					id = embedLink[30..40]
					p "link: " + embedLink.gsub!(/\n/, '')
					p "id: " + id
					count += 1
					p count
					video_id.push(id)
				end
=end
			end
		end
		p "Total: " + video_id.uniq.length.to_s 
	end
end

reddit = Reddit.new
reddit.getLinks(channels)