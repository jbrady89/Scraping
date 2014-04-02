require 'open-uri'
require 'nokogiri'
require 'HTTParty'

class Reddit
	include HTTParty
	base_uri 'http://reddit.tv/'
end
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
count = 0
channels.each do |channel_link|
	channel_uri = "#/r/" + channel_link
	output = `phantomjs hello.js #{channel_uri} &`
	output.gsub!(/\n/, '')
	links = output.split(',')
	links.each do |page_link|
		#html = Nokogiri::HTML( open(page_link) )
		#video = html.xpath('//div[@id="video-embed"]/iframe[@id="ytplayer"]')
		#p video
		p page_link
		embedLink = `phantomjs player.js #{page_link} &`
		p "link: " + embedLink.gsub!(/\n/, '')
		p "id: " + embedLink[30..40]
		count += 1
		p count
	end
	#output.each do |a|
	#	p a
	#end
end