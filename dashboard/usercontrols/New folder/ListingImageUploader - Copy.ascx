﻿<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ListingImageUploader.ascx.cs" Inherits="EasyList.Web.ListingImageUploader.ListingImageUploader" %>
<head>
<!--==================================================================== QUERY UPLOADER ======================================================================-->
<!-- Force latest IE rendering engine or ChromeFrame if installed -->
<!--[if IE]><meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"><![endif]-->
<meta charset="utf-8">
<title>jQuery File Upload Demo</title>
<meta name="description" content="File Upload widget with multiple file selection, drag&amp;drop support, progress bar and preview images for jQuery. Supports cross-domain, chunked and resumable file uploads. Works with any server-side platform (Google App Engine, PHP, Python, Ruby on Rails, Java, etc.) that supports standard HTML form file uploads.">
<meta name="viewport" content="width=device-width">

<link href="/Scripts/jquery-ui-1.10.0.custom/css/smoothness/jquery-ui-1.10.0.custom.css" rel="stylesheet" type="text/css" />
<script src="/Scripts/jquery-1.8.3.js" type="text/javascript"></script>
<script src="/Scripts/jquery-ui-1.10.0.custom/js/jquery-ui-1.10.0.custom.js" type="text/javascript"></script>

<!---------------------------------------------------------------------- Blueimp UPLOADER ---------------------------------------------------------------------->
<!-- Bootstrap CSS Toolkit styles -->
<!--<link rel="stylesheet" href="http://blueimp.github.com/cdn/css/bootstrap.min.css">-->
<link href="/BlueImpUploader/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
<!-- Generic page styles --> 
<link rel="stylesheet" href="/BlueImpUploader/css/style.css" />

<!-- Bootstrap styles for responsive website layout, supporting different screen sizes -->
<!--<link rel="stylesheet" href="http://blueimp.github.com/cdn/css/bootstrap-responsive.min.css">-->
<link href="/BlueImpUploader/css/bootstrap-responsive.min.css" rel="stylesheet" type="text/css" />

<!-- Bootstrap CSS fixes for IE6 -->
<!--[if lt IE 7]><link rel="stylesheet" href="/BlueImpUploader/css/bootstrap-ie6.min.css"><![endif]-->

<!-- Bootstrap Image Gallery styles -->
<!--<link rel="stylesheet" href="http://blueimp.github.com/Bootstrap-Image-Gallery/css/bootstrap-image-gallery.min.css">-->
<link href="/BlueImpUploader/css/bootstrap-image-gallery.min.css" rel="stylesheet" type="text/css" />

<!-- CSS to style the file input field as button and adjust the Bootstrap progress bars -->
<link rel="stylesheet" href="/BlueImpUploader/css/jquery.fileupload-ui.css">
<!-- CSS adjustments for browsers with JavaScript disabled -->
<noscript><link rel="stylesheet" href="/BlueImpUploader/css/jquery.fileupload-ui-noscript.css"></noscript>
<!-- Shim to make HTML5 elements usable in older Internet Explorer versions -->
<!--[if lt IE 9]><script src="/BlueImpUploader/js/html5.js"></script><![endif]-->

<!---------------------------------------------------------------------- Blueimp UPLOADER ---------------------------------------------------------------------->

<!--==================================================================== QUERY UPLOADER ======================================================================-->
</head>

<body>
<!--==================================================================== QUERY UPLOADER ======================================================================-->
<div class="container1">
<%--    <div class="page-header">
        <h1>Upload images</h1>
    </div>--%>
        <!---------------------------------------------------------------------- Blueimp UPLOADER ---------------------------------------------------------------------->
    <div id="ImageUploadDlg" title="Image Upload dialog" style="">
        <!-- The file upload form used as target for the file upload widget -->
        <!--<form id="fileupload" action="//jquery-file-upload.appspot.com/" method="POST" enctype="multipart/form-data">-->
        <form id="fileupload" action="ListingImageHandler.ashx" method="POST" enctype="multipart/form-data">
            <!-- Redirect browsers with JavaScript disabled to the origin page -->
            <%--<noscript><input type="hidden" name="redirect" value="http://blueimp.github.com/jQuery-File-Upload/"></noscript>--%>
            <!-- The fileupload-buttonbar contains buttons to add/delete files and start/cancel the upload -->
            <div class="row fileupload-buttonbar">
                <div class="span7">
                    <!-- The fileinput-button span is used to style the file input field as button -->
                    <span class="btn btn-success fileinput-button">
                        <i class="icon-plus icon-white"></i>
                        <span>Add files...</span>
                        <input type="file" name="files[]" multiple>
                    </span>
                    <button type="submit" class="btn btn-primary start">
                        <i class="icon-upload icon-white"></i>
                        <span>Start upload</span>
                    </button>
                    <button type="reset" class="btn btn-warning cancel">
                        <i class="icon-ban-circle icon-white"></i>
                        <span>Cancel upload</span>
                    </button>
                   <!-- <button type="button" class="btn btn-danger delete">
                        <i class="icon-trash icon-white"></i>
                        <span>Delete</span>
                    </button>
                    <input type="checkbox" class="toggle">-->
                </div>
                <!-- The global progress information -->
                <div class="span5 fileupload-progress fade">
                    <!-- The global progress bar -->
                    <div class="progress progress-success progress-striped active" role="progressbar" aria-valuemin="0" aria-valuemax="100">
                        <div class="bar" style="width:0%;"></div>
                    </div>
                    <!-- The extended global progress information -->
                    <div class="progress-extended">&nbsp;</div>
                </div>
            </div>
            <!-- The loading indicator is shown during file processing -->
            <div class="fileupload-loading"></div>
            <br>
            <!-- The table listing the files available for upload/download -->
            <table role="presentation" class="table table-striped"><tbody class="files" data-toggle="modal-gallery" data-target="#modal-gallery"></tbody></table>
        </form>
        <br>
    </div>
</div>
<!-- modal-gallery is the modal dialog used for the image gallery -->
<div id="modal-gallery" class="modal modal-gallery hide fade" data-filter=":odd" tabindex="-1">
    <div class="modal-header">
        <a class="close" data-dismiss="modal">&times;</a>
        <h3 class="modal-title"></h3>
    </div>
    <div class="modal-body"><div class="modal-image"></div></div>
    <div class="modal-footer">
        <a class="btn modal-download" target="_blank">
            <i class="icon-download"></i>
            <span>Download</span>
        </a>
        <a class="btn btn-success modal-play modal-slideshow" data-slideshow="5000">
            <i class="icon-play icon-white"></i>
            <span>Slideshow</span>
        </a>
        <a class="btn btn-info modal-prev">
            <i class="icon-arrow-left icon-white"></i>
            <span>Previous</span>
        </a>
        <a class="btn btn-primary modal-next">
            <span>Next</span>
            <i class="icon-arrow-right icon-white"></i>
        </a>
    </div>
</div>

<!---------------------------------------------------------------------- Blueimp UPLOADER ---------------------------------------------------------------------->
<!-- The template to display files available for upload -->
<script id="template-upload" type="text/x-tmpl">
{% for (var i=0, file; file=o.files[i]; i++) { %}
    <tr class="template-upload fade">
        <td class="preview"><span class="fade"></span></td>
        <td class="name"><span>{%=file.name%}</span></td>
        <td class="size"><span>{%=o.formatFileSize(file.size)%}</span></td>
        {% if (file.error) { %}
            <td class="error" colspan="2"><span class="label label-important">Error</span> {%=file.error%}</td>
        {% } else if (o.files.valid && !i) { %}
            <td>
                <div class="progress progress-success progress-striped active" role="progressbar" aria-valuemin="0" aria-valuemax="100" aria-valuenow="0"><div class="bar" style="width:0%;"></div></div>
            </td>
            <td>{% if (!o.options.autoUpload) { %}
                <button class="btn btn-primary start">
                    <i class="icon-upload icon-white"></i>
                    <span>Start</span>
                </button>
            {% } %}</td>
        {% } else { %}
            <td colspan="2"></td>
        {% } %}
        <td>{% if (!i) { %}
            <button class="btn btn-warning cancel">
                <i class="icon-ban-circle icon-white"></i>
                <span>Cancel</span>
            </button>
        {% } %}</td>
    </tr>
{% } %}
</script>
<!-- The template to display files available for download -->
<script id="template-download" type="text/x-tmpl">
{% for (var i=0, file; file=o.files[i]; i++) { %}
    <tr class="template-download fade">
        {% if (file.error) { %}
            <td></td>
            <td class="name"><span>{%=file.name%}</span></td>
            <td class="size"><span>{%=o.formatFileSize(file.size)%}</span></td>
            <td class="error" colspan="2"><span class="label label-important">Error</span> {%=file.error%}</td>
        {% } else { %}
            <td class="preview">{% if (file.thumbnail_url) { %}
                <a href="{%=file.url%}" title="{%=file.name%}" data-gallery="gallery" download="{%=file.name%}"><img src="{%=file.thumbnail_url%}"></a>
            {% } %}</td>
            <td class="name">
                <a href="{%=file.url%}" title="{%=file.name%}" data-gallery="{%=file.thumbnail_url&&'gallery'%}" download="{%=file.name%}">{%=file.name%}</a>
            </td>
            <td class="size"><span>{%=o.formatFileSize(file.size)%}</span></td>
            <td colspan="2"></td>
        {% } %}
        <!--<td>
            <button class="btn btn-danger delete" data-type="{%=file.delete_type%}" data-url="{%=file.delete_url%}"{% if (file.delete_with_credentials) { %} data-xhr-fields='{"withCredentials":true}'{% } %}>
                <i class="icon-trash icon-white"></i>
                <span>Delete</span>
            </button>
            <input type="checkbox" name="delete" value="1" class="toggle">
        </td>-->
    </tr>
{% } %}
</script>
<%--<script src="//ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>--%>
<!-- The jQuery UI widget factory, can be omitted if jQuery UI is already included -->
<script src="/BlueImpUploader/js/vendor/jquery.ui.widget.js"></script>

<!-- The Templates plugin is included to render the upload/download listings -->
<script src="/BlueImpUploader/js/tmpl.min.js" type="text/javascript"></script>
<!-- The Load Image plugin is included for the preview images and image resizing functionality -->
<script src="/BlueImpUploader/js/load-image.min.js" type="text/javascript"></script>
<!-- The Canvas to Blob plugin is included for image resizing functionality -->
<script src="/BlueImpUploader/js/canvas-to-blob.min.js" type="text/javascript"></script>

<!-- Bootstrap JS and Bootstrap Image Gallery are not required, but included for the demo -->
<script src="/BlueImpUploader/js/bootstrap.min.js" type="text/javascript"></script>
<script src="/BlueImpUploader/js/bootstrap-image-gallery.min.js" type="text/javascript"></script>

<!-- The Iframe Transport is required for browsers without support for XHR file uploads -->
<script src="/BlueImpUploader/js/jquery.iframe-transport.js" type="text/javascript"></script>
<!-- The basic File Upload plugin -->
<script src="/BlueImpUploader/js/jquery.fileupload.js" type="text/javascript"></script>
<!-- The File Upload file processing plugin -->
<script src="/BlueImpUploader/js/jquery.fileupload-fp.js" type="text/javascript"></script>
<!-- The File Upload user interface plugin -->
<script src="/BlueImpUploader/js/jquery.fileupload-ui.js" type="text/javascript"></script>
<!-- The main application script -->
<script src="/BlueImpUploader/js/main.js" type="text/javascript"></script>
<!-- The XDomainRequest Transport is included for cross-domain file deletion for IE8+ -->
<!--[if gte IE 8]><script src="js/cors/jquery.xdr-transport.js"></script><![endif]-->

<!---------------------------------------------------------------------- Blueimp UPLOADER ---------------------------------------------------------------------->
<!--==================================================================== QUERY UPLOADER ======================================================================-->

</body>
