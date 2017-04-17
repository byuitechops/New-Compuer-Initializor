const fs = require('fs');
var string1 = process.argv[2].trim();
var string2 = process.argv[3].trim();

if (string1 === string2){
	check = true;
}
else{
	check = false;
}

 fs.writeFile('./checkVal.txt', check ,function(){
		console.log("Git Version Checked")});
	