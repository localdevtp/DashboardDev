$(document).ready(function(){

	// Fix Button
	$(".purify-vehicle tbody tr td:first-child a").addClass("btn btn-small btn-success btn-purify"); 
	$(".purify-vehicle tbody tr td:first-child a").append("<i class='icon-spinner-3'></i>"); 
	$(".purify-vehicle tbody tr td:first-child a").attr("data-toggle", "tooltip");
	$(".purify-vehicle tbody tr td:first-child a").attr("data-original-title", "Fix");
	
	// Request Button
	$(".purify-vehicle tbody tr td:nth-child(2) a").addClass("btn btn-small btn-info btn-custom"); 
	$(".purify-vehicle tbody tr td:nth-child(2) a").append("<i class='icon-plus'></i>"); 
 	$(".purify-vehicle tbody tr td:nth-child(2) a").attr("data-toggle", "tooltip");
	$(".purify-vehicle tbody tr td:nth-child(2) a").attr("data-original-title", "Request");
});