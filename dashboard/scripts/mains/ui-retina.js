//Detect high res displays (Retina, HiDPI, etc...)
Modernizr.addTest('highresdisplay', function(){
  if (window.matchMedia) {
    var mq = window.matchMedia("only screen and (-moz-min-device-pixel-ratio: 1.3), only screen and (-o-min-device-pixel-ratio: 2.6/2), only screen and (-webkit-min-device-pixel-ratio: 1.3), only screen  and (min-device-pixel-ratio: 1.3), only screen and (min-resolution: 1.3dppx)");
    if(mq && mq.matches) {
      return true;
    }
  }
});

$(function(){
    if(Modernizr.highresdisplay) {
      // Replace image with hiRes images
      var img = $("img.retina").get();
      for(var i = 0; i < img.length; i++) {
        var src = img[i].src;
        src = src.replace(".png", "-2x.png");
        img[i].src = src;
      }
		
	  // Custom hiRes images
	  var imgcustom = $("[data-retina]").get();
      for(var i = 0; i < imgcustom.length; i++) {
          imgcustom[i].attr('data-retina-original-src', imgcustom[i].src);
		  imgcustom[i].src = imgcustom[i].attr('data-retina');
      }
    }
});