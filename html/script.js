var menus = []
var sound = false
var volume = 0.4
var inputval = undefined
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
	v.inputval = inputval
	var data = {table:v,variables:a};
	$.post("https://renzu_contextmenu/receivedata",JSON.stringify(data),function(datab){});
}

var back = []

function input(id) {
	var el = document.getElementById(id+'_input').value;
	inputval = el
	console.log(el)
}

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
			var field = `<input id="`+menus[event.k][i]['title'].replace(/[^a-z0-9]/gi,'')+`_input" type="text" value="1" style="
			position: absolute;
			top: 20%;
			right: 1%;
			width: 3vw;
			padding: 5px;
			margin: 5px;
			border-radius: 10px;
			text-align: center;
			" oninput="input('`+menus[event.k][i]['title'].replace(/[^a-z0-9]/gi,'')+`')">`
			if (!event.input) {
				field = ''
			}
			//$('#'+nospace(event.k)+'').append('<menuitem onmouseover="PlaySound(`hover`);"><a id="'+menus[event.k][i]['title'].replace(/[^a-z0-9]/gi,'')+'">'+menus[event.k][i]['fa']+' '+menus[event.k][i]['title']+'</a></menuitem>');
			$("#menu").prepend('<menuitem onmouseover="PlaySound(`hover`);"><a id="'+menus[event.k][i]['title'].replace(/[^a-z0-9]/gi,'')+'" class="switch" style="padding: 20px 60px;">'+menus[event.k][i]['fa']+' '+menus[event.k][i]['title']+'</a>'+field+'</menuitem>');
			$('#'+menus[event.k][i]['title'].replace(/[^a-z0-9]/gi,'')+'').click(function(){
				setTimeout(function(){ 
					send(menus[event.k][i],menus[event.k][i]["variables"]);
				}, 500);
				//document.getElementById("nav").style.display = 'none';
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
		$("#menu").prepend('<menuitem onmouseover="PlaySound(`hover`);"><a id="'+nospace(event.k)+'" class="switch" style="padding: 20px 60px;">'+main_fa+' '+event.k+'</a>');
		$("#"+nospace(event.k)+"").click(function(){
			document.getElementById("header").innerHTML = event.header;
			document.getElementById("menu").innerHTML = '';
			setTimeout(function(){ 
				ShowSubmenu(event);
			 }, 500);
			//document.getElementById("nav").style.display = 'none';
			PlaySound('accept')
		});
	}
}

function close() {
	PlaySound('close')
	document.getElementById("nav").style.display = 'none';
	setTimeout(function(){
		$.post("https://renzu_contextmenu/close",{},function(datab){});
		//window.location.reload(false);
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
		document.getElementById("header").innerHTML = event.content.header;
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

 document.onkeyup = function (data) {
	if (data.keyCode == '8') { // BACKSPACE
		close()
	}
	if (data.keyCode == '27') { // ENTER
		close()
	}
}