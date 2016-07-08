import tweepy
import requests
import datetime
from pymongo import MongoClient

#authorization
consumer_key = ""
consumer_secret = ""
access_token = ""
access_token_secret = ""

auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
auth.set_access_token(access_token, access_token_secret)

#api instance
api = tweepy.API(auth)

#set up mongo
client = MongoClient()
db = client.twitterBot
prices = db.stock_data
tweets = db.tweets

#search_results = api.search(q="$APPL", count=100)
#print(search_results)
#for tweet in search_results:
#    print( tweet.text )

#get tweets
def get_tweets():

	twts = tweepy.Cursor(api.search,
               q="AAPL",
               count=1,
               result_type="recent",
               lang="en"
            ).items()
	#print(twts)
	count = 0
	for tweet in twts:

		#print("user name:{}, @name:{}, tweet:{}".format(tweet.user.name, tweet.user.screen_name, tweet.text))
		count += 1
		print(count)
		#username = tweet.user.screen_name
		#tweetText = tweet.text

		#tweet = { 
		#			"username": username, 
	#				"tweet": tweetText,
	#				"date": datetime.datetime.utcnow()
				#}
		#insert into mongoDB
		#print(tweet)
		#tweets.insert(tweet)


# get stock data
def get_stock_data():
	response = requests.get("http://finance.yahoo.com/webservice/v1/symbols/AAPL/quote?format=json")
	json_data = response.json()

	time = json_data['list']['resources'][0]['resource']['fields']['utctime']
	symbol = json_data['list']['resources'][0]['resource']['fields']['symbol']
	price = json_data['list']['resources'][0]['resource']['fields']['price']

	data = {"time": time, "symbol": symbol, "price": price, "date": datetime.datetime.utcnow() }
	prices.insert(data)

	print()
	print("/n time: {}, symbol: {}, price: {}".format(time, symbol, price))


#def post_tweet(tweet):
#	api.updatee_status(tweet)

get_tweets()
get_stock_data()


