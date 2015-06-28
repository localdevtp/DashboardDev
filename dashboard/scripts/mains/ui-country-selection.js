$(function(){
	var selector = '#CountrySelection,#DisplayCountrySelection,#BillingCountrySelection,#BuyerCountrySelection,#CompanyCountrySelection';
	
	if($(selector) != undefined && $(selector).length > 0){	
		// Wait for country selection to load	
		setTimeout(function(){
			
			$(selector).each(function(){
				
				var $cs = $(this);
				var $dd = $('.drop-down',$cs);
				var $postal = $('.add-postalcode',$cs);
	
				$cs.css({ position: 'relative' });
				$cs.append('<div class="loader-bg" style="position:absolute;top:0;left:0;z-index:9999;width:100%;height:100%;background:#FFF;background:rgba(255,255,255,.5);filter:alpha(opacity=70);"><p style="position:absolute;top:50%;left:50%;width:200px;height:38px;line-height:38px;text-align:center;margin-top:-19px;margin-left:-100px;background:#333;background:rgba(0,0,0,.8);color:#FFF;-webkit-border-radius:6px;-moz-border-radius:6px;border-radius:6px;">Updating location...</p></div>')
				var $lbg = $('.loader-bg',$cs).hide();
					
				$cs.on('change','.drop-down',function(){
					$lbg.fadeIn('fast');
	
					// check for html mutation
					var original = $cs.text();
					var mutation = setInterval(function(){
						if($cs.text() !== original){
							$lbg.fadeOut('fast');
							clearInterval(mutation);
						}
					},500);
					
					// clear load screen if no changes in 15s
					setTimeout(function(){
						$lbg.fadeOut('fast');
					},15000);
					
				});
				
				$cs.on('blur','.add-postalcode, .add-display-postalcode, .add-billing-postalcode',function(){
					$lbg.fadeIn('fast');
					
					// check for html mutation
					var original = $cs.text();
					var mutation = setInterval(function(){
						if($cs.text() !== original){
							$lbg.fadeOut('fast');
							clearInterval(mutation);
						}
					},500);
					
					// clear load screen if no changes in 15s
					setTimeout(function(){
						$lbg.fadeOut('fast');
					},15000);
					
				});
				
			});
		},1000);
	}
});