<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="FeedOutTemplateControl.ascx.cs" Inherits="TeamUniquemail.Controls.FeedOutTemplateControl" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajx" %>
<%@ Register Assembly="TeamUniquemail" Namespace="TeamUniquemail.Controls" TagPrefix="cc1" %>

<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>

<style type="text/css">
.DisabledTextBox {
  background-color: #F0F0F0;
  color: #303030;
}

.validation
{
    color:Red;
    display:block;
}

.linkbutton
{
    display:inline-block;
}

.web_dialog_overlay
{
   position: fixed;
   top: 0;
   right: 0;
   bottom: 0;
   left: 0;
   height: 100%;
   width: 100%;
   margin: 0;
   padding: 0;
   background: #000000;
   opacity: .15;
   filter: alpha(opacity=15);
   -moz-opacity: .15;
   z-index: 1001;
   display: none;
}

.control-error
{
    color:Red;
}

.web_dialog
{
   display: none;
   position: fixed;
   width: 600px;
   height: 400px;
   top: 30%;
   left: 50%;
   margin-left: -190px;
   margin-top: -100px;
   background-color: #ffffff;
   border: 2px solid #336699;
   padding: 0px;
   z-index: 1002;
   padding:20px;
}

.web_treedialog
{
   display: none;
   position: fixed;
   width: 500px;
   height: 600px;
   top: 30%;
   left: 30%;
   margin-left: -190px;
   margin-top: -200px;
   background-color: #ffffff;
   border: 2px solid #336699;
   padding: 0px;
   z-index: 1002;
}


.web_trialdialog
{
   display: none;
   position: fixed;
   width: 900px;
   height: 700px;
   top: 30%;
   left: 30%;
   margin-left: -190px;
   margin-top: -245px;
   background-color: #ffffff;
   border: 2px solid #336699;
   padding: 0px;
   z-index: 1002;
}

.web_trialdialog{
	top:32% !important;
}

.web_trialdialog input[type=file] {
	line-height: 12px;
	background: #FFFFFF!important;
	color: #333333;
	text-shadow: 0 1px 0 #fff9f2;
	border-radius: 8px;
	border: 1px solid #FF9206;
	padding-top: 5px;
	padding-left: 5px;
}

.web_trialdialog .controls{
	margin-left:0px !important;
}

.btn.disabled, .btn[disabled]{
	height:25px !important;
	padding-bottom: 2px !important;
	padding-top: 2px !important;
	font-size: 11.9px !important;
}

.table-row {
    display: table-row;
}

.table-cell {
    display: table-cell;
    width:20%;
    text-align:center;
}

.trial-report th {
	background: #F28B00;
	color: #fff;
	padding: 10px;
	border-right: 1px solid #eee;
}

.mapping-table {
	border-collapse:collapse;
	border:1px solid #000;
}

.mapping-table td{
	border:1px solid #000;
}

.web_dialog textarea{
	width:99%;
}

.FakeFileUploadDiv {
	position: absolute;
	opacity: 1;
	z-index: 99;
	margin-left: 267px;
	width: 300px;
	margin-top: 18px;
}


.editexpress input{
	margin-top:-5px;
	margin-right:3px;
}

.express_top{
	float:left;
	text-align: left;
	width:100%;
	padding-top:5px !important;
	height:295px;
	background:white;
}

.fields_div{
	float:left;
	width:30%;
	margin-left:20px;
}

.expression_div{
	float:left;
	width:65% ;
}

.express_bottom{
	text-align: left;
	/*width:100%;*/
	margin-top:302px;
	background:#FFEED5;
	border-radius:7px;
	padding:5px 7px;
}

.web_dialog textarea{
	margin-top:0;
}

.web_dialog .control-error {
    word-wrap: break-word;
    display: inline-block;
    width: 89%;
    vertical-align: top;
}

.web_trialdialog input[type=submit][disabled=disabled] {
	padding: 0px;
	width: 30px;
	font-size: 12px;
}

@-moz-document url-prefix() {
   .FakeFileUploadDiv input{ 
  	 color:white !important;
 	 width:89px !important;
	 height:46px !important;
	 margin-top:3px !important;    
   }
   
    .FakeFileUploadDiv {
	margin-left: 0 !important;
	margin-top: 15px !important;
	opacity: 1;
	position: absolute;
	width: 300px;
	z-index: 99;
	}
}

@media screen and (-webkit-min-device-pixel-ratio:0) {  
/* CSS Statements that only apply on webkit-based browsers (Chrome, Safari, etc.) */  
 .FakeFileUploadDiv {
	position: absolute;
	opacity: 1;
	-ms-filter: "progid:DXImageTransform.Microsoft.Alpha(Opacity=50)";
	filter: alpha(opacity=50);
	z-index: 99;
	margin-left: 0px !important;
	width: 294px !important;
	margin-top: 17px !important;
  }
}

.web_trialdialog .controls{
	margin-left:0px !important;
}

.table-cell {
	display: table-cell;
	width: 30%;
	text-align: center;
}

.file-up input{
	font-size:16px;
	height:43px;
}

</style>

<cc1:MessageControl ID="messageCtrl" runat="server" />

<ajx:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server" AsyncPostBackTimeout="300" ScriptMode="Release" CombineScripts="true" ></ajx:ToolkitScriptManager>
<asp:Panel ID="pnlBody" runat="server">
    <fieldset>
            <div class="form-left">
                <asp:Panel ID="pnlCatalogue" runat="server" class="control-group" GroupingText="Default File Format">
                    <div class="control-group">   
                        <asp:Label ID="lblDefault" runat="server" Text="Default File Format Template: " class="control-label"></asp:Label>
                        <div class="controls"><asp:DropDownList ID="ddlName" runat="server" OnSelectedIndexChanged="ddlName_SelectedIndexChanged" AutoPostBack="true" class="value" /></div>
                    </div>
                    <div class="control-group">

                        <asp:Label ID="lblName" runat="server" Text="File Format Template Name: " AssociatedControlID="tbName" 
                        class="control-label"></asp:Label>
                        <div class="controls"><asp:TextBox ID="tbName" runat="server" MaxLength="20" class="value"></asp:TextBox></div>
                        <asp:RequiredFieldValidator ID="reqName" runat="server" ControlToValidate="tbName" Display="Dynamic" ErrorMessage="Template Name is a required field." ForeColor="Red" ValidationGroup="UponSave"></asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator ID="regName" runat="server" ControlToValidate="tbName" Display="Dynamic" ErrorMessage="Invalid Template Name, only alphanumerics and space are allowed." ForeColor="Red" ValidationExpression="^[0-9a-zA-Z ]+$" ValidationGroup="UponSave"></asp:RegularExpressionValidator>
                        <asp:CustomValidator id="customeName" runat="server" OnServerValidate="NameValidate" Display="Dynamic" ControlToValidate="tbName" ErrorMessage="Template name is in used." ForeColor="Red" ValidationGroup="UponSave"></asp:CustomValidator>
                    </div>
                    <asp:HiddenField id="hFeedOutType" runat="server"/>
                </asp:Panel>
                        
                <asp:UpdatePanel ID="pnlCategory" runat="server" class="control-group" UpdateMode="Conditional">
                <ContentTemplate>
                    <fieldset>
                    <legend>File Format Category</legend>
                    <div class="control-group">
                        <div class="control-label">  
                            <asp:Label ID="lblCategories" runat="server" Text="Default Categories are: "></asp:Label>
                            <asp:LinkButton ID="lbAddCategory" runat="server" Text="[Reset]" OnClientClick="openCategoryTreeEditor(this); return false;" CssClass="linkbutton"></asp:LinkButton>
                        </div>
                        <div class="controls"><asp:BulletedList ID="blCategories" runat="server" class="category-list"></asp:BulletedList></div>   
                        <asp:CustomValidator id="customCategory" runat="server" OnServerValidate="CategoryValidate" Display="Dynamic" ErrorMessage="You must select at least one category." ForeColor="Red" ValidationGroup="UponSave"></asp:CustomValidator>                     
                    </div>
                    </fieldset>
                    <asp:HiddenField ID="hCategories" runat="server"/>                                        
                </ContentTemplate>
                </asp:UpdatePanel>
                    
                <asp:UpdatePanel ID="pnlFileInfo" runat="server" class="control-group" UpdateMode="Conditional">
                <ContentTemplate>
                    <fieldset>
                    <legend>File Information</legend>
                    <div class="control-group">
                        <asp:Label ID="lblOutputFormat" runat="server" Text="File Format: " AssociatedControlID="ddlOutputFormat"
                        class="control-label"></asp:Label>
                        <div class="controls"><asp:DropDownList ID="ddlOutputFormat" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlOutputFormat_SelectedIndexChanged" /></div>
                    </div>
                     <div class="control-group">
                    <asp:Label ID="lblFirstRowHasColumnNames" runat="server" Text="First Row Has Column Name: " AssociatedControlID="cbFirstRowHasColumnNames"
                        class="control-label"></asp:Label>
                        <div class="controls"><label class="checkbox"><asp:CheckBox ID="cbFirstRowHasColumnNames" runat="server" /></label></div>
                    </div>
                    <div class="control-group">
                    <asp:Label ID="lblTemplateDescription" runat="server" Text="Template Description: " AssociatedControlID="tbTemplateDescription"
                        class="control-label"></asp:Label>
                        <div class="controls"><asp:TextBox ID="tbTemplateDescription" runat="server" MaxLength="50" class="value" /></div>
                    </div>
                    <div class="control-group">
                    <asp:Label ID="lblKeepFormmat" runat="server" Text="Keep Format: " AssociatedControlID="cbKeepFormat"
                        class="control-label"></asp:Label>
                        <div class="controls"><label class="checkbox"><asp:CheckBox ID="cbKeepFormat" runat="server" /></label></div>
                    </div>
                    <div class="control-group">
                        <asp:Label ID="lblFileNameExpressionString" runat="server" Text="File Name Expression: " AssociatedControlID="linkFileNameExpressionString"
                        class="control-label"></asp:Label>
                        <asp:HyperLink ID="linkFileNameExpressionString" runat="server" NavigateUrl="javascript:void(0)" data-value="FileName" data-label="File Name" onclick="openExpressionStringEditor(this); return false;" class="expressionstringopener btn btn-small btn-primary" />
                        <asp:TextBox ID="tbFileNameExpressionString" runat="server" style="display:none" data-value="expressionstring" />
                    </div>
                    <div class="control-group">
                        <asp:Label ID="lblImageNameExpressionString" runat="server" Text="Image Name Expression: " AssociatedControlID="linkImageNameExpressionString"
                        class="control-label"></asp:Label>
                        <asp:HyperLink ID="linkImageNameExpressionString" runat="server" NavigateUrl="javascript:void(0)" data-value="ImageName" data-label="Image Name" onclick="openExpressionStringEditor(this); return false;" class="expressionstringopener btn btn-small btn-primary" />
                        <asp:TextBox ID="tbImageNameExpressionString" runat="server" style="display:none" data-value="expressionstring" />
                    </div>
                    </fieldset>
                </ContentTemplate>
                </asp:UpdatePanel>

                <asp:UpdatePanel ID="pnlTemplateItems" runat="server" class="control-group" UpdateMode="Conditional">
                <ContentTemplate>
                    <asp:Panel ID="pnlGeneralData" runat="server" GroupingText="General Data" />
                        
                    <asp:Panel ID="pnlPricing" runat="server" GroupingText="Pricing Information" />

                    <asp:Panel ID="pnlVehicle" runat="server" GroupingText="Vehicle Type" />
                        
                    <asp:Panel ID="pnlVehicleIdentification" runat="server" GroupingText="Vehicle Identification" />
                        
                    <asp:Panel ID="pnlVehicleBasic" runat="server" GroupingText="Basic Vehicle Data" />
                                             
                    <asp:Panel ID="pnlAttributes" runat="server" GroupingText="Additional Information" />
                </ContentTemplate>
                    
                </asp:UpdatePanel>
        </div>
    </fieldset>
    <div class="form-actions center">
    <asp:Button ID="btnSave" runat="server" Text="Save" OnClick="btnSave_Click" class="btn btn-large btn-success" ValidationGroup="UponSave" UseSubmitBehavior="false" />
    <asp:Button ID="btnExportFile" runat="server" Text="Export Sample File" OnClick="btnExportFile_Click" class="btn btn-large btn-primary" ValidationGroup="UponSave" UseSubmitBehavior="false"/>
    <asp:Button ID="btnDelete" runat="server" Text="Delete" OnClick="btnDelete_Click" class="aspNetDisabled btn btn-large" OnClientClick="if (!confirm('Are you sure you want to delete this file format template?')) return false;"/>
    </div>
</asp:Panel>

<div id="overlay" class="web_dialog_overlay"></div>

<div id="categoryTreeDialog" class="web_treedialog">
    <asp:UpdateProgress ID="progressTree" runat="server" AssociatedUpdatePanelID="pnlTreeCategory" >
        <ProgressTemplate>
        <asp:Label ID="lblLoadingTree" runat="server" Text="Loading..." ForeColor="Blue" ViewStateMode="Disabled"></asp:Label>
        </ProgressTemplate>
    </asp:UpdateProgress>
    <asp:UpdatePanel ID="pnlTreeCategory" runat="server" UpdateMode="Conditional">
    <ContentTemplate>
        <asp:Panel ID="pnlTreeView" runat="server" ScrollBars="Vertical" Width="500" Height="500">
        <asp:TreeView ID="treeCategory" SkinID="Simple" runat="server" ShowCheckBoxes="Leaf">
            <Nodes>
                <asp:TreeNode SelectAction="Expand" Text="Select Categories"/>
            </Nodes>
        </asp:TreeView> 
        </asp:Panel> 
        <asp:button id="btnLoadTree" runat="server" text="Load" onclick="btnLoadTree_Click"/>                        

        <div class="form-actions center">
        <asp:Button id="btnSetCategories" runat="server" Text="Set" class="btn btn-small btn-primary" UseSubmitBehavior="false" OnClientClick="setCategory();" OnClick="btnSetCategories_Click"/>        
        <input type="button" value="Close" onclick="closeCategoryTreeDialog()" class="btn btn-small btn-info"/>
        </div>   
    </ContentTemplate>
    </asp:UpdatePanel>
    <asp:Button id="btnLoadCategories" runat="server" Text="LoadCat" UseSubmitBehavior="false" OnClientClick="closeCategoryTreeDialog();" />    
     
</div>

<div id="expressionDialog" class="web_dialog">
	<div style="padding-top:5px" class="modal-header">
		<asp:label id="lblExpressionTitle" runat="server"></asp:label>
	</div>
	<div class="express_top">
		<div class="expression_div">
			<span class="express_caps">Expression String</span>
			<asp:textbox runat="server" textmode="MultiLine" id="taExpressionString" rows="10" columns="50" onchange="onExpressionChanged(this)" autocompletetype="None" style="height:219px;resize:none;padding-right:5px;"/>
			<asp:label id="lblOverwrite" runat="server"><asp:checkbox runat="server" id="cbOverwrite" onclick="overwriteExpressionString(this)" cssclass="editexpress"/>Edit Expression</asp:label>
		</div>
		<div class="fields_div">
			<span class="express_caps">Fields</span>
			<asp:listbox runat="server" id="lbFields" style="width:187px;font-size:14px;margin-top:0px;height:237px;"></asp:listbox>
		</div>
	</div>
	<div class="express_bottom">
		<div style="margin-bottom:10px;">
			<b>Test Your Expression String</b>
		</div>
		<div style="float:left;width:38%;">
			<span id="Span6">Field Name</span><br>
			<asp:dropdownlist runat="server" id="ddlFields" class="value" style="font-size:14px;padding-top:10px;"></asp:dropdownlist>
		</div>
		<div style="float:left;width:38%;padding-left:7px;">
			<span id="Span2">Test Value</span><br>
			<asp:textbox runat="server" id="tbTestString" size="30"/>
		</div>
		<div style="float:left;width:22%;">
			<span id="Span2"></span><br>
		</div>
		<!--</div>-->
		<asp:updatepanel id="pnlExpression" runat="server" class="control-group" updatemode="Conditional">
		<contenttemplate>
		<div class="validate" style="margin-top:20px;height:auto;">
			<asp:button id="btnValidate" runat="server" text="Test" onclick="btnExpressionValidate_Click" class="btn btn-small btn-primary" onclientclick="updateExpressionFields()" style="margin-left:7px;"/>
			<br>
			<br>
			<br>
			<span>Output <i class="icon-arrow-right"></i></span>&nbsp;<asp:label runat="server" id="lblExprResult"/>
		</div>
		<asp:Hiddenfield id="hExpressionFieldName" runat="server"/>
		<asp:Hiddenfield id="hExpressionFields" runat="server"/>
		</contenttemplate>
		</asp:updatepanel>
	</div>
	<div class="form-actions center" style="margin-bottom:0px;">
		<input type="button" value="Set" onclick="setExpressionString()" class="btn btn-small btn-success"/>
		<input type="button" value="Example and Help" onclick="window.open('http://easylist.staging10.uniquewebsites.com.au/expression-help.aspx','targetWindow','toolbar=no,location=no,status=no,menubar=no,scrollbars=yes,resizable=yes,width=500,height=650');return false;" class="btn btn-small btn-primary"/>
		<input type="button" value="Cancel" onclick="closeExpressionStringEditor()" class="btn btn-small btn-info"/>
	</div>
</div>

<div id="mappingDialog" class="web_dialog">
    <asp:UpdateProgress ID="progressMapping" runat="server" AssociatedUpdatePanelID="pnlMapping" >
        <ProgressTemplate>
        <asp:Label ID="lblLoading" runat="server" Text="Loading..." ForeColor="Blue" ViewStateMode="Disabled"></asp:Label>
        </ProgressTemplate>
    </asp:UpdateProgress>

    <asp:UpdatePanel ID="pnlMapping" runat="server" class="control-group" UpdateMode="Conditional">
    <ContentTemplate>
    <div style="padding-top:5px" class="modal-header"><asp:Label ID="lblMappingTitle" runat="server"></asp:Label></div>

    <div class="control-group" style="margin-top:10px;">
	    <div class="controls">
            <asp:dropdownlist id="ddlSystemCodes" runat="server" class="value"/>		    
		    <div id="spMappingError" style="color:Red;display:none;margin-top:5px;">
			    Error
		    </div>
	    
		    <asp:TextBox ID="txtUserCodes" runat="server" MaxLength="100" class="value"></asp:TextBox>
		    <button class="btn btn-small btn-success" onclick="setMapping(); return false;">Add</button>
		    <asp:button id="btnLoadMapping" runat="server" text="Load" onclick="btnLoadMapping_Click"/>
	    </div>
    </div>

    <asp:Panel ID="pnlMappingTable" runat="server" ScrollBars="Auto" Height="300px">
    <table id="tblData" class="mapping-table">	 
        <thead> 
            <tr> 
                <th scope="col" width="40%" style="font-weight:bold; border-style:solid">EasyList Values</th> 
                <th scope="col" width="40%" style="font-weight:bold; border-style:solid">Dealer Values</th>  
                <th scope="col" width="20%" style="font-weight:bold; border-style:solid"></th> 
            </tr> 
        </thead> 
        <tbody> 
    
        </tbody> 
    </table>
    </asp:Panel>

    <div class="form-actions center">
    <button class="btn btn-small btn-success" onclick="saveMappingValues(); return false;">Set</button>
    <button class="btn btn-small btn-info" onclick="closeMappingEditor(); return false;">Cancel</button> 
    <asp:HiddenField id="hMappingFieldName" runat="server"/>
    <asp:HiddenField id="hMappingFieldLabel" runat="server"/>
    <asp:HiddenField id="hExpressionNameList" runat="server" />    
    </div>
    </ContentTemplate>
    </asp:UpdatePanel>
</div>  

<script type="text/javascript">
    $(document).ready(function () {
        $('.expressionstringopener').each(function (i, obj) {
            setExpressionAddEditLabel(this);
        });

        $('.mappingopener').each(function (i, obj) {
            setMappingAddEditLabel(this);
        });

        $('[id$=ddlFields]').change(function () {
            var previousField = $('[id$=ddlFields]').attr('previous');
            $("[id$=ddlFields] option:contains('" + previousField + "')").attr("value", $('[id$=tbTestString]').val());

            var selectedVal = $('[id$=ddlFields]').val();
            $('[id$=tbTestString]').val(selectedVal);

            // update previous
            var selectedText = $("[id$=ddlFields] option:selected").text();
            $('[id$=ddlFields]').attr("previous", selectedText);
        });

        $('[id$=lbFields]').on('dblclick', function () {
            var $lb = $(this);
            var $exp = $('[id$=taExpressionString]').val();

            var idx = $('[id$=taExpressionString]').getCursorPosition();
            var $appendedVal = $exp + $lb.val().toLowerCase();

            if (idx > 0)
                $appendedVal = $exp.substring(0, idx) + $lb.val().toLowerCase() + $exp.substring(idx, $exp.length);

            $('[id$=taExpressionString]').val($appendedVal);
        });

        (function ($, undefined) {
            $.fn.getCursorPosition = function () {
                var el = $(this).get(0);
                var pos = 0;
                if ('selectionStart' in el) {
                    pos = el.selectionStart;
                } else if ('selection' in document) {
                    el.focus();
                    var Sel = document.selection.createRange();
                    var SelLength = document.selection.createRange().text.length;
                    Sel.moveStart('character', -el.value.length);
                    pos = Sel.text.length - SelLength;
                }
                return pos;
            }
        })(jQuery);

    });
    
    //category tree
    function openCategoryTreeEditor(c) {
        // reset all nodes
        //resetTreeNodes();
        // check the selected nodes
        //var cats = $('#MainContent_abc_blCategories').attr('Categories');
        //if (cats != '') {
        //    var catArr = cats.split(",");
        //   $('div[id$=MainContent_abc_treeCategory]').find("input[type=checkbox]").each(function () {
        //alert($(this).text);

        //    });

        //            for (var i in catArr) {
        //                alert(catArr[i]);
        //                var test = 'MainContent_abc_treeCategoryn' + catArr[i] + 'CheckBox';
        //                alert(test);
        //                $('input[id$=MainContent_abc_treeCategoryn' + catArr[i] + 'CheckBox]').prop('checked', true);
        //            }
        //}
        $("[id*='btnLoadTree']").click();

        ShowDialog(true, 'categoryTreeDialog');
    }

    function resetTreeNodes() {
        $('div[id$=treeCategory]').find("input[type=checkbox]").prop('checked', false);
    }

    function setCategory() {
        var categories = "";

        $('div[id$=treeCategory]').find("input[type=checkbox]").each(function () {
            var isChecked = $(this).is(':checked');

            if (isChecked) {
                var nodeId = $(this).attr('id').replace("CheckBox", "").replace("treeCategoryn", "treeCategoryt");
                var catName = $('a[id$=' + nodeId + ']').text();
                var catId = catName.substring(0, catName.indexOf(","));
                categories = categories + catId + ",";
            }
        });

        //alert("Category" + categories);

        $('[id$=hCategories]').val(categories);

        //alert($('[id$=hCategories]').val());
        $("[id*='btnLoadCategories']").click();
    }

    function closeCategoryTreeDialog() {
        HideDialog('categoryTreeDialog');
    }

    //expression start
    function openExpressionStringEditor(c) {
        var field = $(c).attr('data-value');
        var fieldLabel = $(c).attr('data-label');
        var fields = $('[id$=hExpressionNameList]').val();
        var fieldValue = $('input[id$=tb' + field + 'ExpressionString]').val();
        var isEnabled = $("input:checkbox[id$=cbUserExpression" + field + "]").is(':enabled');

        // update field dropdown
        $('[id$=ddlFields]').empty();
        $('[id$=lbFields]').empty();
        var fieldNames = JSON.parse(fields);

        if (fieldNames != null) {
            for (var fn in fieldNames) {
                if (field == fn)
                    continue;

                if ($('[id$=pnlLocation]').attr("style") != "" && fn.indexOf("loc") == 0)
                    continue;

                if ($('[id$=pnlContact]').attr("style") != "" && fn.indexOf("seller") == 0)
                    continue;

                var ddlOption = $('<option value="" title="' + fieldNames[fn] + '">' + fn + '</option>');
                var lbOption = $('<option value="' + fn + '" title="' + fieldNames[fn] + '">' + fieldNames[fn] + '</option>');

                $('[id$=lbFields]').append(lbOption);

                $('[id$=ddlFields]').append(ddlOption);

            }
        }

        // update previous for onchange
        $('[id$=ddlFields]').attr("previous", "fieldvalue");

        $('[id$=taExpressionString]').val(fieldValue);

        $('[id$=tbTestString]').val("");
        $('[id$=lblExprResult]').text("");
        $('[id$=lblExprResult]').css('color', 'black');
        $('[id$=lblExpressionTitle]').text("Expression Builder - " + fieldLabel);
        $('[id$=hExpressionFieldName]').val(field); // hidden field to persist label
        $('[id$=hExpressionFields]').val("");

        if (isEnabled) {
            $('[id$=lblOverwrite]').show()
            var isChecked = $("input:checkbox[id$=cbUserExpression" + field + "]").is(':checked');
            $('[id$=cbOverwrite]').prop('checked', isChecked);

            if (isChecked) {
                $('[id$=taExpressionString]').removeAttr("disabled");
                $('[id$=lbFields]').removeAttr("disabled");
            }
            else {
                $('[id$=taExpressionString]').attr("disabled", "disabled");
                $('[id$=lbFields]').attr("disabled", "disabled");
            }
        }
        else {
            $('[id$=lblOverwrite]').hide();
            $('[id$=taExpressionString]').removeAttr("disabled");
            $('[id$=lbFields]').removeAttr("disabled");
        }

        ShowDialog(true, 'expressionDialog');
    }

    function overwriteExpressionString(c) {
        var isChecked = $(c).is(':checked');
        var field = $('[id$=hExpressionFieldName]').val();
        if (isChecked) {
            $('[id$=taExpressionString]').removeAttr("disabled");
            $('[id$=lbFields]').removeAttr("disabled");
        }
        else {
            $('[id$=taExpressionString]').attr("disabled", "disabled");
            $('[id$=lbFields]').attr("disabled", "disabled");

            var original = $('input[id$=tb' + field + 'ExpressionString]').attr('original');
            $('[id$=taExpressionString]').val(original);
        }
    }

    function onExpressionChanged() {
        $('[id$=lblExprResult]').text("");
    }

    function updateExpressionFields() {
        // update current
        $("[id$=ddlFields] option:contains('" + $("[id$=ddlFields] option:selected").text() + "')").attr("value", $('[id$=tbTestString]').val());

        var fieldsjson = new Array();
        var jsonFields = "";

        $("[id$=ddlFields] option").each(function () {
            fieldjson = {}
            fieldjson["Text"] = $(this).text();
            fieldjson["Value"] = $(this).attr('value');

            fieldsjson.push(fieldjson);
        });

        if (fieldsjson != "")
            jsonFields = JSON.stringify(fieldsjson);

        // update to hidden field to be used on server validate
        $('[id$=hExpressionFields]').val(jsonFields);
    }

    function setExpressionString() {
        var exprResult = $('[id$=lblExprResult]').text();
        var field = $('[id$=hExpressionFieldName]').val();
        var fieldValue = $('[id$=taExpressionString]').val();
        var isChecked = $('[id$=cbOverwrite]').is(':checked');

        if (fieldValue != '') {
            // check if the expression is validated
            if (exprResult == '') {
                alert("Please test your Expression first.");
                return;
            }
            else if (exprResult.indexOf("Error") == 0) {
                alert("Unable to Set due to invalid Expression.");
                return;
            }
        }

        $('input[id$=tb' + field + 'ExpressionString]').val(fieldValue);
        $("input:checkbox[id$=cbUserExpression" + field + "]").prop('checked', isChecked);

        $('.expressionstringopener').filter('[data-value=' + field + ']').each(function (i, obj) {
            setExpressionAddEditLabel(this);
        });

        HideDialog('expressionDialog');
    }

    function closeExpressionStringEditor() {
        HideDialog('expressionDialog');
    }

    function setExpressionAddEditLabel(c) {
        var field = $(c).attr('data-value');
        var fieldValue = $('input[id$=tb' + field + 'ExpressionString]').val();

        if (fieldValue != '') {
            $(c).text('Edit');
        }
        else {
            $(c).text('Add');
        }
    }
    
    // expression end

    //mapping start

    function setMapping() {

        mappedValue = $('input[id$=txtUserCodes]').val(); //tdSourceValue.children("input[type=text]").val();
        sourceValue = $('[id$=ddlSystemCodes]').val(); //tdMappedValue.children("input[type=text]").val()
        sourceText = $('[id$=ddlSystemCodes]').find('option:selected').text();

        if (sourceValue == null || mappedValue == null || sourceValue.trim() == '' || mappedValue.trim() == '') {
            mappingEditorShowError("Value cannot be empty");
        }
        else {
            // make sure unique user codes can be added
            var isUnique = true;
            if ($('#tblData > tbody  > tr').length > 0) {
                $('#tblData > tbody  > tr').each(function () {
                    var row = $(this);
                    var tblSourceValue = $.trim(row.find('td:eq(0)').html());
                    if (tblSourceValue == sourceValue) {
                        mappingEditorShowError("EasyList Value \"" + sourceText + "\" has already been added for mapping.");
                        isUnique = false;
                    }
                });
            }

            if (isUnique) {
                if ($('#tblData > tbody  > tr').length == 1) {
                    var rowText = $('#tblData > tbody  > tr').html();
                    if (rowText.indexOf("No mapping value found.") > 0) {
                        $('#tblData > tbody  > tr').remove();
                    }
                }

                $("#tblData tbody").append("<tr>" + "<td>" + sourceValue + "</td>" + "<td>" + sourceText + "</td>" + "<td>" + mappedValue + "</td>" + "<td><a href='javascript:void(0)' class='btnDelete btn btn-small'>Delete</a></td>" + "</tr>");
                $('td:nth-child(1)').hide();

                $(".btnDelete").bind("click", deleteMapping);

                $('input[id$=txtUserCodes]').val("");

                mappingEditorShowError("");
            }
        }

    }

    function saveMappingValues() {
        var field = $('[id$=hMappingFieldName]').val();
        var valuesjson = new Array();
        var jsonString = "";

        if ($('#tblData > tbody  > tr').length > 0) {
            $('#tblData > tbody  > tr').each(function () {
                var row = $(this);
                var sourceValue = $.trim(row.find('td:eq(0)').html());
                var sourceText = $.trim(row.find('td:eq(1)').html());
                var mappedValue = $.trim(row.find('td:eq(2)').html());
                var isEditable = $.trim(row.find('td:eq(3)').html());

                if (isEditable.length == 0)
                    isEditable = false;
                else
                    isEditable = true;

                if (sourceValue.indexOf("No mapping value found.") < 0) {
                    valuejson = {}
                    valuejson["SourceValue"] = sourceValue;
                    valuejson["SourceDisplayName"] = sourceText;
                    valuejson["MappedValue"] = mappedValue;
                    valuejson["IsEditable"] = isEditable;

                    valuesjson.push(valuejson);
                }

            });

            if (valuesjson != "")
                jsonString = JSON.stringify(valuesjson);
        }

        $('input[id$=tb' + field + 'Mapping]').val(jsonString);

        $('.mappingopener').filter('[data-value=' + field + ']').each(function (i, obj) {
            setMappingAddEditLabel(this);
        });

        HideDialog('mappingDialog');
    }

    function deleteMapping() {
        //if (getMode() == '') {
        var par = $(this).parent().parent();
        par.remove();

        //var field = $('#MainContent_abc_hMappingFieldName').val();
        //saveMappingValues(field);

        if ($('#tblData > tbody  > tr').length == 0) {
            $("#tblData tbody").append("<tr><td colspan=3>No mapping value found.</td></tr>");
        }

        //setMode("");
        //}
    };

    function cancelMapping() {
        var par = $(this).parent().parent();
        par.remove();

        //setMode("");

        if ($('#tblData > tbody  > tr').length == 0) {
            $("#tblData tbody").append("<tr><td colspan=3>No mapping value found.</td></tr>");
        }

        mappingEditorShowError("");
    };

    function openMappingEditor(c) {
        var field = $(c).attr('data-value');
        var fieldLabel = $(c).attr('data-label');

        // update title
        $('[id$=lblMappingTitle]').text("Mapping Values - " + fieldLabel);

        $('[id$=hMappingFieldName]').val(field);
        $('[id$=hMappingFieldLabel]').val(fieldLabel);

        $('[id$=ddlSystemCodes]').empty();
        $('input[id$=txtUserCodes]').val("");
        $("#tblData tbody").html("");

        $("[id*='btnLoadMapping']").click();

        ShowDialog(true, 'mappingDialog');
    }

    function closeMappingEditor() {
        HideDialog('mappingDialog');
    }

    function mappingEditorShowError(errorMessage) {
        $('#spMappingError').show()
        $('#spMappingError').text(errorMessage);
    }

    function loadMappingsForField(field) {
        var field = $('[id$=hMappingFieldName]').val();

        $("#tblData tbody tr").remove();
        var jsonString = $('input[id$=tb' + field + 'Mapping]').val();

        if (jsonString == 'undefined' || jsonString == '' || jsonString == null) {
            $("#tblData tbody").append("<tr><td colspan=3>No mapping value found.</td></tr>");
        }
        else {
            var data = JSON.parse(jsonString);

            if (data != null) {
                for (var i in data) {
                    $("#tblData tbody").append("<tr><td></td><td></td><td></td><td></td></tr>");
                    var par = $('#tblData tr:last');
                    var tdSourceValue = par.children("td:nth-child(1)").hide();
                    var tdSouceText = par.children("td:nth-child(2)");
                    var tdMappedValue = par.children("td:nth-child(3)");
                    var tdButtons = par.children("td:nth-child(4)");
                    tdSourceValue.html(data[i].SourceValue);
                    tdMappedValue.html(data[i].MappedValue);
                    tdSouceText.html(data[i].SourceDisplayName);
                    if (data[i].IsEditable == true) {
                        tdButtons.html("<a href='javascript:void(0)' class='btnDelete btn btn-small'>Delete</a>");
                        $(".btnDelete").bind("click", deleteMapping);
                    }
                }
            }
        }

    }

    function setMappingAddEditLabel(c) {
        var field = $(c).attr('data-value');
        var fieldValue = $('input[id$=tb' + field + 'Mapping]').val();

        if (fieldValue != '') {
            $(c).text('Edit');
        }
        else {
            $(c).text('Add');
        }
    }
    // mapping end

    

    function ShowDialog(modal, dialogId) {
        //$("#overlay").show();
        $('#top-navigation').css('z-index', '100');
        $("#" + dialogId).fadeIn(300);

        if (modal) {
            $("#overlay").unbind("click");
        }
        else {
            $("#overlay").click(function (e) {
                HideDialog(dialogId);
            });
        }
    }

    function HideDialog(dialogId) {
        //$("#overlay").hide();
        $('#top-navigation').css('z-index', '400');
        $("#" + dialogId).fadeOut(300);
    }
</script>