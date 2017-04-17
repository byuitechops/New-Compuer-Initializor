let cheerio = require('cheerio');
const https = require('https');
const fs = require('fs');
var document = '';

https.get('https://nodejs.org/en/', function(res){
	res.on('data', function(chunk){
		document+=chunk;
	})
	res.on('end', function(){
		let $ = cheerio.load(document);
		var url = $("a[title*='Current']").attr('href');
		console.log(url);
		var version = $("a[title*='Current']").attr('data-version');
        var temp = "node-" + version + "-x64";
        fs.writeFile('./nodeVer.txt', temp ,function(){
		console.log("Node Version Declared")});
		url = url + "node-" + version + "-x64.msi";
		fs.writeFile('./node.txt', url ,function(){
		console.log("Installing Node.")});
	})
})