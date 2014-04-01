require 'HTTParty'
require 'uri'
require 'time'
require 'active_support/all'

class DailyMotion
  include HTTParty
  base_uri 'https://api.dailymotion.com'
end

channels = [ "music", "fun", "shortfilms", "news", "sport", "videogames", "auto", "animals", "creation", "tech", "tv", "lifestyle", "people", "travel" ]
timeframe = { "today" => 1.day.ago, "last_week" => 1.week.ago, "last_month" => 1.month.ago }
vidio_ids = []
timeframe.each do |time_key, time_period|
	time = time_period.strftime("%m/%d/%Y")
	p time_key
	channels.each do |channel|
		#p channel
		for n in 1..100
			pageNumber = n.to_s
			channel_vidios = DailyMotion.get('/channel/' + channel + '/videos?fields=allow_embed,channel.name%2Ccomments_total%2Ccreated_time%2Cdescription%2Cduration%2Cid%2Cowner.url%2Cowner.username%2Crating%2Cratings_total%2Ctags%2Cthumbnail_720_url%2Ctitle%2Curl%2Cviews_total&created_after=' + time + '&language=EN&sort=visited&page=' + pageNumber + '&limit=100')
			channel_vidios['list'].each do |a|
				unless a.any? == false
					vidio_id = a['id']
					viewCount = a['views_total']

					if viewCount > 100000 && time_key == "last_month"
						vidio_ids.push(vidio_id)
						p a, "---"
						#p a['ratings_total'], a['rating']
						elsif viewCount > 10000 && time_key == "last_week"
							vidio_ids.push(vidio_id)
							p a, "---"
						elsif viewCount > 1000 && time_key == "today"
							vidio_ids.push(vidio_id)
							p a, "---"
					end
				end
			end
		end
	end
end
p "videos: " + vidio_ids.uniq.length.to_s



