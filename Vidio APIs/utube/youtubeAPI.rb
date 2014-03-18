require 'youtube_it'
Client = YouTubeIt::Client.new( :dev_key => "AI39si5qsnms-VikuiGLOJRi2VTUtOUCj3ktESLrBjmyykgJ18SBwVu33_1xpL4F-ew_nEwbqE_usiSuRCJYTvIz31SV8Oz5AA" )

# Refresh YouTube API feeds

times = [ :today, :this_week, :this_month, :all_time ]
feeds = [ :top_rated, :top_favorites, :most_viewed, :most_popular, :most_discussed, :most_linked, :most_responded, :recently_featured ]
pages = [ 1, 2, 3, 4 ]

videos = Array.new
times.each do |time|
  puts time
  feeds.each do |feed|
    puts feed
    pages.each do |page|
      puts page
      begin
        Client.videos_by( feed, :time => time, :page => page, :per_page => 50 ).videos.each do |video|
          videos.push( video )
        end
      rescue
        next
      end
    end
  end
end and nil
unique_videos = videos.uniq { |video| video.unique_id } and nil
puts "unique_videos #{unique_videos.count}"

unique_videos.each do |video|
  puts video.title
end and nil

# Refresh YouTube API by category

times = [ :today, :this_week, :this_month, :all_time ]
categories = [ :animals, :autos, :comedy, :education, :entertainment, :film, :games, :howto, :music, :news, :nonprofit, :people, :shows, :sports, :tech, :travel ]
pages = [ 1, 2, 3, 4 ]
# view_count = "1000"

videos = Array.new
# times.each do |time|
categories.each do |category|
  puts category
  # puts time
  # categories.each do |category|
  times.each do |time|
    puts time
    # puts category
    pages.each do |page|
      puts page
      begin
        Client.videos_by( :category => category, :time => time, :page => page, :per_page => 50, :order_by => :viewCount ).videos.each do |video| # , :fields => { :view_count => view_count } , :published => Date.today
          videos.push( video )
        end
      rescue
        next
      end
    end
  end
end and nil
unique_videos = videos.uniq { |video| video.unique_id } and nil
puts "unique_videos #{unique_videos.count}"

unique_videos.each do |video|
  puts video.title
end and nil
