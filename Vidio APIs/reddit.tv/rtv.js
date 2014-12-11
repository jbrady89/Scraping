var system = require('system'),
	// to access the parameters specified in the command line
	uri = system.args[1],
	page = require('webpage').create(),
	// store youtube links
	urls = [],
	// everything else
	non_yt = [],
	url = "http://reddit.tv/" + uri;
	
page.open(url, function(status) {
	//console.log(page.content);
	console.log(document.getElementsByTagName('a').length);
    var links = page.evaluate(function() {
		var videoContainer = document.getElementById('video-list');
		// this returns an array made up of the results of running the function on all 'a' elements
        return [].map.call(videoContainer.querySelectorAll('a'), function(link) {
			//console.log(return link.getAttribute('href'));
			// this examines the urls to determine what type of video it is (youtube, vimeo, etc)
			if (link.style['backgroundImage'].substring(11,15) == 'edge') {

				return link.style['backgroundImage'].substring(61,73);
			}	else if (link.style['backgroundImage'].substring(11,15) == 'i.vi') {
				// vimeo
				return link.style['backgroundImage'].substring(32, 41);
			}	else if (link.style['backgroundImage'].substring(11,15) == 'i2.y') {
				// this grabs the video ID
				// we use this for getting more data via the youtube API in redditTV.rb
				return link.style['backgroundImage'].substring(27, 38);
			} else  {
				//non_yt.push(link.style['backgroundImage']);
				return link.style['backgroundImage'];
			}
        });
    });
    console.log(links);
    console.log(links.length)

    // iterate through the array
    // not sure why I copied everything from one array to another?
	for (i = 0; i < links.length; i++){
		url = links[i];
		urls.push(url);
	}

	// this outputs the contents of the urls array
	// for use in the redditTv.rb file on line 
	//console.log(urls);
	console.log(links.length);
    phantom.exit();
});

