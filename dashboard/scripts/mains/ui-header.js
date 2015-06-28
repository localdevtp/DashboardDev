$(function(){
	$('#header .search-icon').on('click',function(e){
		var s = $(this).parents('.search');
		var f = $('form',s);
		if(Modernizr.mq('(max-width: 479px)')){
			$(s).toggleClass('open');
			$('.nav-icon').toggleClass('hide');
			$('#header .brand').toggleClass('hide');
			$('#header .user').toggleClass('hide');
			$('input[type="text"]', s).focus().one('blur', function(){
				$(s).toggleClass('open');
				$('.nav-icon').toggleClass('hide');
				$('#header .brand').toggleClass('hide');
				$('#header .user').toggleClass('hide');
			});
		} else {
			$(f).submit();
		}
		e.preventDefault();
	});
	
	$('.user-help, .user-dropdown-help').on('click',function(e){
		var url = $(this).attr('href');
		var width = ($(this).data('width'))  ? $(this).data('width') : ($(this).attr("modal-width") ? $(this).attr("modal-width") : 700);
		var height = ($(this).data('height')) ? $(this).data('height') : ($(this).attr("modal-height") ? $(this).attr("modal-width") : 700);
		// normal window popup
		try {
			var left = (screen.width/2)-(width/2);
			var top = (screen.height/2)-(height/2);
			window.open(url,null,"height="+ height +",width="+ width +",status=yes,toolbar=no,menubar=no,location=no,resizable=no,top="+top+", left="+left);
		} catch(e) {
			window.open(url,null,"height="+ height +",width="+ width +",status=yes,toolbar=no,menubar=no,location=no,resizable=no");
		}
		e.preventDefault();
	});
	
});