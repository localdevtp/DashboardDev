(function($, w, undefined) {
  if (w.footable === undefined || w.footable === null) {
    throw new Error('Please check and make sure footable.js is included in the page and is loaded prior to this script.');
  }
  
  var defaults = {
    paging: {
      enabled: true,
      minimumpages: 3,
      maximumpages: 3,
      maximumrows: 10,
      callbacks: {
        init: function(){},
        resize: function(){},
        start: function(){},
        end: function(){}
      }
    }
  };
  
  function Paging() {
    var p = this;
    p.name = 'Footable Paging';
    p.div = '<div class="footable-paging pagination pagination-centered"><ul></ul></div>';
    p.init = function(ft) {
      if(ft.options.paging.enabled === true) {
        $(ft.table).bind({
          
          'footable_initializing': function(e) {
            ft.options.paging.callbacks.init();
          },
          
          'footable_initialized': function(e) {
            // get table
            var $table = $(e.ft.table);
            
			// Disable paging support for < IE9
			if(!$('html').hasClass('lt-ie9')) {
            
				// Change to first page
            	p.changePage(ft, $table, 1);
           
			} else {
				ft.options.paging.callbacks.end();
				$table.triggerHandler('footable-paging-end');
				p.zebraMode(ft, $table);
			}
				
            // 3rd party plugin support
            if(ft.options.sort) { p.supportSortPlugin(ft, $table); }
            
          }, // footable_initialized
          
          'footable_resized' : function(e) {
            ft.options.paging.callbacks.resize();
          } // footable_resized 
          
        });
	  }
    }; // Init
    p.createPages = function(ft, table, page) {
      var $table = $(table);
      var $rows = $table.find('tbody > tr:not(.footable-row-detail)');
      var pages = Math.ceil($rows.length / ft.options.paging.maximumrows);  
      
      if($rows.length <= ft.options.paging.maximumrows) {
        return false;
      }
      
      // create page container
      if($('+ .footable-paging',$table).length > 0){
        $('+ .footable-paging ul',$table).empty();
      } else {
        $table.after(p.div);
      }
      
      // add page(s)
      var ap = [];
      for (var i = pages; i > 0; i--) {
        ap.push('<li><a href="#" data-page="'+i+'">'+i+'</a></li>');
      }
      ap = ap.reverse();
      if(Number(page) === 1) {
        ap = ap.slice(Number(page)-1,Number(page)+ft.options.paging.maximumpages-1);
      }
      else if(Number(page) > 1) {
        var start, end;
        if(Number(page) > Math.floor(ft.options.paging.maximumpages/2)) {
          start = (Number(page)-1)-(Math.floor(ft.options.paging.maximumpages/2));
          end = (Number(page)-1)+(Math.ceil(ft.options.paging.maximumpages/2));
          if((pages - start) <= ft.options.paging.maximumpages) {
            start = (pages - ft.options.paging.maximumpages < 0) ? 0 : pages - ft.options.paging.maximumpages;
          }
        } else {
          start = (((Number(page)-1)-(Math.floor(ft.options.paging.maximumpages/2))) < 0) ? 0 : ((Number(page)-1)-(Math.floor(ft.options.paging.maximumpages/2)));
          end = (((Number(page)-1)+(Math.ceil(ft.options.paging.maximumpages/2))) < pages) ? (Number(page)+(Math.ceil(ft.options.paging.maximumpages/2))) : pages;
        }
        ap = ap.slice(start,end);
      }
      for (var j = ap.length - 1; j >= 0; j--) {
        $('+ .footable-paging ul',$table).prepend(ap[j]);
      }
      // add ... for less pages
      //if(pages > ft.options.paging.maximumpages && Math.ceil(ft.options.paging.maximumpages/2)+1 > (pages - page)) {
      //  $('+ .footable-paging ul',$table).prepend('<li class="less-page"><a>...</a></li>');
      //}
      // add ... for more pages
      if(pages > ft.options.paging.maximumpages && Math.ceil(ft.options.paging.maximumpages/2)-1 < (pages - page)) {
        $('+ .footable-paging ul',$table).append('<li class="more-page"><a>...</a></li>');
      }
      // add prev page if applicable 
      if(page > 1) {
        $('+ .footable-paging ul',$table).prepend('<li class="prev-page"><a href="#" data-page="'+ (Number(page) - 1) +'" ><i class="icon-backward"></i></a></li>');
      } else {
        $('+ .footable-paging ul',$table).prepend('<li class="prev-page"><a href="#" data-page="1" ><i class="icon-backward"></i></a></li>');
      }
      // add next page if applicable 
      if(page < pages) {
        $('+ .footable-paging ul',$table).append('<li class="next-page"><a href="#" data-page="'+ (Number(page) + 1) +'" ><i class="icon-forward"></i></a></li>');
      } else {
        $('+ .footable-paging ul',$table).append('<li class="next-page"><a href="#" data-page="'+ pages +'" ><i class="icon-forward"></i></a></li>');
      }
      // add first and last page
      $('+ .footable-paging ul',$table).prepend('<li class="first-page"><a href="#" data-page="1" ><i class="icon-first"></i> <span class="hidden-phone">Page 1</span></a></li>');
      $('+ .footable-paging ul',$table).append('<li class="last-page"><a href="#" data-page="'+ pages +'" ><span class="hidden-phone">Page '+ pages +'</span> <i class="icon-last"></i></a></li>');
      
      // add current page
      $('+ .footable-paging li',$table).not('.prev-page, .next-page, .first-page, .last-page').find('a[data-page="'+page+'"]').parent().addClass('current');
      // on page click
      $('+ .footable-paging a',$table).on('click',function(e){
        var page = $(this).attr('data-page');
        if(page > 0){
          p.changePage(ft, table, page);
        }
        e.preventDefault();
      });
    }; // createPages
    p.changePage = function(ft, table, page){
      var $table = $(table);  
      ft.options.paging.callbacks.start();
      $table.triggerHandler('footable-paging-start');   
      p.createPages(ft, table, page);
      //$table.find('tbody > tr.footable-row-detail').css({ display:'none' });
      $table.find('tbody > tr:not(.footable-row-detail)').removeClass('hidden');
      $table.find('tbody > tr:not(.footable-row-detail):lt('+ (ft.options.paging.maximumrows * (page-1)) +')').addClass('hidden');
      $table.find('tbody > tr:not(.footable-row-detail):gt('+ (ft.options.paging.maximumrows * page - 1) +')').addClass('hidden');
      $table.find('tbody > tr.footable-detail-show:not(.hidden) + .footable-row-detail').addClass('open');
      p.zebraMode(ft, table);
      ft.options.paging.callbacks.end();
      $table.triggerHandler('footable-paging-end');
    }; // changePage
    p.supportSortPlugin = function(ft, table){
      var $table = $(table);
      $table.find('.footable-sortable').on('click',function(){
        var currentPage = $('+ .footable-paging li.current a',$table).attr('data-page');      
        if(currentPage === undefined) {
          p.zebraMode(ft, table);
        } else {
          p.changePage(ft, table, currentPage);
        }
      });
    }; // supportSortPlugin
    p.zebraMode = function(ft, table){
      var $table = $(table);
      $table.find('tbody > tr.footable-detail-show').removeClass('footable-detail-show');
      $table.find('tbody > tr.footable-row-detail').remove();
      $table.find('tbody > tr:not(.footable-row-detail)').removeClass('even');
      $table.find('tbody > tr:not(.footable-row-detail):nth-of-type(even)').addClass('even'); 
    }; // zebraMode
  }
  
  w.footable.plugins.register(new Paging(), defaults);
  
})(jQuery, window);