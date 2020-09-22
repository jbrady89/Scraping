require 'HTTParty'
require 'active_support/all'
require 'oauth2'

categories = 	{
					'Activism & Non Profits' => 'activism',
					'Animation & Motion Graphics' => 'animation', 
					'Art' => 'art',
					'Comedy' => 'comedy',
					'Education & DIY' => 'education', 
					'Everyday Life' => 'everyday',
					'Experimental' => 'experimental',
					'Fashion' => 'fashion',
					'Films' => 'films',
					'HD' => 'hd',
					'Music' => 'music',
					'Nature' => 'nature',
					'Products & Equipment' => 'productsandequipment',
					'Science & Tech' => 'technology',
					'Sports' => 'sports',
					'Travel & Events' => 'travel',
					'Vimeo Projects' => 'vimeoprojects',
					'Web Series' => 'webseries'
				}

ClientId = "bebedacec262f1c8490fe8efbee259a9547898eb"
ClientSecret = ""
Token = "edb561bc411ac2ac53b482cd29a9c9be"

videos = Array.new
updates = Array.new
client = OAuth2::Client.new( ClientId, ClientSecret, { :site => "https://api.vimeo.com", :signature_method => "HMAC-SHA1", :scheme => :header } )
token = OAuth2::AccessToken.new( client, Token )

categories.each do |category, uri|
  puts category
  for page in 1..100
    puts page
    begin
      response = JSON.parse( token.get( "/categories/" + uri + "/videos?sort=date&page=" + page.to_s + "&per_page=100" ).body )
      response["data"].each do |item|
        video_id = item["uri"][8..-1]
        if item["created_time"].to_time > 1.month.ago
        	p 'true'
          video = {}
          video["author"]         = item["user"]["name"]
          video["author_uri"]     = item["user"]["link"]
          video["category"]       = category
          video["comment_count"]  = item["stats"]["comments"]
          video["description"]    = ( item["description"] || "" ).gsub( /\n/, ' ' )
          video["dislikes"]       = nil
          video["duration"]       = item["duration"]
          video["embeddable"]     = ( item["privacy"]["embed"] == "public" )
          video["favorite_count"] = nil
          video["image"]          = item["pictures"][0]["link"]
          video["likes"]          = item["stats"]["likes"]
          video["published_at"]   = item["created_time"].to_time
          video["tags"]           = item["tags"].map { |a| a["name"] }.join( " " )
          video["title"]          = item["name"]
          video["video_id"]       = item["uri"][8..-1]
          video["view_count"]     = item["stats"]["plays"]
        else
        	too_old = true
        	#break
        end
      end
      break if too_old == true
    rescue
      next
    end
  end
end





