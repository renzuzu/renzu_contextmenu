var menus = []
var sound = false
var volume = 0.4
function nospace(str) {
	return str.replace(/[^a-z0-9]/gi,'');
}

var playing = ''
function PlaySound(string) {
	if (sound == 'false') { return }
    var audioPlayer = null;
    if (audioPlayer != null) {
        audioPlayer.pause();
    }
    audioPlayer = new Audio("./audio/" + string + ".ogg");
    audioPlayer.volume = Number(volume);
	if (playing == '' || playing !== string) {
		playing = string
		setTimeout(function(){
			audioPlayer.play();
			playing = ''
		}, 100);
	}
}

function send(v,a) {
	var data = {table:v,variables:a};
	$.post("https://renzu_contextmenu/receivedata",JSON.stringify(data),function(datab){});
}
// function show(event) {
// 	if (menus[event.k] == undefined && event.k !== undefined && event.k !== '') {
// 		menus[event.k] = event.content
// 		var main_fa = '<i class="fad fa-bars"></i>'
// 		if (event.main_fa !== false) {
// 			main_fa = event.main_fa
// 		}
// 		$("#menu").prepend('<menuitem onmouseover="PlaySound(`hover`);"><a class="switch" style="padding: 20px 60px;">'+main_fa+' '+event.k+'</a><menu id="'+nospace(event.k)+'">');
// 		var menucount = 0
// 		for (const i in menus[event.k]) {
// 			menucount = menucount + 1
// 			menu[menus[event.k][i]['title']] = true
// 			if (menus[event.k][i]['variables'] !== undefined) {
// 				if (menus[event.k][i]['variables'].send_entity) {
// 					menus[event.k][i]['variables'].entity = event.entity
// 				}
// 				menus[event.k][i]['variables'].path = {name:event.k,title:i}
// 			}
// 			if (menus[event.k][i]['fa'] == undefined) {
// 				menus[event.k][i]['fa'] = '<i class="fad fa-cog"></i>';
// 			}
// 			$('#'+nospace(event.k)+'').append('<menuitem onmouseover="PlaySound(`hover`);"><a id="'+menus[event.k][i]['title'].replace(/[^a-z0-9]/gi,'')+'">'+menus[event.k][i]['fa']+' '+menus[event.k][i]['title']+'</a></menuitem>');
// 			$("#"+menus[event.k][i]['title'].replace(/[^a-z0-9]/gi,'')+"").click(function(){
// 				setTimeout(function(){ 
// 					send(menus[event.k][i],menus[event.k][i]["variables"]);
// 				 }, 500);
// 				document.getElementById("nav").style.display = 'none';
// 				PlaySound('accept')
// 			});
// 		}
// 		$("#menu").prepend('</menu></menuitem>');
// 		console.log(menucount,'gago')
// 		if (menucount == 0) {
// 			$.post("https://renzu_contextmenu/close",{},function(datab){});
// 			window.location.reload(false);
// 		}
// 	}
// }

var back = []
function ShowSubmenu(event) {
	var menucount = 0
	for (const i in menus[event.k]) {
		menucount = menucount + 1
		if (menus[event.k][i]['title']) {
			menu[menus[event.k][i]['title']] = true
			if (menus[event.k][i]['variables'] !== undefined) {
				if (menus[event.k][i]['variables'].send_entity) {
					menus[event.k][i]['variables'].entity = event.entity
				}
				menus[event.k][i]['variables'].path = {name:event.k,title:i}
			}
			if (menus[event.k][i]['fa'] == undefined) {
				menus[event.k][i]['fa'] = '<i class="fad fa-cog"></i>';
			}
			//$('#'+nospace(event.k)+'').append('<menuitem onmouseover="PlaySound(`hover`);"><a id="'+menus[event.k][i]['title'].replace(/[^a-z0-9]/gi,'')+'">'+menus[event.k][i]['fa']+' '+menus[event.k][i]['title']+'</a></menuitem>');
			$("#menu").prepend('<menuitem onmouseover="PlaySound(`hover`);"><a id="'+menus[event.k][i]['title'].replace(/[^a-z0-9]/gi,'')+'" class="switch" style="padding: 20px 60px;">'+menus[event.k][i]['fa']+' '+menus[event.k][i]['title']+'</a></menuitem>');
			$('#'+menus[event.k][i]['title'].replace(/[^a-z0-9]/gi,'')+'').click(function(){
				setTimeout(function(){ 
					send(menus[event.k][i],menus[event.k][i]["variables"]);
				}, 500);
				document.getElementById("nav").style.display = 'none';
				PlaySound('accept')
			});
		}
	}
	$("#menu").prepend('<menuitem>\
		<a id="close-'+nospace(event.k)+'"><i class="fad fa-window-close"></i> BACK</a>\
	</menuitem>');
	$('#close-'+nospace(event.k)+'').click(function() {
		document.getElementById("menu").innerHTML = '';
		PlaySound('close')
		menus[event.k] = undefined
		setTimeout(function() {
			for (const i in back) {
				menus[i] = undefined
				show(back[i],true);
			}
			$("#menu").append('<menuitem>\
				<a id="close2"><i class="fad fa-window-close"></i> Close</a>\
			</menuitem>');
			$("#close2").click(function(){
				close();
			});
		 }, 500);
	});
}

function show(event,isback) {
	if (!isback) {
		back[event.k] = event
	}
	if (menus[event.k] == undefined && event.k !== undefined && event.k !== '') {
		menus[event.k] = event.content
		var main_fa = '<i class="fad fa-tasks-alt"></i>'
		if (event.main_fa !== false && event.main_fa !== undefined) {
			main_fa = event.main_fa
		}
		$("#menu").prepend('<menuitem onmouseover="PlaySound(`hover`);"><a id="'+nospace(event.k)+'" class="switch" style="padding: 20px 60px;">'+main_fa+' '+event.k+'</a><menu id="'+nospace(event.k)+'">');
		$("#"+nospace(event.k)+"").click(function(){
			document.getElementById("menu").innerHTML = '';
			setTimeout(function(){ 
				ShowSubmenu(event);
			 }, 500);
			//document.getElementById("nav").style.display = 'none';
			PlaySound('accept')
		});
		// var menucount = 0
		// for (const i in menus[event.k]) {
		// 	menucount = menucount + 1
		// 	menu[menus[event.k][i]['title']] = true
		// 	if (menus[event.k][i]['variables'] !== undefined) {
		// 		if (menus[event.k][i]['variables'].send_entity) {
		// 			menus[event.k][i]['variables'].entity = event.entity
		// 		}
		// 		menus[event.k][i]['variables'].path = {name:event.k,title:i}
		// 	}
		// 	if (menus[event.k][i]['fa'] == undefined) {
		// 		menus[event.k][i]['fa'] = '<i class="fad fa-cog"></i>';
		// 	}
		// 	$('#'+nospace(event.k)+'').append('<menuitem onmouseover="PlaySound(`hover`);"><a id="'+menus[event.k][i]['title'].replace(/[^a-z0-9]/gi,'')+'">'+menus[event.k][i]['fa']+' '+menus[event.k][i]['title']+'</a></menuitem>');
		// 	$("#"+menus[event.k][i]['title'].replace(/[^a-z0-9]/gi,'')+"").click(function(){
		// 		setTimeout(function(){ 
		// 			send(menus[event.k][i],menus[event.k][i]["variables"]);
		// 		 }, 500);
		// 		document.getElementById("nav").style.display = 'none';
		// 		PlaySound('accept')
		// 	});
		// }
		// $("#menu").prepend('</menu></menuitem>');
		// console.log(menucount,'gago')
		// if (menucount == 0) {
		// 	$.post("https://renzu_contextmenu/close",{},function(datab){});
		// 	window.location.reload(false);
		// }
	}
}

function close() {
	PlaySound('close')
	document.getElementById("nav").style.display = 'none';
	setTimeout(function(){
		$.post("https://renzu_contextmenu/close",{},function(datab){});
		window.location.reload(false);
	 }, 400);
}

var current = undefined
var clearing = false
window.addEventListener('message', function (table) {
	let event = table.data;
	clearing = false
	if (event.content.clear && event.content.k != undefined) {
		window.location.reload(false);
	}
	if (event.type == 'insert') {
		show(event.content)
	}
	if (event.type == 'show') {
		document.getElementById("nav").style.display = 'block';
	}
	if (event.type == 'reset') {
		window.location.reload(false);
	}
	if (event.type == 'sound') {
		sound = ""+event.content.sound+"";
		volume = ""+event.content.volume+"";
		localStorage.removeItem("sound");
		localStorage.setItem("sound", ""+event.content.sound+"");
		localStorage.setItem("volume", ""+event.content.volume+"");
	}
});
$("#close").click(function(){
	close();
});
setTimeout(function(){
	sound = localStorage.getItem("sound");
	volume = localStorage.getItem("volume");
 }, 400);