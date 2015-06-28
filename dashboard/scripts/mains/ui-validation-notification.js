$(function(){
  $('.form-actions *[type=submit]').on('click', function(){
	  // allow some time for the validation to kick in
	  setTimeout(function(){
		  // lookout for errors
		  var $e = $('label.error:visible');
		  //console.log('This form has '+ $e.length +' errors!');
		  
		  // inject in alert above the form actions so user noticed it
		  if($e.length > 0){
			  var $f = $($e[0]).closest('form');
			  var $a = $('<div class="alert form-error-notification" style="clear:both;"><button type="button" class="close" data-dismiss="alert">&times;</button><strong>ERROR</strong></div>');
			  
			  $('.form-error-notification', $f).remove();
			  $('.form-actions', $f).before($a);
			  
			  // run through each error that occured and print it out
			  // if there is id set, the link will point to the error field.
			  $e.each(function(){
				  var link = ($(this).prev().attr('id') == undefined) ? '0' : $(this).prev().attr('id');
				  $('.form-error-notification').append('<a style="display:block;line-height:24px;text-decoration:none;" href=#'+
					link +'>'+ $(this).closest('.controls').prev('.control-label').text().trim() +
					  ': <span style="color:#CCC">'+ $(this).text() +'</span></a>');
			  });
		  }
		  
	  }, 500);  
  
  });
});