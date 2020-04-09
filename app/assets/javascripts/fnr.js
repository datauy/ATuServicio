// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
var colorsByName = [];

function getRandomColor(originalColor,groupName, chartLevel = 0){
		if(chartLevel==1 && originalColor){
			return originalColor;
		}
		var letters = '0123456789ABCDEF';
		var color = '#';
		for (var i = 0; i < 6; i++ ) {
				color += letters[Math.floor(Math.random() * 16)];
		}
		if((chartLevel==1 && !originalColor) || chartLevel==2 || chartLevel==3){
			if(colorsByName[groupName]){
				return colorsByName[groupName];
			}else{
				colorsByName[groupName] = color;
			}
		}
		return color;
}
