var system = require('system'),
	uri = system.args[1],
	page = require('webpage').create(),
	urls = [],
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
				return link.style['backgroundImage'].substring(32, 41);
			}	else if (link.style['backgroundImage'].substring(11,15) == 'i2.y') {
				return link.style['backgroundImage'].substring(27, 38);
			} else  {
				//non_yt.push(link.style['backgroundImage']);
				return link.style['backgroundImage'];
			}
        });
    });

    // iterate through the array
	for (i = 0; i < links.length; i++){
		url = links[i];
		urls.push(url);
	}
	// this outputs the contents of the urls array
	// for use in the redditTv.rb file on line 
	console.log(urls);
    phantom.exit();
});

