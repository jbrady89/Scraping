require 'httparty'
require 'open-uri'
require 'nokogiri'

#BREAK
url = "http://api.breakmedia.com/content/contentFeed/get?apiRequestJson={slug:'Brk_Web_HP_Stream',responseType:'rss'}"
encoded_url = URI.encode( url )
xml = Nokogiri::XML( open( encoded_url ) )
xml.xpath( '//item/*' ).each do |a|
	unless a.name.to_s == 'thumbnail' or a.name.to_s == 'content'
		p a.name.to_s + ': ' + a.text
	else 
		p a.name.to_s + ': ' + a.attr('url')
	end
end
