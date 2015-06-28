$(function(){
	
	// MAIN MENU ====================
    $('#nav .nav-icon').on('click',function(e){
      if(document.body.clientWidth < 480){
        var n = $('#nav');
        if($(n).hasClass('open-menu')) {
          $(n).removeClass('open-menu').addClass('close-menu');  
        } else {
          $(n).removeClass('close-menu').addClass('open-menu'); 
        }
      }
      e.preventDefault();
      return false;
    });
    $('#nav .nav-icon').on('keydown',function(e){
      if(document.body.clientWidth < 480){
        if (!/(38|40|27)/.test(e.keyCode)) { return; }
        var n = $('#nav');
        if($(n).hasClass('open-menu')) {
          $(n).removeClass('open-menu').addClass('close-menu');  
        } else {
          $(n).removeClass('close-menu').addClass('open-menu'); 
        }
      }
      e.preventDefault();
      return false;
    });
    if($.support.transition){
      var t_end = $.support.transition.end;
      $('#nav').on(t_end, function(){
        if($('#nav').hasClass('close-menu')) {
          $('#nav').removeClass('close-menu');
        }
      });
    }
	// MAIN MENU ====================
	
});