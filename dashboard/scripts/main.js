//@codekit-prepend "mains/ui-retina.js"
//@codekit-prepend "mains/ui-alert.js"
//@codekit-prepend "mains/ui-header.js"
//@codekit-prepend "mains/ui-navigation.js"
//@codekit-prepend "mains/ui-sortable.js"
//@codekit-prepend "mains/ui-masonry-sortable.js"

// Add support for IE8/7
if(typeof String.prototype.trim !== 'function') {
  String.prototype.trim = function() {
    return this.replace(/^\s+|\s+$/g, ''); 
  }
}

(function($){
  $.fn.extend({
    // Disable form [readonly]
    readonlyForm : function(){

      this.each(function(){
        $('input , textarea', this).prop('readonly', true);
        $('select, .btn', this).prop('disabled', true);
        $(this).on('click', '.lock-label , .toggle',function(e){
          e.stopPropagation();
          e.preventDefault();
          return false;
        });
      });
    }
  });

  $.urlParam = function(name){
    try {
      var results = new RegExp('[\\?&]' + name + '=([^&#]*)').exec(window.location.href);
      return results[1] || 0;
    } catch(err) {
      return 0;
    }
  }
})(jQuery);

// Only allow OTP request per min
var otprequest = false;
var otpel = '#request-otp';

if($(otpel)) {
  // Block request for first 20 sec
  $(otpel).on('click.preblock',function(e){
    e.stopImmediatePropagation();
    e.preventDefault();
  });
  $(otpel).tooltip({
    title: 'Please wait 10 seconds before requesting another'
  });
  setTimeout(function(){
    $(otpel).tooltip('destroy');
    $(otpel).off('click.preblock');
  }, 10000);

  // Block request per minute
  $(otpel).on('click.block',function(e){
    if(otprequest){
      e.stopImmediatePropagation();
      e.preventDefault();
    } else {
      otprequest = true;

      $(otpel).tooltip({
        title: 'You can only request once every minute'
      });

      setTimeout(function(){
        otprequest = false;
        $(otpel).tooltip('destroy');
      }, 60000);
    }
  });
}
// Only allow OTP request per min

$(document).ready(function(){

  $('a.has-checkbox').siblings('input').prop("checked", true);

  // Init Bootstrap Tooltips
  $('[data-toggle="tooltip"]').tooltip();

  // Init Placeholder for old browsers
  $('input[placeholder]').placeholder();
  $('.placeholder').removeClass('required');

  // Disable Re-enter password copy/paste
  $('[name="ConfirmPassword"]').on('cut copy paste',function(e){
    e.preventDefault();
  });

  // Popover for CVV2 help
  $("#CVV2").css('cursor','help');
  $("#CVV2").popover({
    html: true,
    trigger: (Modernizr.touch) ? 'click' : 'hover',
    title: "Visa / Mastercard",
    delay: { show:500, hide:100 },
    content: '<img src="/images/payments/cvv2-2x.png" style="height:75px" />'
  });
	
  // Timepicker
  $('[type="time"]').each(function(){
	if($('html').hasClass('no-appleios'))
	{
		$(this).prop('type','text');
		$(this).prop('placeholder','hh:mm AM');
		var t = $(this).datetimepicker({ startView:1, maxView:1, format: 'HH:ii P', showMeridian: true })
			.on('show',function(e){
				t.data('datetimepicker').picker.find('.datetimepicker-hours thead th')
					.css({ visibility: 'hidden' });
				t.data('datetimepicker').picker.find('.datetimepicker-minutes thead th')
					.css({ visibility: 'hidden' });
			});
	}
  });

  // Datepicker
  $('[type="date"]').each(function(){
    if($('html').hasClass('no-appleios'))
    {
      $(this).prop('type','text');
      $(this).prop('placeholder','dd/mm/yyyy');
	  $(this).datetimepicker({ minView:2, format: 'dd/mm/yyyy' });
    }
  });

  // Datetimepicker
  $('[type="datetime-local"]').each(function(){
    if($('html').hasClass('no-appleios'))
    {
      $(this).prop('type','text');
      $(this).prop('placeholder','dd/mm/yyyy hh:mm AM');
      $(this).datetimepicker({ format: 'dd/mm/yyyy HH:ii P', showMeridian: true });
    }
  });
	
  // Bootstrap file upload ui
  $('.file-input').bootstrapFileInput();
  $('.file-input.primary').parent('.file-input-wrapper').addClass('btn-primary');

  // Thank You Microsoft... for giving us work.
  if($('html').hasClass('lt-ie9')){
    // Add icon to alerts
    $('.alert').each(function(){
      var el;
      if($(this).hasClass('alert-info')){
        el = $('<span class="cufon-wrap"><span class="cufont" style="font-family: \'main\';font-size:28px">&#xe074;</span></span>');
        $(this).prepend(el);
      } else if($(this).hasClass('alert-success')){
        el = $('<span class="cufon-wrap"><span class="cufont" style="font-family: \'main\';font-size:28px">&#xe076;</span></span>');
        $(this).prepend(el);
      } else if($(this).hasClass('alert-danger') || $(this).hasClass('alert-error')){
        el = $('<span class="cufon-wrap"><span class="cufont" style="font-family: \'main\';font-size:28px">&#xe075;</span></span>');
        $(this).prepend(el);
      } else {
        el = $('<span class="cufon-wrap"><span class="cufont" style="font-family: \'main\';font-size:28px">&#xe077;</span></span>');
        $(this).prepend(el);
      }
      Cufon.replace(el);
    });
    // Refresh cufont when tab change
    $('a[data-toggle="tab"]').on('shown', function (e) {
      Cufon.refresh();
    });
  }

});