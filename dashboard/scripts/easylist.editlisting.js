

$(document).ready(function() {

	// Set thumbnail sizes
	//resizeThumbnails();
	
	
	
    // Init field lock checkboxes
    //initLockLabels();


    // Init lightboxes
	$('.lightbox').colorbox({ maxWidth:"100%", maxHeight:"100%" });

    // Init uploader
    //initUploader();


    // Init form validation
    //initFormValidation();

    // Init change tracking
    $('#update-listing').val('false');
    $('#update-features').val('false');
    $('#update-photos').val('false');
    $('#update-videos').val('false');

	/*
    $('input.update-listing').live('click', function() {
        $(this).parents('form').not('.no-change-tracking').removeClass('has-changes');
    });

    $('input, select, textarea').live('change', function() {
        $(this).parents('form').not('.no-change-tracking').addClass('has-changes');
        $('#update-listing').val('true');
        if ($(this).attr('type') != 'checkbox') {
            $(this).addClass('changed');
            var label = $(this).parent().find('.lock-label').not('.locked');
            if (label) {
                $(label).addClass('locked').find('input').attr('checked', 'checked');
            }
        }
    });

    $(window).bind('beforeunload', function(e) {
        var hasChanges = false;
        $('form.has-changes').each(function() {
            hasChanges = true;
        });
        if (hasChanges) {
            $('.changed').addClass('has-changed');
            return "Warning: You have some unsaved changes on this page. The changed fields have been highlighted in green.";
        }
    });*/



    // Init Video Controls
    //initVideoControls();

    // Init Sortable image thumbs
    updatePhotoIndexes();
    updatePhotoCaptions();
    initImageSorting();
    //addPhotoPlaceholders();

	$('#listing-thumbnails').live(function(){
		resizeThumbnails();
	});
	$(window).resize(function () {
    	resizeThumbnails();
	});


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
    $('.delete-image').live('click', function() {
        var parent = $(this).parents('li');
        $('#delete-photos').val($('#delete-photos').val() + ',' + $(parent).attr('data-photo-id'));
        var confirmed = window.confirm('Are you sure you want to delete this photo?');
        if (confirmed) {
            hideCaptionEditor();
            var li = $(this).parent('li');
            li.fadeOut('fast', function() {
                $(this).remove();
                updatePhotoIndexes();
                updatePhotoCaptions();
                //addPhotoPlaceholders();
                $('#update-photos').val('true');
                $('form').not('.no-change-tracking').addClass('has-changes');
            });
        }
        return false;
    });



    // Init Sortable video thumbs
    //updateVideoIndexes();
    //updateVideoCaptions();
    //updateVideoDescriptions();
    //initVideoSorting();
    //addVideoPlaceholders();

    // Init video caption editor
    $('a.caption-video').live('click', function(e) {
        var parent = $(this).parents('li');
        $('#video-caption-edit').css({ 'display': 'block' }).attr('data-video-id', $(parent).attr('data-video-id'));
        $('#video-image img').attr('src', $(this).attr('href'))
        //.preload({ placeholder: 'http://easypagecdn.akamai.uniquewebsites.com.au/image-loading.gif', notFound: 'http://akamai.easylist.com.au/no-photo-Resized320x240.jpg' });
        $('#video-title').val($(parent).attr('data-video-caption'));
        $('#video-description').val($(parent).attr('data-video-description'));
        $.colorbox({ inline: true, href: "#video-caption-edit", onClosed: function() { hideVideoCaptionEditor(); } });
        return false;
    });
    $('#set-video-caption').live('click', function() {
        var id = $('#video-caption-edit').attr('data-video-id');
        var li = $('#video-thumbnails li[data-video-id="' + id + '"]');
        var title = $('#video-title').val();
        var description = $('#video-description').val();
        $(li).attr('data-video-caption', title);
        $(li).attr('data-video-description', description);
        hideVideoCaptionEditor();
        updateVideoCaptions();
        updateVideoDescriptions();
        $('#update-videos').val('true');
        $('form').not('.no-change-tracking').addClass('has-changes');
        return false;
    });
    $('.delete-video').live('click', function() {
        var parent = $(this).parents('li');
        $('#delete-videos').val($('#delete-videos').val() + ',' + $(parent).attr('data-video-id'));
        var confirmed = window.confirm('Are you sure you want to delete this video?');
        if (confirmed) {
            hideVideoCaptionEditor();
            var li = $(this).parent('li');
            li.fadeOut('fast', function() {
                $(this).remove();
                updateVideoIndexes();
                updateVideoCaptions();
                updateVideoDescriptions();
                addVideoPlaceholders();
                $('#update-videos').val('true');
                $('form').not('.no-change-tracking').addClass('has-changes');
            });
        }
        return false;
    });



    // Add video support
    $('#add-video-button').live('click', function() {
        // Update hidden form fields
        $('#insert-video').val($('#youtube-id').val());
        $('#insert-video-title').val($('#video-title').val());
        $('#insert-video-description').val($('#video-description').val());
        // Hide the lightbox
        $.colorbox.close()
        // click!
        $('form').not('.no-change-tracking').removeClass('has-changes');
        $('#submit-changes').click();
    });




    // Init feature editors
    updateFeatures();
    $('a.select-item-delete').live('click', function() {
        $(this).closest('li').remove();
        updateFeatures();
        $('#update-features').val('true');
        $('form').not('.no-change-tracking').addClass('has-changes');
        return false;
    });
    $('#add-standard-feature').live('click', function() {
        if ($('#new-standard-feature').val()) {
            $('#standard-features').append('<li><span>' + $('#new-standard-feature').val().toUpperCase() + '</span><a href="#" class="select-item-delete">Delete</a>')
        .animate({ scrollTop: $("#standard-features").prop("scrollHeight") }, 2000);
            $('#new-standard-feature').val('').focus();
            updateFeatures();
            $('#update-features').val('true');
            $('form').not('.no-change-tracking').addClass('has-changes');
            return false;
        }
    });
    $('#add-optional-feature').live('click', function() {
        if ($('#new-optional-feature').val()) {
            $('#optional-features').append('<li><span>' + $('#new-optional-feature').val() + '</span><a href="#" class="select-item-delete">Delete</a>')
        .animate({ scrollTop: $("#optional-features").prop("scrollHeight") }, 2000);
            $('#new-optional-feature').val('').focus();
            updateFeatures();
            $('#update-features').val('true');
            $('form').not('.no-change-tracking').addClass('has-changes');
            return false;
        }
    });
    $('#new-standard-feature').live('keypress', function(e) {
        if (e.keyCode == 13) {
            $('#add-standard-feature').click();
            return false;
        }
    });
    $('#new-optional-feature').live('keypress', function(e) {
        if (e.keyCode == 13) {
            $('#add-optional-feature').click();
            return false;
        }
    });


});

function resizeThumbnails(){
	
	var w = $('li.thumb:first').width();
	var h = (w*3/4) + 38;
	var th = h - 38;

	$('li.thumb').css({ height: h+'px'});
	$('li.thumb .thumbnail').css({height: th+'px'});
	$('li.highlight').css({height: h+'px'});
}

function initVideoControls() {
    // Add Video
    $('#add-youtube').colorbox({ href: function() {
        var url = '/ajax/add-youtube-video.aspx?listing=' + $('#add-youtube').attr('data-listing-code') + '&url=' + escape($('#youtube-url').val());
        return url;
    }
    });

    // Preview Video
    $('.video-viewer').colorbox({ href: function() {
        var url = '/ajax/preview-video.aspx?source=' + $(this).attr('data-video-source') + '&data=' + escape($(this).attr('data-video-data'));
        return url;
    }
    });
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
    var photos = [];
    $('#listing-thumbnails li').each(function(index, element) {
        if ($(element).attr('data-photo-id')) {
            photos[index] = $(element).attr('data-photo-id');
        }
    });
    $('#photo-order').val(photos);
    $('#listing-thumbnails li:first').not('no-photo').addClass('first');
}

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


function initVideoSorting() {
    $('#video-thumbnails').sortable({
        delay: 10,
        items: 'li:not(.no-video)',
        opacity: 0.6,
        placeholder: 'highlight',
        revert: 200,
        tolerance: 'pointer',
        start: function(event, ui) {
            $('#video-thumbnails li').removeClass('first');
            hideCaptionEditor();
        },
        stop: function(event, ui) {
            updateVideoIndexes();
            updateVideoCaptions();
            updateVideoDescriptions();
            $('#update-videos').val('true');
            $('form').not('.no-change-tracking').addClass('has-changes');
        }
    });
}

function updateVideoIndexes() {
    var photos = [];
    $('#video-thumbnails li').each(function(index, element) {
        if ($(element).attr('data-video-id')) {
            photos[index] = $(element).attr('data-video-id');
        }
    });
    $('#video-order').val(photos);
    $('#video-thumbnails li:first').not('.no-video').addClass('first');
}

function updateVideoCaptions() {
    var captions = [];
    $('#video-thumbnails li').each(function(index, element) {
        if ($(element).attr('data-video-caption')) {
            captions[index] = $(element).attr('data-video-caption');
        }
    });
    $('#video-captions').val(captions.join('|'));
}

function updateVideoDescriptions() {
    var desc = [];
    $('#video-thumbnails li').each(function(index, element) {
        if ($(element).attr('data-video-description')) {
            desc[index] = $(element).attr('data-video-description');
        }
    });
    $('#video-descriptions').val(desc.join('|'));
}

function hideVideoCaptionEditor() {
    $.colorbox.close()
    $('#video-caption-edit').hide();
}

function addVideoPlaceholders() {
    var limit = $('#max-videos').val();

    while ($('#video-thumbnails li').length < limit) {
        $('#video-thumbnails li:last').after('<li class="thumb no-video"></li>');
    }
    var numPhotos = $('#video-thumbnails li:not(.no-video)').length;
    var emptySlots = $('#video-thumbnails li.no-video');

    emptySlots.each(function() {
        $(this).html(emptySlots.index($(this)) + numPhotos + 1);
    });
}


function updateFeatures() {
    var standard = [];
    $('#standard-features li span').each(function(index, element) {
        standard[index] = $(element).html();
    });
    $('#listing-standard-features').val(standard.join('|'));
    var optional = [];
    $('#optional-features li span').each(function(index, element) {
        optional[index] = $(element).html();
    });
    $('#listing-optional-features').val(optional.join('|'));
}


function initLockLabels() {
    $('input.lock-field').each(function() {
        var id = $(this).attr('name');
        $(this).attr('id', id).wrap('<label class="lock-label" for="' + id + '" />');
    });
    $('.lock-label').click(function() {
        setupLockLabels();
    });
    setupLockLabels();
}

function setupLockLabels() {
    if ($('.lock-label input').length) {
        $('.lock-label').each(function() {
            $(this).removeClass('locked').attr('title', 'This field is unlocked, and may be overritten when data next syncs.');

        });
        $('.lock-label input:checked').each(function() {
            $(this).parent('label').addClass('locked').attr('title', 'This field is locked, so the original data sync source can no longer overwrite it.');
        });
    };
}

function initUploader() {


    $(function() {
        function log() {
            var str = "";

            plupload.each(arguments, function(arg) {
                var row = "";

                if (typeof (arg) != "string") {
                    plupload.each(arg, function(value, key) {
                        // Convert items in File objects to human readable form
                        if (arg instanceof plupload.File) {
                            // Convert status to human readable
                            switch (value) {
                                case plupload.QUEUED:
                                    value = 'QUEUED';
                                    break;

                                case plupload.UPLOADING:
                                    value = 'UPLOADING';
                                    break;

                                case plupload.FAILED:
                                    value = 'FAILED';
                                    break;

                                case plupload.DONE:
                                    value = 'DONE';
                                    break;
                            }
                        }

                        if (typeof (value) != "function") {
                            row += (row ? ', ' : '') + key + '=' + value;
                        }
                    });

                    str += row + " ";
                } else {
                    str += arg + " ";
                }
            });

            $('#log').val($('#log').val() + str + "\r\n");
        }

        var listingCode = $('#listing-code').val();
        var runtimes = 'html5,gears,browserplus,flash,html4';
      if(jQuery.browser.msie){
        runtimes = 'html5,gears,browserplus,html4'
      }

        $("#uploader").pluploadQueue({
            // General settings
            runtimes: runtimes,
            url: '/easylistimageupload.ashx',
            max_file_size: '10mb',
            chunk_size: '32kb',
            unique_names: true,


            // Resize images on clientside if we can
            resize: { width: 640, height: 480, quality: 90 },

            // Specify what files to browse for
            filters: [
          { title: "Image files", extensions: "jpg,jpeg" },
        ],

            // Flash/Silverlight paths
            flash_swf_url: 'http://easypagecdn.akamai.uniquewebsites.com.au/plupload_1432/plupload.flash.swf',
            silverlight_xap_url: 'http://easypagecdn.akamai.uniquewebsites.com.au/plupload_1432/plupload.silverlight.xap',

            // PreInit events, bound before any internal events
            preinit: {
                Init: function(up, info) {
                    log('[Init]', 'Info:', info, 'Features:', up.features);
                },

                UploadFile: function(up, file) {
                    log('[UploadFile]', file);

                    // You can override settings before the file is uploaded
                    // up.settings.url = 'upload.php?id=' + file.id;
                    up.settings.multipart_params = { listingCode: listingCode };
                }
            },

            // Post init events, bound after the internal events
            init: {
                Refresh: function(up) {
                    // Called when upload shim is moved
                    log('[Refresh]');
                },

                StateChanged: function(up) {
                    // Called when the state of the queue is changed
                    log('[StateChanged]', up.state == plupload.STARTED ? "STARTED" : "STOPPED");
                },

                QueueChanged: function(up) {
                    // Called when the files in queue are changed by adding/removing files
                    log('[QueueChanged]');
                },

                UploadProgress: function(up, file) {
                    // Called while a file is being uploaded
                    log('[UploadProgress]', 'File:', file, "Total:", up.total);
                },

                FilesAdded: function(up, files) {
                    // Callced when files are added to queue
                    log('[FilesAdded]');

                    plupload.each(files, function(file) {
                        log('  File:', file);
                    });
                },

                UploadComplete: function() {
                    $('#submit-changes').click();
                },

                Error: function(up, args) {
                    if (args.file) {
                        log('[error]', args, "File:", args.file);
                    } else {
                        log('[error]', args);
                    }
                }
            }
        });

        $('#log').val('');
        $('#clear').click(function(e) {
            e.preventDefault();
            $("#uploader").pluploadQueue().splice();
        });
    });

}

function initFormValidation() {
    // Init form validation
    $('.masked').each(function() {
        var m = $(this).attr('data-mask');
        $(this).mask(m);
    });
    $('input.date-time').each(function() {
        var m = jQuery(this).attr('data-datetime');
        if (m) {
            $(this).datetimepicker(eval("(" + m + ")"));
        }
        else {
            $(this).datetimepicker();
        }
    });
    $('input.date-only').each(function() {
        var m = $(this).attr('data-datetime');
        if (m) {
            $(this).datepicker(eval("(" + m + ")"));
        }
        else {
            $(this).datepicker();
        }
    });
    $('input.time-only').each(function() {
        var m = $(this).attr('data-datetime');
        if (m) {
            $(this).timepicker(eval("(" + m + ")"));
        }
        else {
            $(this).timepicker();
        }
    });

    $.metadata.setType('attr', 'data-validate');

    $('form').each(function() {
        $(this).validate();
    });
}
