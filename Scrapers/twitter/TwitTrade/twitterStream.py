import datetime, threading, time, json, requests, langid, sys
from tweepy import Stream, OAuthHandler, StreamListener
from sqlalchemy import create_engine, Column, Integer, Float, Text, Boolean
from sqlalchemy import DateTime
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from sqlalchemy_declarative import Tweet, User, Price
from textblob import TextBlob



print ( "Connecting to database\n")

engine = create_engine("postgresql+psycopg2://twitter:password@localhost:5433/twitter")

print ( "Connected!\n" )

Base = declarative_base()
Session = sessionmaker(bind=engine)
session = Session()

consumer_key = "rY3Q4lLIAcLRXPm66JoU2jL8X"
consumer_secret = "xkTrpkamaiDQaiAdEvcvJLj6hmaLH0DL2m5bE4l4H7ROFuRKBC"
access_token = "928665026-VghhFE4Xxovwv1Sz7Ivizdm6bGjEQn2yFGgd5TIy"
access_token_secret = "xtdeTR1eEkSwlhPwj02OLle64kPFvBUYgfx9FsuaozZdI"

count = 0
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

	#output formatted json to the console
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
        print("sleeping")
        time.sleep(5)
        twitterStream = Stream(auth, listener())
        continue