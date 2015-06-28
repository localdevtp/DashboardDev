 function getSpecURLParam(url, name) {
        name = name.replace(/[\[]/, "\\\[").replace(/[\]]/, "\\\]");
        var regexS = "[\\?&]" + name + "=([^&#]*)";
        var regex = new RegExp(regexS);
        var results = regex.exec(url);
        if (results == null)
            return "";
        else
            return results[1];
    }

$(document).ready(function() {
	
	// Unsecure video notice
	var howtoCalled = false;
	$('#how-to-unsecure').on('click',function(e){
		if(!howtoCalled){
			
			howtoCalled = true;
			var $result = $('<div />');
			
			$result.load('/docs/faq.aspx #dmi', function(){
				alertModal($result.html(),'Security Info');
				howtoCalled = false;
			});
		}
		
		e.preventDefault();
	});
	
	initVideoLightbox($(this).attr('data-video-source'));
	$('#ViewVideo').live('click', function(e) 
	{
		initVideoLightbox($(this).attr('data-video-source'));
		e.preventDefault();
	});
	
	$('#Add-Video').live('click', function(e) {
		var url = $("#youtube-url").val();
		
		if (url == "")
		{
			alert("Please paste full youtube link!"); return;
		}
		//var matches = url.match(/watch\?v=([a-zA-Z0-9\-_]+)/);
		var matches = url.match(/^(http|https):\/\/(?:(www|m)\.)?youtube.com\/.*watch\?(?=.*v=\w+)(?:\S+)?$/);
		if (!matches)
		{
			alert('Please provides valid youtube link.'); return;
		}
		
		//url ="https://www.youtube.com/watch?v=ouNgYUhEzxw";
		var YoutubeID = getSpecURLParam(url, 'v');
		
		var newVideoItem = '<li class="span3 thumb" data-video-id=' + YoutubeID + '>';
		newVideoItem  += '<div class="thumbnail">';
		newVideoItem  += '<img src="http://img.youtube.com/vi/' + YoutubeID + '/1.jpg" width="108" height="81" alt="Video thumbnail 1" />';
		newVideoItem  += '</div>';
		newVideoItem  += '<a id="ViewVideo" href="https://www.youtube.com/embed/' + YoutubeID + '" class="video-viewer" data-video-source="Youtube" data-video-data="'+ YoutubeID +'"><i class="icon-eye"></i></a> ';
		newVideoItem  += '<a href="#" class="delete-video" data-video-id="' + YoutubeID + '" title="Delete video"><i class="icon-remove"></i></a>';
		newVideoItem  += '</li>';
		
		$('#video-thumbnails').append(newVideoItem);
		
		updateVideoIndexes();
		
		$("#youtube-url").val('');
		
		e.preventDefault();
	});

	//******************************
	updateVideoIndexes();
    // updatePhotoCaptions();
    initVideoSorting();
	//******************************
	
    // Init photo caption editor
	/*
    $('a.caption-image').live('click', function(e) {
        var parent = $(this).parents('li');
        $('#caption-edit').css({ 'display': 'block' }).attr('data-photo-id', $(parent).attr('data-photo-id'));
        $('#caption-image img').attr('src', $(parent).find('a.lightbox').attr('href'))
        //.preload({ placeholder: 'http://easypagecdn.akamai.uniquewebsites.com.au/image-loading.gif', notFound: 'http://akamai.easylist.com.au/no-photo-Resized320x240.jpg' });
        $('#image-caption').val($(parent).attr('data-photo-caption'));
        $.colorbox({ inline: true, href: "#caption-edit", innerWidth: '352px', innerHeight: '360px', onClosed: function() { hideCaptionEditor(); } });
        return false;
    });
    $('#set-image-caption').live('click', function() {
        var parent = $(this).parents('div');
        var id = $(parent).attr('data-photo-id');
        var val = $('#image-caption').val();
        var li = $('#listing-thumbnails li[data-photo-id="' + id + '"]');
        $(li).attr('data-photo-caption', val);
        hideCaptionEditor();
        updatePhotoCaptions();
        $('#update-photos').val('true');
        $('form').not('.no-change-tracking').addClass('has-changes');
        return false;
    });*/
	
	
    $('.delete-video').live('click', function() {
        var parent = $(this).parents('li');
        
		var VideoUrl = $(this).prev().attr('href');
		var YoutubeCode = GetYoutubeCode(VideoUrl);
		
		confirmModal('Are you sure you want to delete this video? <br/>Note: Videos will only be deleted after you save the changes.','Confirm Delete Video', 
			function(){ //alert('Test');
				//hideCaptionEditor();
			
				//var li = $(this).parents('li');
				var li = parent;
				li.fadeOut('fast', function() {
					$(this).remove();
					
					updateVideoIndexes();
					//updatePhotoCaptions();
					
					// $('#update-videos').val('true');
					$('form').not('.no-change-tracking').addClass('has-changes');
				});
			}
		);
		
		/*var confirmed = window.confirm('Are you sure you want to delete this video?');
        if (confirmed) {
            //hideCaptionEditor();
			
            //var li = $(this).parents('li');
			var li = parent;
            li.fadeOut('fast', function() {
                $(this).remove();
                
				updateVideoIndexes();
                //updatePhotoCaptions();
                
                // $('#update-videos').val('true');
                $('form').not('.no-change-tracking').addClass('has-changes');
            });
        }*/
        return false;
    });

});

function initVideoLightbox(VideoType) {
	$('#video-thumbnails').magnificPopup({
		delegate:'li .video-viewer',
		mainClass:'mfp-slide-bottom',
		type:'iframe',
		gallery: {
			enabled: true
		},
		iframe: {
			markup: '<div class="mfp-iframe-scaler">'+
			'<div class="mfp-close"></div>'+
			'<iframe class="mfp-iframe" frameborder="0" allowfullscreen></iframe>'+
			'<div class="mfp-bottom-bar">'+
			'<div class="mfp-title"></div>'+
			'<div class="mfp-counter"></div>'+
			'</div>'+
			'</div>',
			patterns: {
				youtube: {
					index: 'youtube.com/',
					id: 'embed/',
					src: '//www.youtube.com/embed/%id%?autoplay=1'
				},
				easylist: {
					index: 'mediaID=',
					id: 'embed/',
					src: '/listings/listing-video-dmi.aspx?id='+getParameterByName('listing')
				}
			}
		},
		callbacks: {
			change: function() {
				if(/.*listing-video-dmi.*/.test($('iframe',this.content).attr('src'))) {
					// DMI
					$(this.content).parent().css({ height:'555px', width:'740px' });
				} else {
					// You Tube
					$(this.content).parent().css({ height:'auto', width:'100%' });
				}
			}
		}
	});
}

function getVideoLink(VideoType)
{
	var VideoLink = "";
	if (VideoType == 'YouTube')
	{
		VideoLink = '//www.youtube.com/embed/%id%?autoplay=1';
	}else
	{
		//VideoLink = '/listings/listing-video-dmi.aspx?id='+getParameterByName('listing')
		VideoLink = '/listings/listing-video-dmi.aspx?id='+getParameterByName('listing');
	}
	
	return VideoLink;
}

function getParameterByName(name) {
    name = name.replace(/[\[]/, "\\\[").replace(/[\]]/, "\\\]");
    var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
        results = regex.exec(location.search);
    return results == null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
}

function initVideoSorting() {
    $('#video-thumbnails').sortable({
		forcePlaceholderSize: true,
        delay: 10,
        items: 'li:not(.no-photo)',
        opacity: 0.6,
        placeholder: 'highlight span3',
        revert: 200,
        tolerance: 'pointer',
        start: function(event, ui) {
		
            $('#video-thumbnails li').removeClass('first');
			$('#video-thumbnails li.highlight')
				.height($('#video-thumbnails li.span3:first').height());
            hideCaptionEditor();
        },
        stop: function(event, ui) {
            updateVideoIndexes();
            // updatePhotoCaptions();
            $('#update-photos').val('true');
            $('form').not('.no-change-tracking').addClass('has-changes');
        }
    });
}

function updateVideoIndexes() {
    var videos = []; var count = 0 ;
    $('#video-thumbnails li a').each(function(index, element) {
		var VideoURL = $(element).attr('href');
        if (VideoURL) {
			var YoutubeCode = GetYoutubeCode(VideoURL);
			if ((YoutubeCode != "#") && (YoutubeCode != ""))
			{
				videos[count] = YoutubeCode;
				count ++;
			}
        }
    });
    $('#video-order').val(videos);
    //$('#listing-thumbnails li:first').not('no-photo').addClass('first');
}

function GetYoutubeCode(VideoURL)
{
	var YoutubeCode = VideoURL.substring(VideoURL.lastIndexOf('/')+1);
	return YoutubeCode;
}
/*
function updatePhotoCaptions() {
    var captions = [];
    $('#listing-thumbnails li').each(function(index, element) {
        if ($(element).attr('data-photo-caption')) {
            captions[index] = $(element).attr('data-photo-caption');
        }
    });
    $('#photo-captions').val(captions.join('|'));
}

function hideCaptionEditor() {
    $.colorbox.close()
    $('#caption-edit').hide();
}
*/
