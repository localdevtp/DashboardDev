if (!$.support.transition) {
	$.fn.transition = $.fn.animate;
}

$(function(){
	$('[data-dismiss="alert"]').on('click',function(e){
		var main = $(this).parents('.alert');
		$(this).hide();
		$(main)
			.removeClass('flash')
			.transition({ opacity:0, height:0, paddingTop:0, paddingBottom:0, margin:0 }, 500, 'ease');
		e.stopPropagation();
	});
});

// Dialog alert (status: normal/null, error, warning, info)
function alertModal(content, title, status, showFooter){
	title = (title === undefined || title === "")? $('title').text() : title;
	status = (status === undefined || status === "")? "normal" : status;
	
	// < IE8 icon support
	var ie8supportIcons = '';
	if($('html').hasClass('lt-ie9')){
		switch(status){
			case 'warning':
				ie8supportIcons = '<span class="cufon-wrap"><span class="cufont" style="font-family: \'main\';font-size:28px">&#xe077;</span></span>';
				break;
			case 'info':
				ie8supportIcons = '<span class="cufon-wrap"><span class="cufont" style="font-family: \'main\';font-size:28px">&#xe074;</span></span>';
				break;
			case 'success':
				ie8supportIcons = '<span class="cufon-wrap"><span class="cufont" style="font-family: \'main\';font-size:28px">&#xe076;</span></span>';
				break;
			case 'danger':
				ie8supportIcons = '<span class="cufon-wrap"><span class="cufont" style="font-family: \'main\';font-size:28px">&#xe075;</span></span>';
				break;
			case 'error':
				ie8supportIcons = '<span class="cufon-wrap"><span class="cufont" style="font-family: \'main\';font-size:28px">&#xe075;</span></span>';
				break;
		}
	}
	
	$('body .modal.generated').remove();
	$('body').append('<div class="modal generated fade">'+
					 ' <div class="modal-header">'+
					 '   <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>'+
					 '   <h3>'+ title +'</h3>'+
					 ' </div>'+
					 ' <div class="modal-body modal-status-'+status+'">'+
					 '   '+ ie8supportIcons + content +
					 ' </div>'+
					 ' <div class="modal-footer">'+
					 '   <a href="#" class="btn" data-dismiss="modal">OK</a>'+
					 '</div>'+
					 '</div>');
	
	if(showFooter === false) {
		$('.modal.generated .modal-footer').remove();
	}
	
	if($('html').hasClass('lt-ie9')){ Cufon.replace(".modal.generated .cufont"); }
	
	$('body').on('keyup.modal.dismiss',function(e){
		if(e.which === 27) {
			$('.modal.generated').modal('hide');
		}
	});
	
	return $('.modal.generated').modal().on('hidden', function(){ $('body').off('keyup.modal.dismiss'); });
}

// Dialog confirmation (callback: callback function when OK is pressed)
function confirmModal(content, title, callback){
	title = (title === undefined || title === "")? $('title').text() : title;
	
	// < IE8 icon support
	var ie8supportIcons = '';
	if($('html').hasClass('lt-ie9')){
		ie8supportIcons = '<span class="cufon-wrap"><span class="cufont" style="font-family: \'main\';font-size:28px">&#xe077;</span></span>';
	}
	
	$('body .modal.generated').remove();
	$('body').append('<div class="modal generated fade">'+
					 ' <div class="modal-header">'+
					 '   <h3>'+ title +'</h3>'+
					 ' </div>'+
					 ' <div class="modal-body modal-status-warning">'+
					 '   '+ ie8supportIcons + content +
					 ' </div>'+
					 ' <div class="modal-footer">'+
					 '   <a href="#" class="btn modal-ok">OK</a>'+
					 '   <a href="#" class="btn btn-danger modal-cancel">Cancel</a>'+
					 '</div>'+
					 '</div>');
	
	if($('html').hasClass('lt-ie9')){ Cufon.replace(".modal.generated .cufont"); }
	
	$('.modal.generated .modal-ok').one('click', function(e){
		$('.modal.generated').on('hidden', callback).modal('hide');
		e.preventDefault();
	});
	
	$('.modal.generated .modal-cancel').one('click', function(e){
		$('.modal.generated').modal('hide');
		e.preventDefault();
	});
	
	return $('.modal.generated').modal({ backdrop: 'static', keyboard: false });
}

// Dialog prompt (callback: callback function when OK is pressed)
// Get value from $('.modal-input').val() in the callback to get prompt value
function promptModal(content, title, callback){
	title = (title === undefined || title === "")? $('title').text() : title;
	
	$('body .modal.generated').remove();
	$('body').append('<div class="modal generated fade">'+
					 ' <div class="modal-header">'+
					 '   <h3>'+ title +'</h3>'+
					 ' </div>'+
					 ' <div class="modal-body">'+
					 '   ' + content +
					 '   <br>'+
					 '   <input class="modal-input input-block-level" type="text" style="margin-top:5px;" tabindex="1" />'+
					 ' </div>'+
					 ' <div class="modal-footer">'+
					 '   <a href="#" class="btn modal-ok">OK</a>'+
					 '   <a href="#" class="btn btn-danger modal-cancel">Cancel</a>'+
					 '</div>'+
					 '</div>');
	
	
	$('.modal.generated .modal-ok').one('click', function(e){
		$('.modal.generated').modal('hide').on('hidden', callback);
		e.preventDefault();
	});
	
	$('.modal.generated .modal-cancel').one('click', function(e){
		$('.modal.generated').modal('hide');
		e.preventDefault();
	});
	
	return $('.modal.generated').modal({ backdrop: 'static', keyboard: false });
}