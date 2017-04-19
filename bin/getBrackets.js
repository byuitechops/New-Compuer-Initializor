let cheerio = require('cheerio');
const https = require('https');
const fs = require('fs');
var document = '';
var options = {
  host: 'brackets.io',
  //family: 4,
  //port: 80,
  rejectUnauthorized: false
};

https.get(options, function(res){
	res.on('data', function(chunk){
		document+=chunk;
	})
	res.on('end', function(){
		let $ = cheerio.load(document);
		var url = $("d[id*='download-brackets-version']").text();
		url = "https://github.com/adobe/brackets/releases/download/release-" + url + "/Brackets.Release." + url + ".msi"
		console.log(url);
        fs.writeFile('./brackets.txt', url ,function(){
		console.log("Installing Brackets.")}
	)
	})
})

