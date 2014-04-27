require 'httparty'
require 'open-uri'
require 'nokogiri'

class Metacafe
	include HTTParty
	base_uri 'http://metacafe.com'
end
=begin
#BREAK
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
=end

#METACAFE Top 5
links = []
html = Nokogiri::HTML( open( "http://www.metacafe.com/popular-now/" ) )
html.xpath("//section[@class='Spotlight Mode5v']//li").each do |a|
	link_text = a.css('a').attr('href').text
	links.push(link_text)
end
#p links.uniq
links.each do |link|
	video_tags = []
	link = 'http://metacafe.com' + link
	html = Nokogiri::HTML( open( link ) )
	#p html.css("hgroup#ItemTitle").text, html.css("h2#Views").text, html.css('h2#UploadInfo').text, html.css('div#Description').text, 
	tags = html.css('dl#Tags > dd > a')
	tags.each do |tag|
		video_tags.push(tag.text)
	end
	p video_tags
end

=begin
#embed link
<iframe src="http://www.metacafe.com/embed/10859663/" width="440" height="248" allowFullScreen frameborder=0></iframe>	
=end


