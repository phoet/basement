// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function ac(url, id){
	var speed = 'slow';
	var c = $('#' + id);
	c.toggle(speed);
	c.before('<div class="comment_gravatar spinner center"><img src="/assets/spinner.gif" /></div>');
	c.load(url + ' #' + id, function(data){
		$('.spinner').remove();
		c.toggle(speed);
	});
}

// ajax stuff
$(document).ready(function(){
	$(".more a").live("click", function(){
		var url = $(this).attr('href');
		var id = $(this).attr('name');
		var c = $('#' + id);
		$(this).before('<div class="comment_gravatar spinner center"><img src="/assets/spinner.gif" /></div>');
		c.load(url + ' #' + id, function(data){
			$('.spinner').remove();
		});
		return false;
	});
	$('.slideshow').live("click", function(){
		var name = $(this).attr('name');
		$('.images_' + name + ' a').lightBox();
		$('.images_' + name + ' a :first').click();
		return false;
	 });
	toggle_feed();
	$(".accordion").accordion({active: false, collapsible: true, autoHeight: false});
});

$(document).ajaxComplete(function(event,request, settings){
	toggle_feed();
});

function toggle_feed() {
	$('.header').click(function(){
		$(this).next().toggle('slow');
		return false;
	}).next().hide();
}