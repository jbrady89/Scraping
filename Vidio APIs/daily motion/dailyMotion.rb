require 'HTTParty'
require 'Vimeo'
require 'securerandom'
require 'uri'
require 'time'
require 'active_support/all'

class DailyMotion
  include HTTParty
  base_uri 'https://api.dailymotion.com'
end

class VimeoVideos
	include HTTParty
	base_uri 'vimeo.com'
end

# to test different queries, visit http://www.dailymotion.com/doc/api/explorer#/video


=begin
		#string = time_period
		#p string
		time = time_period.strftime("%m/%d/%Y")
		p time
		for n in 1..100
			pageNumber = n.to_s
			#p time
			result = DailyMotion.get('/videos?language=en&sort=visited&created_after=' + time + '&sort=visited&fields=id,created_time,views_total&page=' + pageNumber + '&limit=100')
			#puts result
			p pageNumber

			result["list"].each do |a|
			viewCount = a['views_total']
	=begin
				if a['views_total'] > 10000
					count += 1
					id = a["id"]
					vidio_id.push(id)
					details = DailyMotion.get('/video/' + id + '/?fields=description,created_time,duration,url,title,owner.screenname,owner.url,comments_total,tags,thumbnail_720_url,views_last_day')
					created_time = Time.at(a['created_time'])
				
					puts a['title'], "videoCount: " + count.to_s, "viewCount: " + a['views_total'].to_s, "created on: " + created_time.to_s
				end
	=end		
				id = a["id"]
				#details = DailyMotion.get('/video/' + id + '/?fields=description,allow_embed,created_time,duration,url,title,owner.screenname,owner.url,comments_total,tags,thumbnail_720_url,views_total')
				#viewCount = details['views_total']
				#id = a["id"]
				if time_key == "last_month" && viewCount > 10000
						#low_views = true
						count += 1
						#id = a["id"]
						vidio_id.push(id)
						#details = DailyMotion.get('/video/' + id + '/?fields=description,allow_embed,created_time,duration,url,title,owner.screenname,owner.url,comments_total,tags,thumbnail_720_url,views_last_day')
						created_time = Time.at(a['created_time'])
					
						#puts a['title'], "videoCount: " + count.to_s, "viewCount: " + a['views_total'].to_s, "created on: " + created_time.to_s
						#p 'low_views: ' + low_views.to_s
						#p details['views_total']
						details = DailyMotion.get('/video/' + id + '/?fields=description,allow_embed,created_time,duration,url,title,owner.screenname,owner.url,comments_total,tags,thumbnail_720_url,views_total')
						p details
					
					elsif time_key == "last_week" && viewCount > 1000
						#low_views = true
						#p 'low_views: ' + low_views.to_s
						count += 1
						#id = a["id"]
						vidio_id.push(id)
						#details = DailyMotion.get('/video/' + id + '/?fields=description,allow_embed,created_time,duration,url,title,owner.screenname,owner.url,comments_total,tags,thumbnail_720_url,views_last_day')
						created_time = Time.at(a['created_time'])
						#p details['views_total']
						#puts a['title'], "videoCount: " + count.to_s, "viewCount: " + a['views_total'].to_s, "created on: " + created_time.to_s
						details = DailyMotion.get('/video/' + id + '/?fields=description,allow_embed,created_time,duration,url,title,owner.screenname,owner.url,comments_total,tags,thumbnail_720_url,views_total')
						p details
					elsif time_key == "today" && viewCount > 100
						#low_views = true
						#p 'low_views: ' + low_views.to_s
						count += 1
						#id = a["id"]
						vidio_id.push(id)
						#details = DailyMotion.get('/video/' + id + '/?fields=description,allow_embed,created_time,duration,url,title,owner.screenname,owner.url,comments_total,tags,thumbnail_720_url,views_last_day')
						created_time = Time.at(a['created_time'])
						#p details['views_total']
						#puts a['title'], "videoCount: " + count.to_s, "viewCount: " + a['views_total'].to_s, "created on: " + created_time.to_s
						details = DailyMotion.get('/video/' + id + '/?fields=description,allow_embed,created_time,duration,url,title,owner.screenname,owner.url,comments_total,tags,thumbnail_720_url,views_total')
						p details
				end
			end
		end
	end
	p "final count" + count.to_s
	p "unique vidios: " + vidio_id.uniq.length.to_s
=end

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




#result = video.getAll('id')
#puts result

#nonce = SecureRandom.hex()
#puts nonce
#base = Vimeo::Advanced::Base.new("bebedacec262f1c8490fe8efbee259a9547898eb", "11ae1c7df03482894ac3d665140d270d75c2f766")
#request_token = base.get_request_token
#access_token = base.get_access_token(params[:oauth_token], session[:oauth_secret], params[:oauth_verifier])
#session[:oauth_secret] = request_token.secret
#puts access_token





#user_info = Vimeo::Simple::User.info("matthooks")
#puts user_info



