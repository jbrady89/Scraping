var _ = require('underscore');
var casper = require('casper').create();
var fs = require('fs');

var getLinks = function(){

	var links = document.querySelectorAll("ul > li.soundList__item");

	return [].map.call(links, function(e) {

		var title = e.querySelector("a.soundTitle__title");
		var uploadTime = e.querySelector("div.sound__uploadTime > time");
		var plays = e.querySelector("div.sound__footerRight > .sound__soundStats > ul > li:first-child > span > span:nth-child(2)");
		
		var stats = {
			"title": title.text,
			"link": title.getAttribute("href"),
			"uploadTime": uploadTime.getAttribute("title"),
			"plays": parseInt( plays.textContent.replace(/\,/g, ''), 10)
		};

        return stats;
    });

}

casper.start('http://soundcloud.com/explore', function() {

    casper.repeat(5, function(){
    	this.wait(1000, function(){
    		this.scrollToBottom();
    	});
    });

});

casper.then(function(){

	var songs = this.evaluate(getLinks);
	var strings =    _.chain(songs).sortBy(function(song){
						return song.plays * -1;
					})
					.map(function(song){
						return JSON.stringify(song);
					}).join('\n');

	console.log(strings);

});



casper.run();
