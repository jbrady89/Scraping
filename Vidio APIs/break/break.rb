require 'httparty'
require 'open-uri'
require 'nokogiri'

#BREAK
#This only gets what's in the current RSS feed. Limited # of results
#url = "http://api.breakmedia.com/content/contentFeed/get?apiRequestJson={slug:'Brk_Web_HP_Stream',responseType:'rss'}"
#encoded_url = URI.encode( url )
#xml = Nokogiri::XML( open( encoded_url ) )
#xml.xpath( '//item/*' ).each do |a|
#	unless a.name.to_s == 'thumbnail' or a.name.to_s == 'content'
		#p a.name.to_s + ': ' + a.text
#	else 
		#p a.name.to_s + ': ' + a.attr('url')
#	end
#end

#This approach will get videos from each unique channel
channels = ["movies-and-tv", "break-sports", "all-the-animals", "bizarre-and-amazing", "gaming", "pranks-and-fails", "heartwarming", "funny-videos"]

#example url = 'www.break.com/' + channel + '/1,2' etc..
#channels.each do |channel|
	for i in 2..3
		url = "http://www.break.com/movies-and-tv/" + i.to_s
		html = Nokogiri::HTML( open(url) )
		#p html
		html.xpath('//div[@class="caroufredsel-item scaling"]//article//h1').each do |container|
			p container.css('a').children.text
		end
	end
#end