#!/usr/bin/env node

var fs = require('fs'),
    sh = require('execSync');

var feed = JSON.parse(fs.readFileSync('./maps.json'));

for (var i in feed) {
    var img = feed[i].orig.replace('/wp-content/uploads/mapgallery/orig/', '');
    var url = feed[i].map_url;
    var title = "'" + feed[i].title + "'";
    var name = "'" + feed[i].name + "'";
    var twitter = (feed[i].twitter ? '@' + feed[i].twitter.replace('@', '') : '');

    sh.run('./test.sh ' + [ img, url, title, name, twitter ].join(' '));
}
