$(document).ready(function () {
	InitialiseImageUpload();
});  

function InitialiseImageUpload(){
	
	$('#upload-photo').on('click',function(e){
		
		// Do something before open?
		
		// Check if has image pending deletion, prompt to save changes before continue upload
		if($('#delete-photos').val() != undefined && $('#delete-photos').val() != '') {
			alertModal('Some photos had been deleted. Please save changes before continue upload.','Save changes','warning');return false;
		}
		
		// Open the popup to upload images
		$.magnificPopup.open({
			items: { 
				src: "/listings/listing-image-uploader.aspx?listing=" + GetListingID() 
			},
			type: 'iframe',
			overflowY: 'scroll',
			alignTop: true,
			mainClass: 'mfp-full-height',
			callbacks: {
				close: function(){
					$('#ReloadImage').trigger('click');
				}
			}
		});
		
		e.preventDefault();
		
	});
	
	$("#ImageUploadDialog").on("hidden", function (event, ui) {
		$('#ReloadImage').trigger('click');
	});
}

function GetListingID()
{
	var ListingID = "";
	
	// To use for My Photo Page
	ListingID = $('#txtMyPhoto').val();
	
	// To use for listing editing page
	if (ListingID == undefined || ListingID == "")
	{
		ListingID = getURLParam('listing');
	}
	
	return ListingID;
}

function getURLParam(name) {
	name = name.replace(/[\[]/, "\\\[").replace(/[\]]/, "\\\]");
	var regexS = "[\\?&]" + name + "=([^&#]*)";
	var regex = new RegExp(regexS);
	var results = regex.exec(window.location.href);
	if (results == null)
		return "";
	else
		return results[1];
}

function getCookie(c_name)
{
	var c_value = document.cookie;
	var c_start = c_value.indexOf(" " + c_name + "=");
	if (c_start == -1)
	{
		c_start = c_value.indexOf(c_name + "=");
	}
	if (c_start == -1)
	{
		c_value = null;
	}
	else
	{
		c_start = c_value.indexOf("=", c_start) + 1;
		var c_end = c_value.indexOf(";", c_start);
		if (c_end == -1)
		{
			c_end = c_value.length;
		}
		c_value = unescape(c_value.substring(c_start,c_end));
	}
	return c_value;
}

