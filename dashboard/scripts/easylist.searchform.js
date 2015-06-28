
$(document).ready(function() {
	LoadMakesModels();
 });
 
 
function evalParams(node, attr) {
  var params = $(node).attr(attr).replace('{{', '{').replace('}}', '}');
  if (params.replace(/\s/g, "") == "") {
    return '';
  } else {
    return eval("(" + params + ")");
  }
}

function LoadMakesModels()
{
	if ($('[data-car-search]').length) {
                $('[data-car-search]').each(function() {
                    var cardata = evalParams(this, 'data-car-search');
                    var html = '';
                    var len = cardata.length;
                    var $make = $('#Makes');
                    var $model = $('#Models');

                    for (var i = 0; i < len; i++) {
                        html += '<option value="' + cardata[i].Make + '">' + cardata[i].Make + ' (' + cardata[i].Count + ')</option>';
                    }
                    $make.append(html).change(function() {
                        var parentValue = $make.val();
                        var makeFound = false;
                        for (var i = 0; i < len; i++) {
                            if (cardata[i].Make == parentValue) {
                                makeFound = true;
                                var modelLen = cardata[i].Models.length;
                                var modelsHtml = '';
                                for (var j = 0; j < modelLen; j++) {
                                    modelsHtml += '<option value="' + cardata[i].Models[j].Model + '">' + cardata[i].Models[j].Model + ' (' + cardata[i].Models[j].Count + ')</option>';
                                }
                                $model.html('<option value="">All ' + cardata[i].Make + ' Models</option>' + modelsHtml);
                            }
                        }
                        if (!makeFound) {
                            $model.html('<option value="">(Select a Make)</option>');
                        }
                    });
                });
            }
}

// var intervalJquery;
// intervalJquery = setInterval(function() {
    // if (typeof window.jQuery !== 'undefined') {
        // clearInterval(intervalJquery);
        // $(document).ready(function() {
		
            // if ($('[data-car-search]').length) {
                // $('[data-car-search]').each(function() {
                    // var cardata = evalParams(this, 'data-car-search');
                    // var html = '';
                    // var len = cardata.length;
                    // var $make = $('#Makes');
                    // var $model = $('#Models');

                    // for (var i = 0; i < len; i++) {
                        // html += '<option value="' + cardata[i].Make + '">' + cardata[i].Make + ' (' + cardata[i].Count + ')</option>';
                    // }
                    // $make.append(html).change(function() {
                        // var parentValue = $make.val();
                        // var makeFound = false;
                        // for (var i = 0; i < len; i++) {
                            // if (cardata[i].Make == parentValue) {
                                // makeFound = true;
                                // var modelLen = cardata[i].Models.length;
                                // var modelsHtml = '';
                                // for (var j = 0; j < modelLen; j++) {
                                    // modelsHtml += '<option value="' + cardata[i].Models[j].Model + '">' + cardata[i].Models[j].Model + ' (' + cardata[i].Models[j].Count + ')</option>';
                                // }
                                // $model.html('<option value="">All ' + cardata[i].Make + ' Models</option>' + modelsHtml);
                            // }
                        // }
                        // if (!makeFound) {
                            // $model.html('<option value="">All Models</option>');
                        // }
                    // });
                // });
            // }
			
		// });
    // }
// }, 100);
// function evalParams(node, attr) {
  // var params = $(node).attr(attr).replace('{{', '{').replace('}}', '}');
  // if (params.replace(/\s/g, "") == "") {
    // return '';
  // } else {
    // return eval("(" + params + ")");
  // }
// }