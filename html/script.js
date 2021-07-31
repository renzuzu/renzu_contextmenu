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
function show(event) {
	if (menus[event.k] == undefined) {
		menus[event.k] = event.content
		$("#menu").prepend('<menuitem onmouseover="PlaySound(`hover`);"><a class="switch"><i class="fad fa-bars"></i> '+event.k+'</a><menu id="'+nospace(event.k)+'">');
		for (const i in menus[event.k]) {
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
			$('#'+nospace(event.k)+'').append('<menuitem onmouseover="PlaySound(`hover`);"><a id="'+menus[event.k][i]['title'].replace(/[^a-z0-9]/gi,'')+'">'+menus[event.k][i]['fa']+' '+menus[event.k][i]['title']+'</a></menuitem>');
			$("#"+menus[event.k][i]['title'].replace(/[^a-z0-9]/gi,'')+"").click(function(){
				setTimeout(function(){ 
					send(menus[event.k][i],menus[event.k][i]["variables"]);
				 }, 500);
				document.getElementById("nav").style.display = 'none';
				PlaySound('accept')
			});
		}
		$("#menu").prepend('</menu></menuitem>');
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