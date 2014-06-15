#METACAFE Top 5
require 'open-uri'
require 'nokogiri'

links = []
channels = ["popular-now/", "movie_trailers/", "video-games/", "web-originals/", "tech/", "viral/", "music/", "tv_clips/" ]

channels.each do |channel_uri| 
	html = Nokogiri::HTML( open( "http://www.metacafe.com/" + channel_uri ) )
	html.xpath("//section[@class='Spotlight Mode5v']//li").each do |a|
		link_text = a.css('a').attr('href').text
		links.push(link_text)
	end
end

count = 0
video_tags = []
links.each do |link|
	video_info = {}
	link = 'http://metacafe.com' + link
	html = Nokogiri::HTML( open( link ) )
	tags = html.css('dl#Tags > dd > a')
	tags.each do |tag|
		video_tags.push(tag.text)
	end
	#title = html.css("hgroup#ItemTitle > h1").text
	#subbed = title.gsub(/\n|\r|\t/, '')
	#p subbed
	video_info['tags'] = video_tags
	video_info['title'] = html.css("hgroup#ItemTitle > h1").text.gsub(/\n|\r|\t/, '')
	video_info['views'] = html.css("h2#Views").text.gsub(/\n|\r|\t/, '')
	video_info['date'] = html.css('h2#UploadInfo').text.gsub(/\n|\r|\t/, '')
	video_info['description'] = html.css('div#Description > p').text.gsub(/\n|\r|\t/, '')
	count += 1
	p link, video_info['title'], count, ''
	video_tags = []
end