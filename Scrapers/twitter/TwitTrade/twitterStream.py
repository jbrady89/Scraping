import datetime, threading, time, json, requests, langid, sys
from tweepy import Stream, OAuthHandler, StreamListener
from sqlalchemy import create_engine, Column, Integer, Float, Text, Boolean
from sqlalchemy import DateTime
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from textblob import TextBlob


print ( "Connecting to database\n")

engine = create_engine("postgresql+psycopg2://twitter:password@localhost:5433/twitter")

print ( "Connected!\n" )

Base = declarative_base()
Session = sessionmaker(bind=engine)
session = Session()

#classes for each db table
class Price(Base):
	__tablename__ = 'prices'

	id = Column(Integer, primary_key=True, index=True)
	#symbol = Column(String)
	close = Column(Float)
	timestamp = Column(DateTime, default=datetime.datetime.now(), index=True, unique=True)

	def __repr__(self):
		return "<User(close='%s')>" % (self.close)

class Tweet(Base):
	__tablename__ = 'tweets'

	id = Column(Integer, primary_key=True, index=True)
	user_id = Column(Integer, index=True)
	text = Column(Text)
	retweet = Column(Boolean)
	retweet_count = Column(Integer)
	timestamp = Column(DateTime, default=datetime.datetime.now(), index=True)
	sentiment = Column(Float)


	def __repr__(self):
		return "<User(symbol='%s', price='%s', time='%s')>" % (self.user_id, self.text, self.retweet, self.retweet_count, self.timestamp)

class User(Base):
	__tablename__ = 'users'

	id = Column(Integer, primary_key=True, index=True)
	username = Column(Text, unique=True)
	followers = Column(Integer)
	following = Column(Integer)

	def __repr__(self):
		return "<User(username='%s', followers='%s', following='%s')>" % (self.username, self.followers, self.following)

consumer_key = "rY3Q4lLIAcLRXPm66JoU2jL8X"
consumer_secret = "xkTrpkamaiDQaiAdEvcvJLj6hmaLH0DL2m5bE4l4H7ROFuRKBC"
access_token = "928665026-VghhFE4Xxovwv1Sz7Ivizdm6bGjEQn2yFGgd5TIy"
access_token_secret = "xtdeTR1eEkSwlhPwj02OLle64kPFvBUYgfx9FsuaozZdI"

count = 0
next_call = time.time()
last_price = None

#gets minute data for up to the last 15 days
def get_historic_data(symbol):
	response = requests.get("http://chartapi.finance.yahoo.com/instrument/1.1/{}/chartdata;type=close;range=1d;/json/".format(symbol))
	jsonp = response.text
	fixed_json = jsonp[ jsonp.index("(") + 1 : jsonp.rindex(")") ]
	price_data = json.loads(fixed_json)
	#loop through the minute data
	#it is 5 minute data when range is > 1d
	for entry in price_data['series'][:-1]:
		close = entry["close"]
		timestamp = entry["Timestamp"]
		#format the timestamp
		#minutes = (timestamp / 60)
		#minutes = round(minutes)
		#timestamp = minutes * 60
		timestamp = datetime.datetime.fromtimestamp(timestamp).strftime('%Y-%m-%d %H:%M:%S')
		new_price = Price(close=close, timestamp=timestamp)
		session.add(new_price)
		session.commit()
		print("Close: {}, Timestamp: {} \n".format(close, timestamp))

#get_historic_data("AAPL")

def get_stock_data():
	global last_price
	response = requests.get("http://finance.yahoo.com/webservice/v1/symbols/AAPL/quote?format=json")
	json_data = response.json()

	utctime = json_data['list']['resources'][0]['resource']['fields']['utctime']
	close = json_data['list']['resources'][0]['resource']['fields']['price']
	timestamp = time.time()
	timestamp = datetime.datetime.fromtimestamp(timestamp).strftime('%Y-%m-%d %H:%M:%S')

	try:
		existing_time = session.query(Price).filter_by(timestamp=timestamp).one()
		print("a record exists with the time value: {} \n".format(existing_time))

	except:
		#insert data
		new_price = Price(close=close, timestamp=timestamp)
		session.add(new_price)
		session.commit()

def get_price():
  global next_call #the current time
  print ( datetime.datetime.now() )
  get_stock_data() #get the current price
  next_call = next_call+60 #schedule the next call for 1 minute in the future
  #this sets up the 1 minute interval running in the background
  price_timer = threading.Timer( next_call - time.time() , get_price )
  price_timer.start()


positive_count = 0
negative_count = 0
neutral_count  = 0
polarity_total = 0
polarity_average = 0
total = 0
def get_sentiment(created_at, user, user_id, favorited, favorite_count, retweeted, retweet_count, followers, following, text):
	global count
	global positive_count
	global negative_count
	global neutral_count
	global polarity_total
	global polarity_average
	global total
	count += 1

	#timestamp = datetime.datetime.now()
	classify = langid.classify(text);
	lang = classify[0]

	if lang == "en":
		processed_text = TextBlob(text)
		sentiment = processed_text.sentiment
		polarity = sentiment.polarity
		polarity_total = polarity_total + polarity

		if polarity < 0:

			negative_count += 1
			#print("negative_count: {} \n".format(negative_count))

		elif polarity > 0:

			positive_count += 1
			#print("positive_count: {} \n".format(positive_count))

		elif polarity == 0.0:

			neutral_count += 1
			#print("neutral: {} \n".format(neutral_count))

		else:
			print("polarity is undefined \n")

		total = positive_count + negative_count + neutral_count
		polarity_average = (polarity_total + polarity) / total
		print("Total processed: {}".format(total))
		print("Average sentiment: {}".format(polarity_average))
		print("Positive: {}".format(positive_count))
		print("Negative: {}".format(negative_count))
		print("Neutral: {} \n".format(neutral_count))

	else: 
		#print("the tweet is not in english")
		return

	#http://stackoverflow.com/questions/5729500/how-does-sqlalchemy-handle-unique-constraint-in-table-definition
	timestamp = time.time()
	timestamp = datetime.datetime.fromtimestamp(timestamp).strftime('%Y-%m-%d %H:%M:%S')
	try:
		# if true, user  or timestamp already exists
  		name_existing = session.query(User).filter_by(username=user).one()
  		#timestamp_existing = session.query(Tweets).filter_by(timestamp=timestamp).one()
  		print(name_existing)
	except:
  		user_data = User( username=user, followers=followers, following=following)
  		tweet_data = Tweet( user_id=user_id, text=text, retweet=retweeted, retweet_count=retweet_count,timestamp=timestamp, sentiment=polarity )
  		session.add_all([tweet_data,user_data])
  		session.commit()
  		#print("username ({}) doesn't exist".format(user))
  		return
  		#print("name exists: {}, time exists: {} \n \n".format(name_existing, timestamp_existing))
  		
	# insert the new data in db
	tweet_data = Tweet( user_id=user_id, text=text, retweet=retweeted, retweet_count=retweet_count, timestamp=timestamp, sentiment=polarity )
	session.add(tweet_data)
	session.commit()

def process_data(data):
	tweet = json.loads(data)
	#print( json.dumps( tweet, sort_keys=True, indent=4, separators=(',', ': ') ) )

	user = tweet['user']['screen_name']
	followers = tweet['user']['followers_count']
	following = tweet['user']['friends_count']
	retweeted = tweet['retweeted']
	retweet_count = tweet['retweet_count']
	favorited = tweet['favorited']
	favorite_count = tweet['favorite_count']
	created_at = tweet['created_at']
	user_id = tweet['user']['id']
	text = tweet['text']

	get_sentiment(created_at, user, user_id, favorited, favorite_count, retweeted, retweet_count, followers, following, text)


class listener(StreamListener):

    def on_data(self, data):
    	
        process_data(data)

    def on_error(self, status):
        print( status.text )


auth = OAuthHandler(consumer_key, consumer_secret)
auth.set_access_token(access_token, access_token_secret)
#get_price()
twitterStream = Stream(auth, listener())

while True:  #Endless loop: personalize to suit your own purposes
    try: 
        twitterStream.filter(track=[

							"apple", 
							"aapl",
							"iphone", 
							"os x",
							"ios", 
							"tim cook", 
							"mac", 
							"ipad", 
							"iwatch", 
							"ipod"

						], languages=["en"]
				)

    except:
        #e = sys.exc_info()[0]  #Get exception info (optional)
        #print ('ERROR:',e ) #Print exception info (optional)
        time.sleep(5)
        twitterStream = Stream(auth, listener())
        continue