var system = require('system');
//console.log(system.args[1]);
uri = system.args[1];
var page = require('webpage').create();
var urls = [];
url = "http://reddit.tv/" + uri;
//console.log('xyz);
page.open(url, function(status) {
	//console.log(page.content);
	//console.log(document.getElementsByTagName('a').length);
    var links = page.evaluate(function() {
		var videoContainer = document.getElementById('video-list');
        return [].map.call(videoContainer.querySelectorAll('a'), function(link) {
            //return link.getAttribute('href');
            
			if (link.style['backgroundImage'].substring(11,15) == 'edge') {
				return 'liveleak: ' + link.style['backgroundImage'].substring(61,73);

			}	else if (link.style['backgroundImage'].substring(11,15) == 'i.vi') {

				return 'vimeo: ' + link.style['backgroundImage'].substring(32, 41);

			}	else {
				return 'yt: ' + link.style['backgroundImage'].substring(27, 38);
			}

        });
    });
    //console.log(links.join('\n'));

	for (i = 0; i < links.length; i++){
		url = links[i];
		urls.push(url);
	//console.log(url);
	}
	console.log( urls);
    phantom.exit();
});
console.log(urls);

