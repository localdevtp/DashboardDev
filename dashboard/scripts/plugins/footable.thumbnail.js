(function($, w, undefined) {
	if (w.footable == undefined || w.footable == null)
		throw new Error('Please check and make sure footable.js is included in the page and is loaded prior to this script.');
	
	var defaults = {
		thumbnail: {
			enabled: true
		}
	};
	
	function Thumbnail() {
		var p = this;
		p.name = 'Footable Thumbnail';
		p.init = function(ft) {
			$(ft.table).bind({
				
				'footable_createDetail': function(e, el){
					if (e.ft.options.thumbnail.enabled == true){
						var element = e.detail.element;
						var data = e.detail.data;
						var thumbnail = $(element)
							.parents('.footable-row-detail')
							.prev('tr[data-thumbnail]').attr('data-thumbnail');
						
						if(thumbnail) {
							$(element).append('<figure class="footable-detail-thumbnail"><img src="'+ thumbnail +'" alt="" /></figure>')
						}
						
					}
				}
			});
			
		};
	};
	
	w.footable.plugins.register(new Thumbnail(), defaults);
	
})(jQuery, window);