require 'open-uri'
require 'nokogiri'
require 'HTTParty'

class Reddit
	include HTTParty
	base_uri 'http://reddit.tv/'
end

output = `phantomjs hello.js&`
output.gsub!(/\n/, '')
links = output.split(',')
links.each do |page_link|
	#html = Nokogiri::HTML( open(page_link) )
	#video = html.xpath('//div[@id="video-embed"]/iframe[@id="ytplayer"]')
	#p video
	embedLink = `phantomjs player.js #{page_link} &`
	p "link: " + embedLink.gsub!(/\n/, '')
end
#output.each do |a|
#	p a
#end