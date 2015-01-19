import datetime, threading, time, json, requests, psycopg2, sys
from tweepy import Stream, OAuthHandler, StreamListener
from sqlalchemy import create_engine, Column, Integer, String
from sqlalchemy import DateTime, Time
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from decimal import *

#Define our connection string
#conn_string = 'database="twitter", port="5433", user="twitter", password="password"'

# print the connection string we will use to connect
print ( "Connecting to database\n")

# get a connection, if a connect cannot be made an exception will be raised here
#conn = psycopg2.connect(conn_string)
engine = create_engine("postgresql+psycopg2://twitter:password@localhost:5433/twitter")


# conn.cursor will return a cursor object, you can use this cursor to perform queries
#cursor = conn.cursor()
print ( "Connected!\n" )

Base = declarative_base()
Session = sessionmaker(bind=engine)
session = Session()

class Price(Base):
	__tablename__ = 'prices'

	id = Column(Integer, primary_key=True)
	symbol = Column(String)
	price = Column(Integer)
	date = Column(DateTime, default=datetime.datetime.now())

	def __repr__(self):
		return "<User(symbol='%s', price='%s', time='%s')>" % (self.symbol, self.price, self.date)

class Tweet(Base):
	__tablename__ = 'tweets'

	id = Column(Integer, primary_key=True)
	user = Column(String)
	followers = Column(Integer)
	following = Column(Integer)
	text = Column(String)
	time = Column(DateTime, default=datetime.datetime.now())

	def __repr__(self):
		return "<User(symbol='%s', price='%s', time='%s')>" % (self.user, self.followers, self.text, self.time)



consumer_key = "rY3Q4lLIAcLRXPm66JoU2jL8X"
consumer_secret = "xkTrpkamaiDQaiAdEvcvJLj6hmaLH0DL2m5bE4l4H7ROFuRKBC"
access_token = "928665026-VghhFE4Xxovwv1Sz7Ivizdm6bGjEQn2yFGgd5TIy"
access_token_secret = "xtdeTR1eEkSwlhPwj02OLle64kPFvBUYgfx9FsuaozZdI"

count = 0
next_call = time.time()
last_price = None

#gets minute data for up to the last 15 days
def get_historic_data(symbol):
	response = requests.get("http://chartapi.finance.yahoo.com/instrument/1.1/{}/chartdata;type=quote;range=15d;/json/".format(symbol))
	jsonp = response.text
	fixed_json = jsonp[ jsonp.index("(") + 1 : jsonp.rindex(")") ]
	price_data = json.loads(fixed_json)
	#series is the location of the minutely price data
	print(price_data['series'])

#get_historic_data("AAPL")

def get_stock_data():
	global last_price
	response = requests.get("http://finance.yahoo.com/webservice/v1/symbols/AAPL/quote?format=json")
	json_data = response.json()

	time = json_data['list']['resources'][0]['resource']['fields']['utctime']
	symbol = json_data['list']['resources'][0]['resource']['fields']['symbol']
	price = json_data['list']['resources'][0]['resource']['fields']['price']
	p = Decimal(price)
	# only display two places
	p = round(p, 2)
	print(p, price)
	print()
	new_price = Price( symbol=symbol, price=p )

	# insert the new data in db
	session.add(new_price)
	session.commit()
	print("record saved!")
	#data = {"time": time, "symbol": symbol, "price": price, "date": datetime.datetime.utcnow() }
	#prices.insert(data)
	if (last_price):
	  difference = int(float(price)) - int(float(last_price))
	  #print(" change: {}".format(difference))
	  print(" time: {}, symbol: {}, price: {}, change: {}, \n".format(time, symbol, price, difference))
	  return

	print()
	print(" time: {}, symbol: {}, price: {}, \n".format(time, symbol, price))
	last_price = price

def get_price():
  global next_call #the current time
  print ( datetime.datetime.now() )
  get_stock_data() #get the current price
  next_call = next_call+60 #schedule the next call for 1 minute in the future
  #this sets up the 1 minute interval running in the background
  threading.Timer( next_call - time.time(), get_price ).start()

def sentAnalysis(user, followers, following, text):
	global count
	count += 1
	new_tweet = Tweet( user=user, followers=followers, following=following, text=text )

	# insert the new data in db
	session.add(new_tweet)
	session.commit()
	print("record saved!")

	print("user: {}, followers: {}, following: {}, text: {}, \n".format(user, followers, following, text))
	print("active threads: {}".format(threading.active_count))

class listener(StreamListener):

    def on_data(self, data):
    	
        tweet = json.loads(data)
       	#print( json.dumps( tweet, sort_keys=True, indent=4, separators=(',', ': ') ) )

        user = tweet['user']['screen_name']
        followers = tweet['user']['followers_count']
        following = tweet['user']['friends_count']
        text = tweet['text']

        sentAnalysis(user, followers, following, text)

    def on_error(self, status):
        print( status.text )


auth = OAuthHandler(consumer_key, consumer_secret)
auth.set_access_token(access_token, access_token_secret)
get_price()
twitterStream = Stream(auth, listener())
twitterStream.filter(track=["$AAPL"])