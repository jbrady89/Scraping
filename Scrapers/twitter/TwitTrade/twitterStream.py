import datetime, threading, time, json, requests, psycopg2, sys
from tweepy import Stream, OAuthHandler, StreamListener
from sqlalchemy import create_engine, Column, Integer, String
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker

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
	time = Column(Integer)

	def __repr__(self):
		return "<User(symbol='%s', price='%s', time='%s')>" % (self.symbol, self.price, self.time)

class Tweet(Base):
	__tablename__ = 'tweets'

	id = Column(Integer, primary_key=True)
	author = Column(String)
	followers = Column(Integer)
	text = Column(String)
	time = Column(Integer)

	def __repr__(self):
		return "<User(symbol='%s', price='%s', time='%s')>" % (self.symbol, self.price, self.time)



consumer_key = "rY3Q4lLIAcLRXPm66JoU2jL8X"
consumer_secret = "xkTrpkamaiDQaiAdEvcvJLj6hmaLH0DL2m5bE4l4H7ROFuRKBC"
access_token = "928665026-VghhFE4Xxovwv1Sz7Ivizdm6bGjEQn2yFGgd5TIy"
access_token_secret = "xtdeTR1eEkSwlhPwj02OLle64kPFvBUYgfx9FsuaozZdI"

count = 0
next_call = time.time()
last_price = None

def get_stock_data():
	global last_price
	response = requests.get("http://finance.yahoo.com/webservice/v1/symbols/AAPL/quote?format=json")
	json_data = response.json()

	timestamp = json_data['list']['resources'][0]['resource']['fields']['utctime']
	symbol = json_data['list']['resources'][0]['resource']['fields']['symbol']
	price = json_data['list']['resources'][0]['resource']['fields']['price']

	new_price = Price( symbol=symbol, price=float(price), time=time.time())

	# insert the new data in db
	session.add(new_price)
	session.commit()
	#data = {"time": time, "symbol": symbol, "price": price, "date": datetime.datetime.utcnow() }
	#prices.insert(data)
	if (last_price):
	  difference = int(float(price)) - int(float(last_price))
	  #print(" change: {}".format(difference))
	  print(" time: {}, symbol: {}, price: {}, change: {}, \n".format(timestamp, symbol, price, difference))

	print()
	print(" time: {}, symbol: {}, price: {}, \n".format(time, symbol, price))
	last_price = price

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