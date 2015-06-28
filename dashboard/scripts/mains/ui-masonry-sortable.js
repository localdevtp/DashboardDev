$(function(){

  var t = $('.masonry-sortable');

  t.masonry({
    itemSelector:  '.masonry-item',
    isResizable:  true,
    gutterWidth: 20
  });

  t.sortable({
    distance: 12,
    forcePlaceholderSize: true,
    items: '.masonry-item',
    placeholder: 'card-sortable-placeholder masonry-item',
    tolerance: 'pointer',

    start:  function(event, ui) {
      ui.item.addClass('dragging').removeClass('masonry-item');
      ui.item.parent().masonry('reload');
    },
    change: function(event, ui) {
      ui.item.parent().masonry('reload');
    },
    stop:   function(event, ui) {
      ui.item.removeClass('dragging').addClass('masonry-item');
      ui.item.parent().masonry('reload');
    }
   });

});