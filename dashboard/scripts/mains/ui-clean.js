;(function($){

	function strip(html)
	{
		 html = String(html)
			.replace(/(<p\/>|<p><\/p>|<br>|<div><br><\/div>)/ig,' ')
			.replace(/(<style.*?\/style>)/ig, '')
			.replace(/(<script.*?\/script>)/ig, '')
			.replace(/(&lt;style.*?\/style&gt;)/ig, '')
			.replace(/(&lt;script.*?\/script&gt;)/ig, '')
			.replace(/</ig, '&lt;')
			.replace(/>/ig, '&gt;');
		return html;
	}


	$(function(){
		$('[data-clean="html"]').each(function(e){
			var $this = $(this),
				isDisable = $this.disabled,
				isReadOnly = $this.readOnly,
				timer = false;

				if(!isDisable || !isReadOnly){
					$this.on('keyup paste',function(){
						if(!timer) {
							timer = true;
							setTimeout(function(){
								$this.val(strip($this.val()));
								timer = false;
							},500);
						}
					});
				}
		});
	});

})(jQuery);