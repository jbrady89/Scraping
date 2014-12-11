=begin
require 'rubygems'
gem 'google-api-client', '>0.7'
require 'google/api_client'
require 'trollop'

# Set DEVELOPER_KEY to the API key value from the APIs & auth > Credentials
# tab of
# Google Developers Console <https://console.developers.google.com/>
# Please ensure that you have enabled the YouTube Data API for your project.
DEVELOPER_KEY = 'AIzaSyAUxXbLjl-LEoqYx_KOufw6IpSKN8Vt_co'
YOUTUBE_API_SERVICE_NAME = 'youtube'
YOUTUBE_API_VERSION = 'v3'

def get_service
  client = Google::APIClient.new(
    :key => DEVELOPER_KEY,
    :authorization => nil,
    :application_name => $PROGRAM_NAME,
    :application_version => '1.0.0'
  )
  youtube = client.discovered_api(YOUTUBE_API_SERVICE_NAME, YOUTUBE_API_VERSION)

  return client, youtube
end

channel_name = 'PewDiePie'

def main channel_name
  opts = Trollop::options do
  	#:default => channel_name
    opt :q, 'Search term', :type => String, :default => channel_name
    opt :max_results, 'Max results', :type => :int, :default => 25
  end

  client, youtube = get_service

  begin
    # Call the search.list method to retrieve results matching the specified
    # query term.
    search_response = client.execute!(
      :api_method => youtube.search.list,
      :parameters => {
        :part => 'snippet',
        :q => opts[:q],
        :maxResults => opts[:max_results]
      }
    )

    videos = []
    channels = []
    playlists = []

    # Add each result to the appropriate list, and then display the lists of
    # matching videos, channels, and playlists.
    search_response.data.items.each do |search_result|
      case search_result.id.kind
        when 'youtube#video'
          videos << "#{search_result.snippet.title} (#{search_result.id.videoId})"
        when 'youtube#channel'
          channels << "#{search_result.snippet.title} (#{search_result.id.channelId})"
        when 'youtube#playlist'
          playlists << "#{search_result.snippet.title} (#{search_result.id.playlistId})"
      end
    end

    puts "Videos:\n", videos, "\n"
    puts "Channels:\n", channels, "\n"
    puts "Playlists:\n", playlists, "\n"
  rescue Google::APIClient::TransmissionError => e
    puts e.result.body
  end
end

main channel_name
=end

require 'json'
require 'httparty'
require 'time'
require 'active_support/all'
require 'open-uri'

class Youtube
	include HTTParty
	base_uri 'https://www.googleapis.com/youtube/v3'
end

key = 'AIzaSyBi5KmDUjrcysyFgQgTddYMx0bJgGPxjFQ'
#Get the channel ID
def get_channel_id key
	channel = 'PewDiePie'
	channels = Youtube.get('/search?part=snippet&q=' + channel + '&maxResults=1&type=channel&key=' + key)
		#channels.each do |channel|
	name = channels.parsed_response['items'][0]['snippet']['title']
	id = channels.parsed_response['items'][0]['id']['channelId']

	p name + ': ' + id
	#end
	get_channel_vidios key
end

#Get the uploads playlist ID
def get_channel_vidios key
	channel_details = Youtube.get('/channels?part=contentDetails&id=UC-lHJZR3Gqxm24_Vd_AJ5Yw&key' + key)
	

	p channel_details
	get_vidio_playlist key id
end

#Get videos using playlist ID
def get_vidio_playlist key id
	#playlstId is the Uploads ID in channel_details
	channel_vidios = Youtube.get('/playlistItems?part=snippet&playlistId=UU-lHJZR3Gqxm24_Vd_AJ5Yw&key=' + key)
end

get_channel_id key