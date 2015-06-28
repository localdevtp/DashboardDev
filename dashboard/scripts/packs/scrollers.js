/*! Copyright (c) 2011 Piotr Rochala (http://rocha.la)
 * Dual licensed under the MIT (http://www.opensource.org/licenses/mit-license.php)
 * and GPL (http://www.opensource.org/licenses/gpl-license.php) licenses.
 *
 * Version: 1.0.6
 *
 */


$(document).ready(function(){
	$('.slim-scroll').slimScroll({height: '250px', alwaysVisible: true});
	
});


(function(d){jQuery.fn.extend({slimScroll:function(m){var a=d.extend({wheelStep:20,width:"auto",height:"250px",size:"7px",color:"#000",position:"right",distance:"1px",start:"top",opacity:0.4,alwaysVisible:!1,disableFadeOut:!1,railVisible:!1,railColor:"#333",railOpacity:"0.2",railClass:"slimScrollRail",barClass:"slimScrollBar",wrapperClass:"slimScrollDiv",allowPageScroll:!1,scroll:0,touchScrollStep:200},m);this.each(function(){function f(h,d,f){var g=h,e=b.outerHeight()-c.outerHeight();d&&(g=parseInt(c.css("top"))+
h*parseInt(a.wheelStep)/100*c.outerHeight(),g=Math.min(Math.max(g,0),e),c.css({top:g+"px"}));j=parseInt(c.css("top"))/(b.outerHeight()-c.outerHeight());g=j*(b[0].scrollHeight-b.outerHeight());f&&(g=h,h=g/b[0].scrollHeight*b.outerHeight(),h=Math.min(Math.max(h,0),e),c.css({top:h+"px"}));b.scrollTop(g);q();l()}function r(){s=Math.max(b.outerHeight()/b[0].scrollHeight*b.outerHeight(),A);c.css({height:s+"px"})}function q(){r();clearTimeout(w);j==~~j&&(n=a.allowPageScroll,x!=j&&b.trigger("slimscroll",
0==~~j?"top":"bottom"));x=j;s>=b.outerHeight()?n=!0:(c.stop(!0,!0).fadeIn("fast"),a.railVisible&&e.stop(!0,!0).fadeIn("fast"))}function l(){a.alwaysVisible||(w=setTimeout(function(){if((!a.disableFadeOut||!p)&&!t&&!u)c.fadeOut("slow"),e.fadeOut("slow")},1E3))}var p,t,u,w,y,s,j,x,A=30,n=!1,b=d(this);if(b.parent().hasClass("slimScrollDiv")){var k=b.scrollTop(),c=b.parent().find(".slimScrollBar"),e=b.parent().find(".slimScrollRail");r();m&&("scrollTo"in m?k=parseInt(a.scrollTo):"scrollBy"in m&&(k+=parseInt(a.scrollBy)),
f(k,!1,!0))}else{a.height="auto"==a.height?b.parent().innerHeight():a.height;k=d("<div></div>").addClass(a.wrapperClass).css({position:"relative",overflow:"hidden",width:a.width,height:a.height});b.css({overflow:"hidden",width:a.width,height:a.height});var e=d("<div></div>").addClass(a.railClass).css({width:a.size,height:"100%",position:"absolute",top:0,display:a.alwaysVisible&&a.railVisible?"block":"none","border-radius":a.size,background:a.railColor,opacity:a.railOpacity,zIndex:90}),c=d("<div></div>").addClass(a.barClass).css({background:a.color,
width:a.size,position:"absolute",top:0,opacity:a.opacity,display:a.alwaysVisible?"block":"none","border-radius":a.size,BorderRadius:a.size,MozBorderRadius:a.size,WebkitBorderRadius:a.size,zIndex:99}),z="right"==a.position?{right:a.distance}:{left:a.distance};e.css(z);c.css(z);b.wrap(k);b.parent().append(c);b.parent().append(e);c.draggable({axis:"y",containment:"parent",start:function(){u=!0},stop:function(){u=!1;l()},drag:function(){f(0,d(this).position().top,!1)}});e.hover(function(){q()},function(){l()});
c.hover(function(){t=!0},function(){t=!1});b.hover(function(){p=!0;q();l()},function(){p=!1;l()});b.bind("touchstart",function(a){a.originalEvent.touches.length&&(y=a.originalEvent.touches[0].pageY)});b.bind("touchmove",function(b){b.originalEvent.preventDefault();b.originalEvent.touches.length&&f((y-b.originalEvent.touches[0].pageY)/a.touchScrollStep,!0)});var v=function(a){if(p){a=a||window.event;var b=0;a.wheelDelta&&(b=-a.wheelDelta/120);a.detail&&(b=a.detail/3);f(b,!0);a.preventDefault&&!n&&
a.preventDefault();n||(a.returnValue=!1)}};(function(){window.addEventListener?(this.addEventListener("DOMMouseScroll",v,!1),this.addEventListener("mousewheel",v,!1)):document.attachEvent("onmousewheel",v)})();r();"bottom"==a.start?(c.css({top:b.outerHeight()-c.outerHeight()}),f(0,!0)):"object"==typeof a.start&&(f(d(a.start).position().top,null,!0),a.alwaysVisible||c.hide())}});return this}});jQuery.fn.extend({slimscroll:jQuery.fn.slimScroll})})(jQuery);


/*

 * DC jQuery Drill Down Menu - jQuery drill down ipod menu
 * Copyright (c) 2011 Design Chemical
 *
 * Dual licensed under the MIT and GPL licenses:
 * 	http://www.opensource.org/licenses/mit-license.php
 * 	http://www.gnu.org/licenses/gpl.html
 *
 */

(function($){

	//define the new for the plugin ans how to call it
	$.fn.dcDrilldown = function(options) {

		//set default options
		var defaults = {
			classWrapper	: 'dd-wrapper',
			classMenu		: 'dd-menu',
			classParent		: 'dd-parent',
			classParentLink	: 'dd-parent-a',
			classActive		: 'active',
			classHeader		: 'dd-header',
			eventType		: 'click',
			hoverDelay		: 300,
			speed       	: 'slow',
			saveState		: false,
			showCount		: false,
			classCount		: 'dd-count',
			classIcon		: 'dd-icon',
			linkType		: 'link',
			resetText		: 'Back to top',
			headerTag		: 'h3',
			defaultText		: 'Select a Category',
			includeHdr		: false
		};

		//call in the default otions
		var options = $.extend(defaults, options);

		//act upon the element that is passed into the design
		return this.each(function(options){

			var $dcDrilldownObj = this;
			$($dcDrilldownObj).addClass(defaults.classMenu);
			var $wrapper = '<div class="'+defaults.classWrapper+'" />';
			$($dcDrilldownObj).wrap($wrapper);
			var $dcWrapper = $($dcDrilldownObj).parent();
			var objIndex = $($dcWrapper).index('.'+defaults.classWrapper);
			var idHeader = defaults.classHeader+'-'+objIndex;
			var idWrapper = defaults.classWrapper+'-'+objIndex;
			$($dcWrapper).attr('id',idWrapper);
			var $header = '<div id="'+idHeader+'" class="'+defaults.classHeader+'"></div>';

			setUpDrilldown();

			if(defaults.saveState == true){
				var cookieId = defaults.classWrapper+'-'+objIndex;
				checkCookie(cookieId, $dcDrilldownObj);
			}

			resetDrilldown($dcDrilldownObj, $dcWrapper);

			$('li a',$dcDrilldownObj).click(function(e){

				$link = this;
				$activeLi = $(this).parent('li').stop();
				$siblingsLi = $($activeLi).siblings();

				// Drilldown action
				if($('> ul',$activeLi).length){
					if($($link).hasClass(defaults.classActive)){
						$('ul a',$activeLi).removeClass(defaults.classActive);
						resetDrilldown($dcDrilldownObj, $dcWrapper);
					} else {
						actionDrillDown($activeLi, $dcWrapper, $dcDrilldownObj);
					}
				}

				// Prevent browsing to link if has child links
				if($(this).next('ul').length > 0){
					//e.preventDefault();
				}
			});

			// Set up accordion
			function setUpDrilldown(){

				$arrow = '<span class="'+defaults.classIcon+'"></span>';
				$($dcDrilldownObj).before($header);

				// Get width of menu container & height of list item
				var totalWidth = $($dcDrilldownObj).outerWidth();
				totalWidth += 'px';
				var itemHeight = $('li',$dcDrilldownObj).outerHeight(true);

				// Get height of largest sub menu
				var objUl = $('ul',$dcDrilldownObj);
				var maxItems = findMaxHeight(objUl);

				// Get level of largest sub menu
				var maxUl = $(objUl+'[rel="'+maxItems+'"]');
				var getIndex = findMaxIndex(maxUl);

				// Set menu container height
				if(defaults.linkType == 'link'){
					menuHeight = itemHeight * (maxItems + getIndex);
				} else {
					menuHeight = itemHeight * maxItems;
				}
				
				//$($dcDrilldownObj).css({height: menuHeight+'px'}); //, width: totalWidth});

				// Set sub menu width and offset
				$('li',$dcDrilldownObj).each(function(){
					$(this).css({width: totalWidth});
					$('ul',this).css({width: totalWidth, marginRight: '-'+totalWidth, marginTop: '0'});
					if($('> ul',this).length){
						$(this).addClass(defaults.classParent);
						$('> a',this).addClass(defaults.classParentLink).append($arrow);
						if(defaults.showCount == true){
							var parentLink = $('a:not(.'+defaults.classParentLink+')',this);
							var countParent = parseInt($(parentLink).length);
							getCount = countParent;
							$('> a',this).append(' <span class="'+defaults.classCount+'">('+getCount+')</span>');
						}
					}
				});

				// Add css class
				$('ul',$dcWrapper).each(function(){
					$('li:last',this).addClass('last');
				});
				$('> ul > li:last',$dcWrapper).addClass('last');
				if(defaults.linkType == 'link'){
					$(objUl).css('top',itemHeight+'px');
				}
			}

			// Breadcrumbs
			$('#'+idHeader+' a').live('click',function(e){

				if($(this).hasClass('link-back')){
					linkIndex = $('#'+idWrapper+' .'+defaults.classParentLink+'.active').length;
					linkIndex = linkIndex-2;
					$('a.'+defaults.classActive+':last', $dcDrilldownObj).removeClass(defaults.classActive);
				} else {
					// Get link index
					var linkIndex = parseInt($(this).index('#'+idHeader+' a'));
					if(linkIndex == 0){
						$('a',$dcDrilldownObj).removeClass(defaults.classActive);
					} else {
						// Select equivalent active link
						linkIndex = linkIndex-1;
						$('a.'+defaults.classActive+':gt('+linkIndex+')',$dcDrilldownObj).removeClass(defaults.classActive);
					}
				}
				resetDrilldown($dcDrilldownObj, $dcWrapper);
				e.preventDefault();
			});
		});

		function findMaxHeight(element){
			var maxValue = undefined;
			$(element).each(function(){
				var val = parseInt($('> li',this).length);
				$(this).attr('rel',val);
				if (maxValue === undefined || maxValue < val){
					maxValue = val;
				}
			});
			return maxValue;
		}

		function findMaxIndex(element){
			var maxIndex = undefined;
			$(element).each(function(){
				var val = parseInt($(this).parents('li').length);
				if (maxIndex === undefined || maxIndex < val) {
					maxIndex = val;
				}
			});
			return maxIndex;
		}

		// Retrieve cookie value and set active items
		function checkCookie(cookieId, obj){
			var cookieVal = $.cookie(cookieId);
			if(cookieVal != null){
				// create array from cookie string
				var activeArray = cookieVal.split(',');
				$.each(activeArray, function(index,value){
					var $cookieLi = $('li:eq('+value+')',obj);
					$('> a',$cookieLi).addClass(defaults.classActive);
				});
			}
		}

		// Drill Down
		function actionDrillDown(element, wrapper, obj){
			// Declare header
			var $header = $('.'+defaults.classHeader, wrapper);

			// Get new breadcrumb and header text
			var getNewBreadcrumb = $('h3',$header).html();
			var getNewHeaderText = $('> a',element).html();

			// Add new breadcrumb
			if(defaults.linkType == 'breadcrumb'){
				if(!$('ul',$header).length){
					$($header).prepend('<ul></ul>');
				}
				if(getNewBreadcrumb == defaults.defaultText){
					$('ul',$header).append('<li><a href="#" class="first">'+defaults.resetText+'</a></li>');
				} else {
					$('ul',$header).append('<li><a href="#">'+getNewBreadcrumb+'</a></li>');
				}
			}
			if(defaults.linkType == 'backlink'){
				if(!$('a',$header).length){
					$($header).prepend('<a href="#" class="link-back">'+getNewBreadcrumb+'</a>');
				} else {
					$('.link-back',$header).html(getNewBreadcrumb);
				}
			}
			if(defaults.linkType == 'link'){
				if(!$('a',$header).length){
					$($header).prepend('<ul><li><a href="#" class="first">'+defaults.resetText+'</a></li></ul>');
				}
			}
			// Update header text
			updateHeader($header, getNewHeaderText);

			// declare child link
			var activeLink = $('> a',element);

			// add active class to link
			$(activeLink).addClass(defaults.classActive);
			$('> ul li',element).show();
			$('> ul',element).animate({"margin-right": 0}, defaults.speed);

			// Find all sibling items & hide
			var $siblingsLi = $(element).siblings();
			$($siblingsLi).hide();

			// If using breadcrumbs hide this element
			if(defaults.linkType != 'link'){
				$(activeLink).hide();
			}

			// Write cookie if save state is on
			if(defaults.saveState == true){
				var cookieId = $(wrapper).attr('id');
				createCookie(cookieId, obj);
			}
		}

		// Drill Up
		function actionDrillUp(element, obj, wrapper){
			// Declare header
			var $header = $('.'+defaults.classHeader, wrapper);

			var activeLink = $('> a',element);
			var checklength = $('.'+defaults.classActive, wrapper).length;
			var activeIndex = $(activeLink).index('.'+defaults.classActive, wrapper);

			// Get width of menu for animating right
			var totalWidth = $(obj).outerWidth(true);
			$('ul',element).css('margin-right',-totalWidth+'px');

			// Show all elements
			$(activeLink).addClass(defaults.classActive);
			$('> ul li',element).show();
			$('a',element).show();

			// Get new header text from clicked link
			var getNewHeaderText = $('> a',element).html();
			$('h3',$header).html(getNewHeaderText);

			if(defaults.linkType == 'breadcrumb'){
				var breadcrumbIndex = activeIndex-1;
				$('a:gt('+activeIndex+')',$header).remove();
			}
		}

		function updateHeader(obj, html){
			if(defaults.includeHdr == true){
				if($('h3',obj).length){
					$('h3',obj).html(html);
				} else {
					$(obj).append('<'+defaults.headerTag+'>'+html+'</'+defaults.headerTag+'>');
				}
			}
		}

		// Reset accordion using active links
		function resetDrilldown(obj, wrapper){
			var $header = $('.'+defaults.classHeader, wrapper);
			$('ul',$header).remove();
			$('a',$header).remove();
			$('li',obj).show();
			$('a',obj).show();
			var totalWidth = $(obj).outerWidth(true);
			if(defaults.linkType == "link"){
				if($('a.'+defaults.classActive+':last',obj).parent('li').length){
					var lastActive = $('a.'+defaults.classActive+':last',obj).parent('li');
					$('ul',lastActive).css('margin-right',-totalWidth+'px');
				}else {
				$('ul',obj).css('margin-right',-totalWidth+'px');
				}
			} else {
				$('ul',obj).css('margin-right',-totalWidth+'px');
			}
			updateHeader($header, defaults.defaultText);

			// Write cookie if save state is on
			if(defaults.saveState == true){
				var cookieId = $(wrapper).attr('id');
				createCookie(cookieId, obj);
			}

			$('a.'+defaults.classActive,obj).each(function(i){
				var $activeLi = $(this).parent('li').stop();
				actionDrillDown($activeLi, wrapper, obj);
			});
		}

		// Write cookie
		function createCookie(cookieId, obj){
			var activeIndex = [];
			// Create array of active items index value
			$('a.'+defaults.classActive,obj).each(function(i){
				var $arrayItem = $(this).parent('li');
				var itemIndex = $('li',obj).index($arrayItem);
					activeIndex.push(itemIndex);
				});
			// Store in cookie
			$.cookie(cookieId, activeIndex, { path: '/' });
		}
	};
})(jQuery);


