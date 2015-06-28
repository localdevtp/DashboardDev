<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="FeedInTemplateControl.ascx.cs" Inherits="TeamUniquemail.Controls.FeedInTemplateControl" EnableViewState="true" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajx" %>
<%@ Register Assembly="TeamUniquemail" Namespace="TeamUniquemail.Controls" TagPrefix="cc1" %>
<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script>
<script type="text/javascript" src="https://rawgit.com/ded/bowser/master/bowser.min.js"></script>

<style type="text/css">
.form-horizontal .control-label{
    width:210px;
}

.form-horizontal .controls {
    margin-left: 230px;
}

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

.web_dialog {
	width: 49% !important;
	height: auto !important;
	border: 1px solid rgba(0, 0, 0, 0.3) !important;
	left: 25% !important;
	top: 20% !important;
	padding: 10px 10px 0 10px !important;
	margin-left: 0px !important; 
	border-radius: 6px;
}

.map{
	float:left;
	width:40%;
}

.map-last{
	float:left;
	width:20%;
}

@media screen and (max-width: 1200px){
	.web_dialog {
		width: 80% !important;
		left: 5% !important;
		height:90% !important;
		top:5% !important;
		overflow-y:auto;
		margin-top: 0px !important;
	}
	
	.map{
		width:100%;
	}
	
	.map-last{
		width:100%;
	}	
}

/*ADDED*/
@media screen and (max-width: 780px){
	.web_dialog {
		width: 95% !important;
		left: 0% !important;
		top:0% !important;
		height:100% !important;
		overflow-y:auto;
		margin-top: 0px !important;
	}
}

/*end*/

@media screen and (max-width: 1200px){
	.map{
		width:100%;
		margin-bottom:5px;
	}
	.map{
		width:100%;
	}
	
	.map-last{
		width:100%;
	}
}

.web_treedialog
{
   display: none;
   position: fixed;
   width: 40%;
   height: 600px;
   top: 10%;
   left: 35%!important;
   right: 30% !important;
   background-color: #ffffff;
   border: 2px solid #336699;
   padding: 0px;
   z-index: 1002;
   margin-left:0px !important;
}

.treedialogPanel{
	width:100%;
	height:500px;
	overflow-y:auto;
}

/*ADDED*/
@media screen and (max-width: 1000px){
	.web_treedialog{
		 left: 20%!important;
	}
}
@media screen and (max-width: 780px){
	.web_treedialog
	{
     top:0% !important;
	 left:0% !important;
	 width:97% !important;
	 height:100% !important;
	 overflow-y:auto;	 
	}
	.treedialogPanel{
		width:100%;
		height:auto !important;		
	}	
}

.web_trialdialog
{
   display: none;
   position: fixed;
   width: 900px;
   margin-left:0px;
   margin:right:0px;
   background-color: #ffffff;
   border: 2px solid #336699;
   padding: 0px;
   z-index: 1002;
}

.web_trialdialog{
	top:100px !important;
	left:10% !important;
}

@media screen and (-webkit-min-device-pixel-ratio:0) {  
	.web_trialdialog{
	top:10% !important;
	left:10% !important;
	}
}

@media screen and (max-width: 1000px){
	@media screen and (-webkit-min-device-pixel-ratio:0) {  
		.web_trialdialog{
		top:4% !important;
		left:10% !important;
		}
	}
}

/*ADDED*/
@media screen and (max-width: 480px){
	.web_trialdialog{
		width: 95% !important;
		left: 0% !important;
		top:0% !important;
		height:100% !important;
		overflow-y:auto;		
	}
}
/*end*/

.web_trialdialog input[type=file] {
	line-height: 12px;
	background: rgba(255, 255, 255, 0)!important;
	color: #333333;
	text-shadow: 0 1px 0 #fff9f2;
	border-radius: 8px;
	border: 0px solid #FF9206;
	padding-top: 5px;
	padding-left: 6px;
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

.editexpress input{
	margin-top:-5px;
	margin-right:3px;
}

.express_top{
	float:left;
	text-align: left;
	width:100%;
	padding-top:5px !important;
	height:auto;
	background:white;
}

.fields_div{
	float:right;
	width:32%;
	margin-left:0px;
}

.expression_div{
	float:left;
	width:65% ;
}

.taExpressionString{
	width:100%;
}

@media screen and (max-width: 800px){
	.fields_div{		
		width:99%;
		margin-bottom:10px;		
	}	
	.expression_div{		
		width:99% ;
	}	
	.web_dialog textarea{
		width:95%;
	}
}

.express_bottom{
	text-align: left;	
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

.web_trialdialog input[type=file] {
	border:none !important;
	width:300px;
}

@-moz-document url-prefix() {	
	.web_trialdialog input[type=file] {
	padding-top:13px;
	padding-left:-2px;
	border:0px solid orange;
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

#bgDiv{         
	position:absolute;         
	top:0px;
	bottom:0px;         
	left:0px;         
	right:0px;
	overflow:hidden;
	padding:0;
	margin:0;
	background-color:white;
	filter:alpha(opacity=70);
	opacity:0.7;
	z-index:500;
}
 
#Progress{
	position: absolute;
	z-index: 600;
	left: 45%;
	top: 30%;
	background-color: #f28b00;
	-webkit-box-shadow: 1px 1px 5px #cccccc;
	box-shadow: 1px 1px 5px #cccccc;
	-o-border-radius: 6px;
	border-radius: 6px;
	padding:20px;
}

#Progress img{
	width: 30px;
	height: 30px;
	-webkit-animation: rotate 2s infinite linear;
	-ms-animation: rotate 2s infinite linear;
	animation: rotate 2s infinite linear;
}

#uploadTrigger {
	border: 0px solid #333;
	padding: 10px;
	margin: 5px 0px;
	background: #f28b00;
	color: #fff;
	width:58px;
	border-radius: 3px;
	float: left;
	cursor:pointer;
 }

#filanameinput{
	float: left;
	display: inline;
	padding-top: 12px;
	padding-left:5px;
	width:50%;
	word-break:break-all;
}

.TrialR{
	margin-top:35px;
}

/*#fileUpload{
display:none;
}

#lblFileUpload{
	display:none;
}*/

.exp-string{
	float:left;
	width:50%;	
}

.exp-output{
	margin-top:70px;
}

.validate{
	margin-top:20px;
	height:auto;
	width:10%;
	float:left;
}

@media screen and (max-width: 800px){
	.validate{
		margin-top:5px !important;
		width:100%;
	}	
	.exp-string{
		width:100%;
	}	
	.exp-output{
		margin-top:150px;
	}
}
</style>
<cc1:MessageControl ID="messageCtrl" runat="server" />
<ajx:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server" AsyncPostBackTimeout="300" ScriptMode="Release" CombineScripts="true" ></ajx:ToolkitScriptManager>
<asp:Panel ID="pnlBody" runat="server">
    <fieldset style="margin-top:-45px;">
            <div class="form-left">
                <div class="control-group">
                    <asp:Label ID="lblCustAcct" runat="server" Text="Customer Account " AssociatedControlID="ddlCustAcct" 
                    class="control-label"></asp:Label>
                    <div class="controls"><asp:DropDownList ID="ddlCustAcct" runat="server" OnSelectedIndexChanged="ddlCustAcct_SelectedIndexChanged" AutoPostBack="true" class="value" /></div>
                </div>
                <div class="control-group">
                    <asp:Label ID="lblCatalogue" runat="server" Text="Select Catalog " AssociatedControlID="ddlCatalogue" 
                    class="control-label"></asp:Label>
                    <div class="controls"><asp:DropDownList ID="ddlCatalogue" runat="server" OnSelectedIndexChanged="ddlCatalogue_SelectedIndexChanged" AutoPostBack="true" class="value" /></div>
                </div>
                <div class="control-group">   
                        <asp:Label ID="lblDefaultName" runat="server" Text="Currently Selected Template: " class="control-label"></asp:Label>
                        <div class="controls"><asp:DropDownList ID="ddlDefaultName" runat="server" OnSelectedIndexChanged="ddlDefaultName_SelectedIndexChanged" AutoPostBack="true" class="value" /></div>
                </div>
                <asp:Panel ID="pnlCatalogue" runat="server" class="control-group" GroupingText="Create a New Template, or Review an Existing Template">
                    <div class="control-group">   
                        <asp:Label ID="lblEditName" runat="server" Text="New or Existing Template: " class="control-label"></asp:Label>
                        <div class="controls"><asp:DropDownList ID="ddlName" runat="server" OnSelectedIndexChanged="ddlName_SelectedIndexChanged" AutoPostBack="true" class="value" /></div>
					</div>
					
                    <div class="control-group">
                        <asp:Label ID="lblName" runat="server" Text="Template Name: " AssociatedControlID="tbName" 
                        class="control-label"></asp:Label>
                        <div class="controls"><asp:TextBox ID="tbName" runat="server" MaxLength="20" class="value"></asp:TextBox></div>
                        <asp:RequiredFieldValidator ID="reqName" runat="server" ControlToValidate="tbName" Display="Dynamic" ErrorMessage="Template Name is a required field." ForeColor="Red" ValidationGroup="UponSave"></asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator ID="regName" runat="server" ControlToValidate="tbName" Display="Dynamic" ErrorMessage="Invalid Template Name, only alphanumeric characters and space are allowed." ForeColor="Red" ValidationExpression="^[0-9a-zA-Z ]+$" ValidationGroup="UponSave"></asp:RegularExpressionValidator>
                        <asp:CustomValidator id="customeName" runat="server" OnServerValidate="NameValidate" Display="Dynamic" ControlToValidate="tbName" ErrorMessage="Template name is in used." ForeColor="Red" ValidationGroup="UponSave"></asp:CustomValidator>
                    </div>
                    <asp:HiddenField id="hFeedInType" runat="server"/>
                    <asp:HiddenField id="hFeedDataDir" runat="server"/>
                    <asp:HiddenField id="hFeedImageDir" runat="server" />                                                
                    <asp:HiddenField id="hFeedIsFolderName" runat="server" />                    
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
                
                <asp:Panel ID="pnlFileInfoWrapper" runat="server" class="control-group" GroupingText="File Information">
                    <asp:UpdatePanel ID="pnlFileInfo" runat="server" class="control-group" UpdateMode="Conditional">
                    <ContentTemplate>
                        <div class="control-group">
                            <asp:Label ID="lblSourceDataFormat" runat="server" Text="File Format: " AssociatedControlID="ddlSourceDataFormat"
                            class="control-label"></asp:Label>    
                            <div class="controls"><asp:DropDownList ID="ddlSourceDataFormat" runat="server" OnSelectedIndexChanged="ddlSourceDataFormat_SelectedIndexChanged" AutoPostBack="true" class="value"/>                                
							</div>							
                        </div>
					    <div id="divDelimiter" runat="server" class="control-group">
                            <asp:Label ID="lblDelimiter" runat="server" Text="Separated By: " AssociatedControlID="ddlDelimiter"
                            class="control-label"></asp:Label>
                            <div class="controls"><asp:DropDownList ID="ddlDelimiter" runat="server"  /></div>
                        </div>
                        <div id="divFirstRowHasColumnNames" runat="server" class="control-group">
                        <asp:Label ID="lblFirstRowHasColumnNames" runat="server" Text="First Row Has Column Name: " AssociatedControlID="cbFirstRowHasColumnNames"
                            class="control-label"></asp:Label>
                            <div class="controls"><label class="checkbox"><asp:CheckBox ID="cbFirstRowHasColumnNames" runat="server" /></label></div>
                        </div>
                        <div id="divSourceDataRootElement" runat="server" class="control-group">
                            <asp:Label ID="lblSourceDataRootElementName" runat="server" Text="XML Root Element Name: " AssociatedControlID="tbSourceDataRootElementName"
                            class="control-label"></asp:Label>
                            <div class="controls"><asp:TextBox ID="tbSourceDataRootElementName" runat="server" /></div>
                            <asp:RequiredFieldValidator ID="reqRootElement" runat="server" ControlToValidate="tbSourceDataRootElementName" Display="Dynamic" ErrorMessage="XML Root Element Name is a required field." ForeColor="Red" ValidationGroup="UponSave"></asp:RequiredFieldValidator>
                        </div>
                    </ContentTemplate>
                    </asp:UpdatePanel>
                    <div class="control-group">
                    <asp:Label ID="lblContact" runat="server" Text="Use Contact Details in File: " AssociatedControlID="cbContact"
                        class="control-label"></asp:Label>
                        <div class="controls"><label class="checkbox"><asp:CheckBox ID="cbContact" runat="server" /></label></div>
                    </div>
                    <div class="control-group">
                    <asp:Label ID="Label1" runat="server" Text="Use Location Details in File: " AssociatedControlID="cbLocation"
                        class="control-label"></asp:Label>
                        <div class="controls"><label class="checkbox"><asp:CheckBox ID="cbLocation" runat="server" /></label></div>
                    </div>
                    <div class="control-group">
                    <asp:Label ID="lblWithdraw" runat="server" Text="Withdraw Listings if not in File: " AssociatedControlID="cbWithdraw"
                        class="control-label"></asp:Label>
                        <div class="controls"><label class="checkbox"><asp:CheckBox ID="cbWithdraw" runat="server" /></label></div>
                    </div>
                </asp:Panel>

                <asp:UpdatePanel ID="pnlTemplateItems" runat="server" class="control-group" UpdateMode="Conditional">
                <ContentTemplate>
                    <asp:Panel ID="pnlContact" runat="server" GroupingText="Contact Information" />
                    
                    <asp:Panel ID="pnlLocation" runat="server" GroupingText="Location Information" />
                        
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
    <asp:Button ID="btnTrial" runat="server" Text="Trial Run" OnClick="btnTrial_Click" class="btn btn-large btn-primary" ValidationGroup="UponSave" UseSubmitBehavior="false"/>
    <asp:Button ID="btnDelete" runat="server" Text="Delete" OnClick="btnDelete_Click" class="aspNetDisabled btn btn-large" OnClientClick="if (!confirm('Are you sure you want to delete this file format template?')) return false;"/>
    </div>
</asp:Panel>

<div id="overlay" class="web_dialog_overlay"></div>

<div id="categoryTreeDialog" class="web_treedialog">
    <asp:UpdateProgress ID="progressTree" runat="server" AssociatedUpdatePanelID="pnlTreeCategory" >
        <ProgressTemplate>
		<div id="Progress"><img src="/images/spinner.png"></div>
		<div id="bgDiv"></div>             
        </ProgressTemplate>
    </asp:UpdateProgress>
    <asp:UpdatePanel ID="pnlTreeCategory" runat="server" UpdateMode="Conditional">
    <ContentTemplate>
        <asp:Panel ID="pnlTreeView" runat="server" class="treedialogPanel">
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
			<asp:textbox runat="server" textmode="MultiLine" id="taExpressionString" rows="10" columns="50" onchange="onExpressionChanged(this)" autocompletetype="None" class="taExpressionString" style="height:219px;resize:none;padding-right:5px;"/>
			<asp:label id="lblOverwrite" runat="server"><asp:checkbox runat="server" id="cbOverwrite" onclick="overwriteExpressionString(this)" cssclass="editexpress"/>Edit Expression</asp:label>
		</div>
		<div class="fields_div">
			<div class="express_caps">Fields</div>
			<asp:listbox runat="server" id="lbFields" style="width:100%;font-size:14px;margin-top:0px;height:237px;"></asp:listbox>
		</div>
	</div>
	<div class="express_bottom">
		<div style="margin-bottom:10px;">
			<b>Test Your Expression String</b>
		</div>
		<div style="width:90%;">
			<div class="exp-string">
				<span id="Span6">Field Name</span><br>
				<asp:dropdownlist runat="server" id="ddlFields" class="value" style="font-size:14px;padding-top:10px;width:95%;"></asp:dropdownlist>
			</div>
			<div class="exp-string">
				<span id="Span2">Test Value</span><br>
				<asp:textbox runat="server" id="tbTestString" size="30" style="width:95%;"/>
			</div>
			<!--<div style="float:left;width:22%;">
				<span id="Span2"></span><br>
			</div>-->
		</div>
		<!--</div>-->
		<asp:updatepanel id="pnlExpression" runat="server" class="control-group" updatemode="Conditional">
		<contenttemplate>
		<div class="validate">
			<asp:button id="btnValidate" runat="server" text="Test" onclick="btnExpressionValidate_Click" class="btn btn-small btn-primary" onclientclick="updateExpressionFields()" style="margin-left:7px;"/>
		</div>
		<div>
			<div class="exp-output" >Output <i class="icon-arrow-right"></i></div>&nbsp;<asp:label runat="server" id="lblExprResult"/>
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
			<div id="Progress"><img src="/images/spinner.png"></div>
			<div id="bgDiv"></div>        
        </ProgressTemplate>
    </asp:UpdateProgress>

    <asp:UpdatePanel ID="pnlMapping" runat="server" class="control-group" UpdateMode="Conditional">
    <ContentTemplate>
    <div style="padding-top:5px" class="modal-header"><asp:Label ID="lblMappingTitle" runat="server"></asp:Label></div>

    <div class="control-group" style="margin-top:10px;">
	    <div class="controls" style="margin-left:0px;">
		    <div class="map"><asp:TextBox ID="txtUserCodes" runat="server" MaxLength="100" class="value" style="width:90%;"></asp:TextBox></div>
		    <div class="map"><asp:dropdownlist id="ddlSystemCodes" runat="server" class="value" style="width:95%;"/></div>  
		    <div class="map-last">
			<button class="btn btn-small btn-success" onclick="setMapping(); return false;">Add</button>			
		    <asp:button id="btnLoadMapping" runat="server" text="Load" onclick="btnLoadMapping_Click"/>
			</div>
	    </div>
		<div id="spMappingError" style="color:Red;display:none;margin-top:50px;">
			    Error
		 </div>
    </div>

    <asp:Panel ID="pnlMappingTable" runat="server" ScrollBars="Auto" Height="300px" style="clear:left">
    <table id="tblData" class="mapping-table">	 
        <thead> 
            <tr> 
                <th scope="col" width="40%" style="font-weight:bold; border-style:solid">Dealer Values</th> 
                <th scope="col" width="40%" style="font-weight:bold; border-style:solid">EasyList Values</th>  
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

<div id="trialDialog" class="web_trialdialog">        
    <div style="padding-top:5px" class="modal-header">File Trial Run Report</div>
    <div class="control-group" style="margin-top:10px;">
        <div class="controls"><b><span id="Span1">Select File </span></b>
		<br/>		
        <ajx:AsyncFileUpload ID="fileUpload" runat="server" OnUploadedComplete ="fileUpload_UploadedComplete" CompleteBackColor="White" OnClientUploadStarted="uploadStarted" OnClientUploadComplete="uploadCompleted" OnClientUploadError="uploadError" ThrobberID="lblFileUpload" CssClass="file-up"/>
        <asp:Label runat="server" ID="lblFileUpload" Text="" ForeColor="Blue" ></asp:Label>
        <div class="button" id="uploadTrigger">Browse</div>
        <div id="filanameinput">No file chosen</div>
		
		</div>
    </div>          

    <asp:UpdateProgress ID="progressTrial" runat="server" AssociatedUpdatePanelID="pnlTrial" >
        <ProgressTemplate>
        <div id="Progress" style="top:20%;"><img src="/images/spinner.png"></div>		
        </ProgressTemplate>
    </asp:UpdateProgress>

    <asp:UpdatePanel ID="pnlTrial" runat="server" class="control-group" UpdateMode="Conditional" >
    <ContentTemplate>
    <asp:Label runat="server" id="lblTrialError"/>
    <div class="control-group" style="margin-top:10px;">
		<div>
			<asp:button id="btnLoadTrialReport" runat="server" text="Go" onclick="btnLoadTrialReport_Click" class="btn btn-small btn-primary "/>
			<asp:label runat="server" id="lblTrialTotal"></asp:label><br/>
			<asp:label runat="server" id="lblTrialStats"></asp:label>
			<div style="display:inline-block;float:right;padding-right:30px;">
				<asp:label runat="server" id="lblOnlineStats"></asp:label>
			</div>
			<asp:panel id="pnlTrialReport" runat="server" style="overflow:auto;" class="TrialR">
			<asp:gridview id="gridTrialReport" autogeneratecolumns="False" runat="server" onrowdatabound="gridTrialReport_RowDataBound" class="trial-report">
			</asp:gridview>
			</asp:panel>
			<div style="text-align:center;width:100%;">
				<asp:label runat="server" id="lblPage"></asp:label><asp:Hiddenfield id="hTrialPageNo" runat="server"/>                
				<div>
					<asp:button id="btnPrevious" runat="server" text="<" onclick="btnPrevious_Click" class="btn btn-small btn-primary "/>
					<asp:button id="btnNext" runat="server" text=">" OnClick="btnNext_Click" class="btn btn-small btn-primary " />
				</div>
			</div>
		</div>
	</div>

    <div class="form-actions center">
    <button class="btn btn-small btn-info" onclick="closeTrialDialog(); return false;">Close</button> 
    </div>
    </ContentTemplate>
    
    </asp:UpdatePanel>
</div>  

<script type="text/javascript">
    $('.message.success').prepend('<button data-dismiss="alert" class="close" type="button">×</button><strong>Success!</strong>');
    $('.message.success').attr('class', 'alert alert-success');
    $('.message.error').prepend('<button type="button" class="close" data-dismiss="alert">×</button><strong>ERROR</strong>');
    $('.message.error').attr('class', 'alert alert-error');

    // disable pdf data format option
    $("#<%=ddlSourceDataFormat.ClientID %> option").filter('[value="pdf"],[value="plaintexthtml"]').attr("disabled", "disabled");
    function EndRequestHandler(sender) {
        switch (sender._postBackSettings.asyncTarget) {
			case "<%=btnNext.UniqueID %>":
            case "<%=btnPrevious.UniqueID %>":
            case "<%=btnLoadTrialReport.UniqueID %>":
                var windowHeight = $(window).height();
                $(".TrialR").height(windowHeight - 488);
                break;
            case "<%=btnSetCategories.UniqueID %>":
                $("#<%=btnLoadCategories.ClientID %>").click();
                break;
            default: break;
        }
    }

    $(document).ready(function () {
        //tooltip       
        if (Sys.WebForms.PageRequestManager) {
            Sys.WebForms.PageRequestManager.getInstance().add_endRequest(EndRequestHandler);
        }        
        $("#<%=lblDefaultName.ClientID %>").append(GenerateToolTip("This is the template selected for use on the file that will be uploaded."));
        $("#<%=lblEditName.ClientID %>").append(GenerateToolTip("Choose an existing or new template here.  You will be able to edit it or format it."));
        $("#<%=lblName.ClientID %>").append(GenerateToolTip("Give your new template a name."));
        $("#<%=lblCategories.ClientID %>").append(GenerateToolTip("Click on \"reset\" and choose the category for the template."));
        $("#<%=lblSourceDataFormat.ClientID %>").append(GenerateToolTip("Choose the file format for your template here."));

        $("#<%=lblDelimiter.ClientID %>").append(GenerateToolTip("Some formats need a \"separator\" choose it here from the drop down menu."));
        $("#<%=lblFirstRowHasColumnNames.ClientID %>").append(GenerateToolTip("Tick the box if you want to use the first row of your file for column titles."));
        $("#<%=lblContact.ClientID %>").append(GenerateToolTip(" Use this option if you would like to use contact details that differ from your account default contacts.  Useful if you have more than one contact number."));
        $("#<%=Label1.ClientID %>").append(GenerateToolTip("Use this option if you would like to use location details that differ from your default settings.  Useful if you have more than one location."));
        $("#<%=lblWithdraw.ClientID %>").append(GenerateToolTip("Any listings not included in this new upload file will be withdrawn."));
        $("#Span1").append(GenerateToolTip("Using Trial Run will not place your ads on line nor send us the file.  It can be used to check your file, any errors or warnings will show below.   Hover over the row  to see more specific details of the error or warning you need to fix.  Contact us if you need help.  1800  810 514."));

        var windowHeight = $(window).height();
        $("#trialDialog").height(windowHeight - 200);
        $(".TrialR").height(windowHeight - 400);

        //lblDefaultName
        $("#uploadTrigger").click(function () {
            $("[id*='fileUpload']").click();
        });
        $('[id$=fileUpload]').css('display', 'none');
        $('[id$=lblFileUpload]').css('display', 'none');
        if ($.browser.msie == true && $.browser.version == "8.0") {
            $("#uploadTrigger").css('display', 'none');
            $("#filanameinput").css('display', 'none');
            $('[id$=fileUpload]').css('display', 'block');
            $('[id$=lblFileUpload]').css('display', 'block');
        }
        if ($.browser.msie == true && $.browser.version == "9.0") {
            $("#uploadTrigger").css('display', 'none');
            $("#filanameinput").css('display', 'none');
            $('[id$=fileUpload]').css('display', 'block');
            $('[id$=lblFileUpload]').css('display', 'block');
        }

        if ($.browser.msie == true && $.browser.version == "10.0") {
            $("#uploadTrigger").css('display', 'none');
            $("#filanameinput").css('display', 'none');
            $('[id$=fileUpload]').css('display', 'block');
            $('[id$=lblFileUpload]').css('display', 'block');
        }
        $('.expressionstringopener').each(function (i, obj) {
            setExpressionAddEditLabel(this);
        });

        $('.mappingopener').each(function (i, obj) {
            setMappingAddEditLabel(this);
        });

        $('[id$=cbContact]').on('click', function () {
            var $cb = $(this);
            if ($cb.is(':checked')) {
                $('[id$=pnlContact]').show();
            }
            else {
                $('[id$=pnlContact]').hide();
            }
        });

        $('[id$=cbLocation]').on('click', function () {
            var $cb = $(this);
            if ($cb.is(':checked')) {
                $('[id$=pnlLocation]').show();
            }
            else {
                $('[id$=pnlLocation]').hide();
            }
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

    // update order/xpath column width
    function updateColumnWidth(c) {
        $("#<%=ddlSourceDataFormat.ClientID %> option").filter('[value="pdf"],[value="plaintexthtml"]').attr("disabled", "disabled");
        $('div[id$=pnlTemplateItems]').find("input[type=text]").each(function () {
            var textboxName = $(this).prop('id');
            if (textboxName.indexOf('tbOrder') > 0) {
                if (c == "xml") {
                    $(this).prop('style', 'width:300px;');
                }
                else {
                    $(this).prop('style', 'width:40px;');
                }
            }
        });

        $('div[id$=pnlTemplateItems]').find('span').each(function () {
            var ctrlName = $(this).prop('id');
            if (ctrlName.indexOf('lblHeaderColumnNo') > 0) {
                if (c == "xml") {
                    $(this).text("XPath");
                }
                else {
                    $(this).text("Column No");
                }
            }
        });
    }

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
        //$("[id*='btnLoadCategories']").click();
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

        sourceValue = $('input[id$=txtUserCodes]').val();   //tdSourceValue.children("input[type=text]").val();
        mappedValue = $('[id$=ddlSystemCodes]').val(); //tdMappedValue.children("input[type=text]").val()
        mappedText = $('[id$=ddlSystemCodes]').find('option:selected').text();

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
                        mappingEditorShowError("Dealer Value \"" + tblSourceValue + "\" has already been added for mapping.");
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

                $("#tblData tbody").append("<tr>" + "<td>" + sourceValue + "</td>" + "<td>" + mappedValue + "</td>" + "<td>" + mappedText + "</td>" + "<td><a href='javascript:void(0)' class='btnDelete btn btn-small'>Delete</a></td>" + "</tr>");
                $('td:nth-child(2)').hide();

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
                var mappedValue = $.trim(row.find('td:eq(1)').html());
                var mappedDisplayName = $.trim(row.find('td:eq(2)').html());
                var isEditable = $.trim(row.find('td:eq(3)').html());

                if (isEditable.length == 0)
                    isEditable = false;
                else
                    isEditable = true;

                if (sourceValue.indexOf("No mapping value found.") < 0) {
                    valuejson = {}
                    valuejson["SourceValue"] = sourceValue;
                    valuejson["MappedValue"] = mappedValue;
                    valuejson["MappedDisplayName"] = mappedDisplayName;
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
                    var tdSourceValue = par.children("td:nth-child(1)");
                    var tdMappedValue = par.children("td:nth-child(2)").hide();
                    var tdMappedDisplayName = par.children("td:nth-child(3)");
                    var tdButtons = par.children("td:nth-child(4)");
                    tdSourceValue.html(data[i].SourceValue);
                    tdMappedValue.html(data[i].MappedValue);
                    tdMappedDisplayName.html(data[i].MappedDisplayName);
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

    // start trial run report dialog
    function openFileUpload() {
        $("[id*='fileUpload']").click();

        //$("[id*='btnLoadTrialReport']").click();
    }

    function fileUploadact() {
        openFileUpload();
    }

    function openTrialDialog() {
        $('[id$=gridTrialReport]').html("");
        $('[id$=lblTrialError]').css('display', 'none');
        $('[id$=lblTrialError]').text("");
        $('[id$=lblTrialStats]').text("");
        $('[id$=lblOnlineStats]').text("");
        $('[id$=lblPage]').text("");
        $('[id$=lblTrialTotal]').text("");

        $('[id$=btnPrevious]').hide();
        $('[id$=btnNext]').hide();

        //$('[id$=btnLoadTrialReport]').attr("disabled", "disabled");        
        ShowDialog(true, 'trialDialog');
    }

    function uploadStarted(sender, args) {
        //$('[id$=btnLoadTrialReport]').attr("disabled", "disabled");	
    }

    function uploadError(sender, args) {
        $('[id$=lblTrialError]').css('display', 'block');
        // $('[id$=lblTrialError]').text(args.get_errorMessage());		
    }

    function uploadCompleted() {
        //$('[id$=btnLoadTrialReport]').removeAttr("disabled");
        $('[id$=btnLoadTrialReport]').click();
        document.getElementById("filanameinput").innerHTML = $('input[type="file"]').val();
    }

    function closeTrialDialog() {
        HideDialog('trialDialog');
    }

    // trial run report end

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

    function GenerateToolTip(text) {
        return $('<i class="icon-info-2" data-toggle="tooltip" title="" >&nbsp;</i>').attr("data-original-title",text);
    }
</script>