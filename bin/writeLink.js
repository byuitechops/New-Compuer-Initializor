const fs = require('fs');

var link = process.argv[2].trim();
var url = "https://nodejs.org/dist/" + link + "/node-" + link + "-x64.msi"
 
 fs.writeFile('./node.txt', url ,function(){
		console.log(url)});
