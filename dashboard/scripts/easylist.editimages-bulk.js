

$(document).ready(function() {
	
	// Init lightboxes
	initImageLightbox();
	
	$('.delete-image').live('click', function() {
		var parent = $(this).parents('li');
		
		var ImageUrl = $(this).prev().attr('href');
		var ImageCode = GetImageCode(ImageUrl);
		
		var IsNew = $(this).hasClass('IsNew');
		
		var ConfirmMessage = 'Are you sure you want to delete this photo?';
		
		if (IsNew)
		{
			var ImageDeleteUrl = $(this).attr('href');
		}
		else
		{
			ConfirmMessage += '<br/>Note: Photos will only be deleted after you save the changes.';
		}
		
		confirmModal(ConfirmMessage ,'Confirm Delete Photo', 
					 function(){
						 
						 // Public New Page, direct delete from server
						 if (IsNew)  
						 {
							 $.ajax({
								 url: ImageDeleteUrl ,
								 type: 'DELETE',
								 success: function(result) {
									 // Do something with the result
									 // alert('Success!');
								 }
							 });
						 }
						 else
						 {
							 if ($('#delete-photos').val() != "") {
								 $('#delete-photos').val($('#delete-photos').val() + ',');
							 }
							 $('#delete-photos').val($('#delete-photos').val() + ImageCode);
						 }
						 
						 hideCaptionEditor();
						 var li = parent;
						 li.fadeOut('fast', function() {
							 $(this).remove();
							 $('#update-photos').val('true');
						 });
						 
					 }
					);
		
		return false;
	});
	
});

function initImageLightbox(){
	$('#listing-thumbnails').magnificPopup({
		delegate:'li .view-image',
		type:'image',
		mainClass:'mfp-slide-bottom',
		gallery: {
			enabled: true
		},
		image: {
			cursor: null
		}
	});
}

function resizeThumbnails(){
	
	var w = $('li.thumb:first').width();
	var h = (w*3/4) + 38;
	var th = h - 38;
	
	$('li.thumb').css({ height: h+'px'});
	$('li.thumb .thumbnail').css({height: th+'px'});
	$('li.highlight').css({height: h+'px'});
}

function GetImageCode(ImageURL)
{
	var filename = ImageURL.substring(ImageURL.lastIndexOf('/')+1);
	if (filename.indexOf('-') > 0)
		var imageCode = filename.substring(0, filename.indexOf('-'));
	else
		var imageCode = filename.substring(0, filename.indexOf('.'));
	return imageCode;
}

function getCookie(c_name)
{
	var c_value = document.cookie;
	var c_start = c_value.indexOf(" " + c_name + "=");
	if (c_start == -1)
	{
		c_start = c_value.indexOf(c_name + "=");
	}
	if (c_start == -1)
	{
		c_value = null;
	}
	else
	{
		c_start = c_value.indexOf("=", c_start) + 1;
		var c_end = c_value.indexOf(";", c_start);
		if (c_end == -1)
		{
			c_end = c_value.length;
		}
		c_value = unescape(c_value.substring(c_start,c_end));
	}
	return c_value;
}

