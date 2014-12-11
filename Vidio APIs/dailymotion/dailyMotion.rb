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
count = 0
start = Time.now
p "start time: " + start.to_s
timeframe.each do |time_key, time_period|
	time = time_period.strftime("%m/%d/%Y")
	p time_key
	channels.each do |channel|
		#p channel
		for n in 1..100
			pageNumber = n.to_s
			#videos?fields=allow_embed,channel.description%2Cchannel.name%2Ccomments_total%2Cdescription%2Cduration%2Cid%2Clanguage%2Cowner.url%2Ctitle%2Curl%2Cviews_total%2C&created_after=12%2F1%2F2014&lang=en&sort=visited
			channel_vidios = DailyMotion.get('/channel/' + channel + '/videos?fields=allow_embed,channel.description%2Cchannel.name%2Ccomments_total%2Cdescription%2Cduration%2Cid%2Clanguage%2Cowner.url%2Ctitle%2Curl%2Cviews_total%2C&created_after=' + time + '&language=en&sort=visited&page=' + pageNumber + '&limit=100')
			channel_vidios['list'].each do |a|
				unless a.any? == false
					vidio_id = a['id']
					viewCount = a['views_total']

					if viewCount > 100000 && time_key == "last_month"
						vidio_ids.push(vidio_id)
						count += 1
						#p count
						#p a, "---"
						#p a['ratings_total'], a['rating']
						elsif viewCount > 10000 && time_key == "last_week"
							vidio_ids.push(vidio_id)
							count += 1
							#p count
							#p a, "---"
						elsif viewCount > 1000 && time_key == "today"
							vidio_ids.push(vidio_id)
							count += 1
							#p count
							#p a, "---"
					end
				end
			end
		end
	end
end

time_finish = Time.now
elapsed = (time_finish - start) / 60
p "end time: " + time_finish.to_s
p "total time: " + elapsed.to_s + "minutes"
p "videos: " + vidio_ids.uniq.length.to_s


