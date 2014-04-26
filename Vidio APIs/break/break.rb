require 'httparty'
require 'open-uri'
require 'nokogiri'

xml = Nokogiri::HTML( open( "http://rss.break.com" ) )
xml.xpath( "//item/*" ).each do |a|
	if a.name.to_s == 'description'
		a.xpath('//img/@src|//a/@href')
		thumb = a.css('img').attr('src').text #get thumbnail links
		link = a.css('a').attr('href').text #get video link
		p "thumbnail link: " + thumb, "video link: "  + link
	end
	p a.name.to_s + ": " + a.text
end
