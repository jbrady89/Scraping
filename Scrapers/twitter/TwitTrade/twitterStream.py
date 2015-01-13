import datetime, threading, time, json, requests
from tweepy import Stream, OAuthHandler, StreamListener

consumer_key = "rY3Q4lLIAcLRXPm66JoU2jL8X"
consumer_secret = "xkTrpkamaiDQaiAdEvcvJLj6hmaLH0DL2m5bE4l4H7ROFuRKBC"
access_token = "928665026-VghhFE4Xxovwv1Sz7Ivizdm6bGjEQn2yFGgd5TIy"
access_token_secret = "xtdeTR1eEkSwlhPwj02OLle64kPFvBUYgfx9FsuaozZdI"

count = 0
next_call = time.time()

def get_stock_data():
	response = requests.get("http://finance.yahoo.com/webservice/v1/symbols/AAPL/quote?format=json")
	json_data = response.json()

	time = json_data['list']['resources'][0]['resource']['fields']['utctime']
	symbol = json_data['list']['resources'][0]['resource']['fields']['symbol']
	price = json_data['list']['resources'][0]['resource']['fields']['price']

	#data = {"time": time, "symbol": symbol, "price": price, "date": datetime.datetime.utcnow() }
	#prices.insert(data)

	print()
	print(" time: {}, symbol: {}, price: {}, \n".format(time, symbol, price))

def get_price():
  global next_call
  print ( datetime.datetime.now() )
  get_stock_data()
  next_call = next_call+60
  threading.Timer( next_call - time.time(), get_price ).start()

def sentAnalysis(text):
	global count
	count += 1
	print("count: {}, text: {}, \n".format(count, text))


class listener(StreamListener):

    def on_data(self, data):
    	
        tweet = json.loads(data)
        tweet_text = tweet['text']
        sentAnalysis(tweet_text)

    def on_error(self, status):
        print( status.text )


auth = OAuthHandler(consumer_key, consumer_secret)
auth.set_access_token(access_token, access_token_secret)
get_price()
twitterStream = Stream(auth, listener())
twitterStream.filter(track=["$AAPL", "$FB"])