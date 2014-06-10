var page = require('webpage').create();
var urls = [];
page.open('http://reddit.tv', function(status) {
	//console.log(page.content);
	//console.log(document.getElementsByTagName('a').length);

    var links = page.evaluate(function() {
		var videoContainer = document.getElementById('video-list');
        return [].map.call(videoContainer.querySelectorAll('a'), function(link) {
            return link.getAttribute('href');
        });
    });
    //console.log(links.join('\n'));

	for (i = 0; i < links.length; i++){
		url = 'http://reddit.tv/' + links[i];
		urls.push(url);
	//console.log(url);
	}
	console.log(urls);
    phantom.exit();
});
console.log(urls);

