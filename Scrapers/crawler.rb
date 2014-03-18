#unless == if not
#until == while not
#if block inside control statement is one line, use the format "do this if that" to condense whole thing to one line
#use "array.each do |array item|" instead of "for array_item in array"

=begin require 'anemone'

Anemone.crawl("http://www.hyperproof.com") do |anemone|
	#titles = []
  anemone.on_every_page do |page|
  	#if page.url.to_s.match(/2013-11-04/)
    	puts page.url
  	#end
  end
end

#print "hello world\n"


require 'net/http'

source = Net::HTTP.get('http://bloomberg.com', '/index.html')

print source
=end

require 'open-uri'
require 'nokogiri'

#bloomberg
def extractor(link)
	html = Nokogiri::HTML( open( link ) ) and nil
	urls = Array.new
	html.xpath( '//ul[@class="stories"]/li/a' ).each do |a|
		title_and_link = "http://www.bloomberg.com" + a["href"], a.text
		urls.push [ "http://www.bloomberg.com" + a["href"], a.text ]
		puts title_and_link
	end
end

#extractor("http://www.bloomberg.com/archive/news/")

#yahoo
def extractor(link)
	html = Nokogiri::HTML( open( "http://news.yahoo.com/archive/" ) ) and nil
	urls = []
	html.xpath( '//div[@id="MediaStoryList"]//h4/a' ).each do |a|
		#need to check for 'http'
		#if some already have full link, don't need to create a custom string
		unless a["href"].match(/http/)
			title_and_link = "http://news.yahoo.com/archive/" + a["href"], a.text
		else 
			title_and_link = a["href"], a.text
		end
		urls.push [ title_and_link ]
	end
	puts urls
end

#extractor("http://news.yahoo.com/archive/")

#require 'alexa' -- costs money

#client = Alexa::Client.new(access_key_id: "key", secret_access_key: "secret")
#url_info = client.url_info(url: "http://www.hyperproof.com/")
#puts url_info.rank

#sbnation
=begin
	html = Nokogiri::HTML( open( "http://www.sbnation.com/latest-news" ) ) and nil
	urls = Array.new
	html.xpath( '//div[@class="l-chunk"]//h3/a' ).each do |a|
		title_and_link = a["href"], a.text
		urls.push [ a["href"], a.text ]
		puts title_and_link

	end
	puts urls.length
	puts urls[0][1]


#nyt - arts beat .. only first page
	html = Nokogiri::HTML( open( "http://artsbeat.blogs.nytimes.com/2013/" ) ) and nil
	urls = Array.new
	html.xpath( '//div[@id="content"]//h3/a' ).each do |a|
		title_and_link = a["href"], a.text
		urls.push [ title_and_link ]
	end
	puts urls
	puts urls.length
	#puts urls[0][1]

#nyt - bits
	html = Nokogiri::HTML( open( "http://bits.blogs.nytimes.com/2013/" ) ) and nil
	urls = Array.new
	html.xpath( '//div[@id="content"]//h3/a' ).each do |a|
		title_and_link = a["href"], a.text
		urls.push [ title_and_link ]
	end
	puts urls
	puts urls.length

#deep links
	html = Nokogiri::HTML( open( "https://www.eff.org/deeplinks") ) and nil
	urls = Array.new
	html.xpath( '//div[@class="view-content"]//h2/a' ).each do |a|
		title_and_link = a["href"], a.text
		urls.push [ title_and_link ]	
	end
	puts urls
	puts urls.length

#felix salmon
	html = Nokogiri::HTML( open( "http://blogs.reuters.com/felix-salmon/2013/") ) and nil
	urls = Array.new
	html.xpath( '//div[@class="topStory"]//h2/a' ).each do |a|
		title_and_link = a["href"], a.text
		urls.push [ title_and_link ]
	end
	puts urls
	puts urls.length

require 'simple-rss'
rss = SimpleRSS.parse open('http://feeds.feedburner.com/20-nothings')
rss.items.each do |a|
	puts "#{a.link}","#{a.title}"
end
=end
xml = Nokogiri::HTML( open ('http://feeds.feedburner.com/20-nothings') )
xml.xpath('//entry/link[@rel="alternate"]').each do |a|
	unless xml.xpath('//a[href]').to_s.match(/comment/)
		puts a["href"]
	end
end
#puts rss.items.each do 
=begin -- return body html without script tags
	doc = html
	doc.at('body').search('script,noscript').remove
=end