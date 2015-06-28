

$(document).ready(function() {
	
	// STOP IE FROM CACHING AJAX PAGE!
	$.ajaxSetup({
		cache: false
	});
	
	$( document ).ajaxStart(function () {
		$('#loading-bg-transparent').show();
		$("#loading-dialog").show();
	});

	$( document ).ajaxComplete(function () {
		$('#loading-bg-transparent').hide();
		$("#loading-dialog").hide();
	});
	
	// Set thumbnail sizes
	//resizeThumbnails();
	
		// Init lightboxes
		//$('.lightbox').colorbox({ maxWidth:"100%", maxHeight:"100%" });
		initImageLightbox();

		// Init uploader
		//initUploader();

		// Init Sortable image thumbs
		updatePhotoIndexes();
		updatePhotoCaptions();
		initImageSorting();
		//addPhotoPlaceholders();

	/*
	$('#listing-thumbnails').live(function(){
		resizeThumbnails();
	});
	$(window).resize(function () {
			resizeThumbnails();
	});
*/

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
		
		$('.rotate-image-left').live('click', function() {
			RotateImage(this, 'Left'); 
			return false;
		});
		$('.rotate-image-right').live('click', function() {
			RotateImage(this, 'Right');
			return false;
		});
		
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
			//$('#delete-photos').val($('#delete-photos').val() + ',' + $(parent).attr('data-photo-id'));
			//$('#delete-photos').val($('#delete-photos').val() + ',' + );
					
			confirmModal(ConfirmMessage ,'Confirm Delete Photo', 
				function(){ //alert('Test');
					
					// Public New Page, direct delete from server
					if (IsNew)  
					{
						/*$.ajax({
							url: ImageDeleteUrl ,
							type: 'DELETE',
							success: function(result) {
								// Do something with the result
								// alert('Success!');
							}
						});*/
						
						$.getJSON(ImageDeleteUrl, 
							function (data) {});
						
						// Assign handlers immediately after making the request,
						// and remember the jqxhr object for this request
						/*var jqxhr = $.getJSON(ImageDeleteUrl, function() {
						  console.log( "success" );
						})
						  .done(function() {
							console.log( "second success" );
						  })
						  .fail(function() {
							console.log( "error" );
						  })
						  .always(function() {
							console.log( "complete" );
						  });
						 
						// Perform other work here ...
						 
						// Set another completion function for the request above
						jqxhr.complete(function() {
						  console.log( "second complete" );
						});*/
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
						updatePhotoIndexes();
						updatePhotoCaptions();
						//addPhotoPlaceholders();
						$('#update-photos').val('true');
						$('form').not('.no-change-tracking').addClass('has-changes');
						checkImageLimit();
					});
				
				}
			);
			
				return false;
		});
	
});

function RotateImage(Obj, ImageRotation)
{
	var parent = $(Obj).parents('li');
	
	$("#loading-dialog").css({
		"position":"absolute", 
		"top": (parent.position().top +20) + "px",
		"left": (parent.position().left + 100) + "px",
	});
	
	var ImageUrl = parent.find('.view-image').attr('href');
	var ImageFileName = GetImageFileName(ImageUrl);
	var ListingCode = getURLParam("listing");
	
	var RotateAPI= "";
	var IsNew = $(Obj).hasClass('IsNew');
	if (IsNew)
	{
		RotateAPI = $(Obj).attr('href') ;
	}
	else
	{
		RotateAPI="/api?api=ImageToRotate&id=" + ListingCode + "&imgFileName=" + ImageFileName + "&imgRotation=" + ImageRotation;
	}
	
	$.getJSON(RotateAPI, 
		function (data) {
			if (data.State == 1)
			{
				var newThumbnailUrl = data.Result;
				
				var OldImageCode = GetImageCode(ImageUrl);	// Old Image Code
				var NewImageCode = data.Message;			// New Image Code
				
				parent.find('.view-image').attr('href', newThumbnailUrl.replace("108x108","640x480"));
				parent.find('.thumbnail').children().attr('src', newThumbnailUrl);
				
				$('#photo-order').val($('#photo-order').val().replace(OldImageCode, NewImageCode));
				
				if (IsNew)
				{	
					parent.find('.delete-image').attr('href', parent.find('.delete-image').attr('href').replace(OldImageCode, NewImageCode) );
					parent.find('.rotate-image-left').attr('href', parent.find('.rotate-image-left').attr('href').replace(OldImageCode, NewImageCode) );
					parent.find('.rotate-image-right').attr('href', parent.find('.rotate-image-right').attr('href').replace(OldImageCode, NewImageCode) );
				}
			}
		}
	);
	
	return false;
}

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

function initImageSorting() {
		$('#listing-thumbnails').sortable({
		forcePlaceholderSize: true,
				delay: 10,
				items: 'li:not(.no-photo)',
				opacity: 0.6,
				placeholder: 'highlight span3',
				revert: 200,
				tolerance: 'pointer',
				start: function(event, ui) {
		
						$('#listing-thumbnails li').removeClass('first');
			$('#listing-thumbnails li.highlight')
				.height($('#listing-thumbnails li.span3:first').height());
						hideCaptionEditor();
				},
				stop: function(event, ui) {
						updatePhotoIndexes();
						updatePhotoCaptions();
						$('#update-photos').val('true');
						$('form').not('.no-change-tracking').addClass('has-changes');
				}
		});
}


function updatePhotoIndexes() {
		var photos = []; var count = 0 ;
		//$('#listing-thumbnails li a').each(function(index, element) {
		$('#listing-thumbnails li .view-image').each(function(index, element) {
			var ImageURL = $(element).attr('href');
				if (ImageURL) {
					var imageCode = GetImageCode(ImageURL);
					if ((imageCode != "#") && (imageCode != ""))
					{
						photos[count] = imageCode;
						count ++;
					}
				}
		});
		$('#photo-order').val(photos);
		
		$('#listing-thumbnails li:first').not('no-photo').addClass('first');
	
		// Trigger lock
		/*var label = $('#upload-photo').parent().find('.lock-label').not('.locked');
		$(label).addClass('locked').find('input').attr('checked', 'checked');*/
}


function GetImageFileName(ImageURL)
{
	var filename = ImageURL.substring(ImageURL.lastIndexOf('/')+1);
	
	return filename;
}

function GetImageCode(ImageURL)
{
	var filename = ImageURL.substring(ImageURL.lastIndexOf('/')+1);
	if (filename.lastIndexOf('-') > 0)
		var imageCode = filename.substring(0, filename.lastIndexOf('-'));
	else
		var imageCode = filename.substring(0, filename.indexOf('.'));
	return imageCode;
}

/*
function updatePhotoIndexes() {
		var photos = [];
		$('#listing-thumbnails li').each(function(index, element) {
				if ($(element).attr('data-photo-id')) {
						photos[index] = $(element).attr('data-photo-id');
				}
		});
		$('#photo-order').val(photos);
		$('#listing-thumbnails li:first').not('no-photo').addClass('first');
}
*/

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
		//$.colorbox.close()
		$('#caption-edit').hide();
}

function addPhotoPlaceholders() {
		var limit = $('#max-photos').val();

		while ($('#listing-thumbnails li').length < limit) {
				$('#listing-thumbnails li:last').after('<li class="thumb span3 no-photo"><span></span></li>');
		}
		var numPhotos = $('#listing-thumbnails li:not(.no-photo)').length;
		var emptySlots = $('#listing-thumbnails li.no-photo span');

		emptySlots.each(function() {
				$(this).html(emptySlots.index($(this)) + numPhotos + 1);
		});
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
		
