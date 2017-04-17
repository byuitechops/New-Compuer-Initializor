let cheerio = require('cheerio');
const https = require('https');
const fs = require('fs');
var document = '';

https.get('https://git-scm.com/download/win', function(res){
	res.on('data', function(chunk){
		document+=chunk;
	})
	res.on('end', function(){
		let $ = cheerio.load(document);
		var url = $("iframe").attr('src');

        fs.writeFile('./gitLink.txt', url ,function(){
		console.log("Git Link Declared")});
	})
})