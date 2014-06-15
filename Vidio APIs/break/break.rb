require 'httparty'
require 'open-uri'
require 'nokogiri'
#require 'addressable/uri'

#BREAK
url = "http://api.breakmedia.com/content/contentFeed/get?apiRequestJson={slug:'Brk_Web_HP_Stream',responseType:'rss'}"
encoded_url = URI.encode( url )
#p encoded_url, url
xml = Nokogiri::XML( open( encoded_url ) )
#p xml
xml.xpath( "//item/*" ).each do |a|
	#p a.name.to_s, a.text
	unless a.name.to_s == 'thumbnail' or a.name.to_s == 'content'
		p a.name.to_s + ': ' + a.text

	else 
		p a.name.to_s + ': ' + a.attr('url')
	end
	#tags = ['guid', 'title', 'link', 'description', 'pubDate']
	#tags.each do |tag|
	#	p a.css( tag.to_s ).text
	#end
	#p a.search('link'), a.search('pubDate')
	#p a.css('title').text
	#p 'name: ' + a.name, 'text: ' + a.text

=begin
		if a.name.to_s == 'description'
			a.xpath('//img/@src|//a/@href')
			thumb = a.css('img').attr('src').text #get thumbnail links
			link = a.css('a').attr('href').text #get video link
		end
		#p a.name.to_s + ": " + a.text
=end
	p
end

=begin
require 'addressable/uri'


#BREAK
url = "http://api.breakmedia.com/content/contentFeed/get?apiRequestJson={slug:'Brk_Web_HP_Stream',responseType:'rss'}"
uri = Addressable::URI.unencode(url)
xml = Nokogiri::HTML( open( url ) )
=end
