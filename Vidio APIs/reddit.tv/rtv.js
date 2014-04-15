var system = require('system'),
	uri = system.args[1],
	page = require('webpage').create(),
	urls = [],
	url = "http://reddit.tv/" + uri;
page.open(url, function(status) {
	//console.log(page.content);
	console.log(document.getElementsByTagName('a').length);
    var links = page.evaluate(function() {
		var videoContainer = document.getElementById('video-list');
        return [].map.call(videoContainer.querySelectorAll('a'), function(link) {
			//console.log(return link.getAttribute('href'));
			if (link.style['backgroundImage'].substring(11,15) == 'edge') {
				return false;//link.style['backgroundImage'].substring(61,73);
			}	else if (link.style['backgroundImage'].substring(11,15) == 'i.vi') {
				return false;//link.style['backgroundImage'].substring(32, 41);
			}	else if (link.style['backgroundImage'].substring(11,15) == 'i2.y') {
				return false;//link.style['backgroundImage'].substring(27, 38);
			} else  {
				return link.style['backgroundImage'];
			}
        });
    });
	for (i = 0; i < links.length; i++){
		url = links[i];
		urls.push(url);
	}
	console.log( urls);
    phantom.exit();
});

