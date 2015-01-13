import json
from twython import	Twython

consumer_key = "rY3Q4lLIAcLRXPm66JoU2jL8X"
consumer_secret = "xkTrpkamaiDQaiAdEvcvJLj6hmaLH0DL2m5bE4l4H7ROFuRKBC"
access_token = "928665026-VghhFE4Xxovwv1Sz7Ivizdm6bGjEQn2yFGgd5TIy"
access_token_secret = "xtdeTR1eEkSwlhPwj02OLle64kPFvBUYgfx9FsuaozZdI"

api = Twython(app_key=consumer_key, app_secret=consumer_secret, oauth_token=access_token, oauth_token_secret=access_token_secret)

tweets                          =   []
MAX_ATTEMPTS                    =   1
COUNT_OF_TWEETS_TO_BE_FETCHED   =   10 
count = 0
for i in range(0,MAX_ATTEMPTS):

    if(COUNT_OF_TWEETS_TO_BE_FETCHED < len(tweets)):
        break # we got 500 tweets... !!

    #----------------------------------------------------------------#
    # STEP 1: Query Twitter
    # STEP 2: Save the returned tweets
    # STEP 3: Get the next max_id
    #----------------------------------------------------------------#

    # STEP 1: Query Twitter
    if(0 == i):
        # Query twitter for data. 
        results = api.search(q="$FB",count='1')
    else:
    	# After the first call we should have max_id from result of previous call. Pass it in query.
    	results = api.search(q="$FB", count='1', include_entities='true', max_id=next_max_id)
    	print("else \n\n\n")

    # STEP 2: Save the returned tweets
    for result in results['statuses']:
        tweet_text = result['text']
        followers = result['user']['followers_count']
        favs = result['favorite_count']
        rts = result['retweet_count']
        #for key in result.keys(): print( key )
        #print(result['user'], '\n')
        print(json.dumps(result, sort_keys=True, indent=4, separators=(',', ': ') ) )
        print("text: {}, followers: {}, rts: {}, favs: {}".format(tweet_text, followers, rts, favs) )
        count += 1
        #print("\n", count)



    # STEP 3: Get the next max_id
    try:
        # Parse the data returned to get max_id to be passed in consequent call.
        next_results_url_params    = results['search_metadata']['next_results']
        next_max_id        = next_results_url_params.split('max_id=')[1].split('&')[0]
    except:
        # No more next pages
        break

