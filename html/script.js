	// For the thumbnail demo! :]

var count = 1

var mousein = false
var menus = []
function nospace(str) {
	return str.replace(/[^a-z0-9]/gi,'');
}

function send(v,a) {
	var data = {table:v,variables:a};
	$.post("https://renzu_contextmenu/receivedata",JSON.stringify(data),function(datab){});
}
function show(event) {
	if (menus[event.k] == undefined) {
		menus[event.k] = event.content
		console.log(event.k)
		$("#menu").prepend('<menuitem><a class="switch"><i class="fad fa-bars"></i> '+event.k+'</a><menu id="'+nospace(event.k)+'">');
		for (const i in menus[event.k]) {
			menu[menus[event.k][i]['title']] = true
			if (menus[event.k][i]['variables'] !== undefined) {
				if (menus[event.k][i]['variables'].send_entity) {
					menus[event.k][i]['variables'].entity = event.entity
				}
				menus[event.k][i]['variables'].path = {name:event.k,title:i}
			}
			//console.log(menus[event.k][i]['title'].replace(/[^a-z0-9]/gi,''))
			console.log(menus[event.k][i]['title'])
			if (menus[event.k][i]['fa'] == undefined) {
				menus[event.k][i]['fa'] = '<i class="fad fa-cog"></i>';
			}
			$('#'+nospace(event.k)+'').append('<menuitem><a id="'+menus[event.k][i]['title'].replace(/[^a-z0-9]/gi,'')+'">'+menus[event.k][i]['fa']+' '+menus[event.k][i]['title']+'</a></menuitem>');
			$("#"+menus[event.k][i]['title'].replace(/[^a-z0-9]/gi,'')+"").click(function(){
				send(menus[event.k][i],menus[event.k][i]["variables"]);
			});
		}
		$("#menu").prepend('</menu></menuitem>');
	}
}

function close() {
	console.log("TIKOL")
	$.post("https://renzu_contextmenu/close",{},function(datab){});
	window.location.reload(false);
}

function reset() {
   count = 1
   var hovers = document.querySelectorAll('.hover')
   for(var i = 0; i < hovers.length; i++ ) {
      hovers[i].classList.remove('hover')
   }
}

document.addEventListener('mouseover', function() {
   mousein = true
   //reset()
})

var current = undefined
window.addEventListener('message', function (table) {
	let event = table.data;
	if (event.type == 'insert') {
		show(event.content)
		// var icons = document.querySelectorAll('.switch');
		// for (var i = 0; i < icons.length; i++) {
		// 	icons[i].addEventListener("mouseenter", function() {
		// 		reset()
		// 	});

		// 	icons[i].addEventListener("mouseleave", function() {
		// 		reset()
		// 	});
		// }
	}
	if (event.type == 'show') {
		//console.log("ASO")
		document.getElementById("nav").style.display = 'block';
	}
	if (event.type == 'reset') {
	window.location.reload(false);
	//console.log("reset")
	}
});
$("#close").click(function(){
	close();
});