<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="InboundFeedLog.ascx.cs" Inherits="TeamUniquemail.Controls.InboundFeedLog" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<style>
    .popupControl{
        background-color:White;
        position:relative;
        visibility:hidden;
        width:280px;
        max-height:60px;
        overflow-y:auto;
		text-align:left;
		padding:5px;
    }	
	
	.widget-content {
		padding: 0px;
	}
</style>

<asp:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server" AsyncPostBackTimeout="300" ScriptMode="Release" CombineScripts="true" ></asp:ToolkitScriptManager>
<asp:UpdatePanel ID="upMain" runat="server" class="widget-content no-padding loading-container">
<ContentTemplate>
<div id="loading-bg" style="display: none;"></div>
<div id="loading" style="display: none;"><img class="retina" src="/images/spinner.png"></div>
<div class="toolbars">
	<a class="btn btn-info active collapsed" data-toggle="collapse" data-target="#search-filter-leads"><i class="icon-filter">&nbsp;</i> Search / Filter / Sort Result</a>
</div>
<div class="widget-collapse-options collapse" id="search-filter-leads" style="height: 0px;">
	<div class="widget-collapse-options-inner">
		<div class="control-group"><asp:Label ID="lbUserCode" runat="server" AssociatedControlID="ddlCustAcct" Text="Customer Account:" CssClass="control-label" />
		<div class="controls"><asp:DropDownList ID="ddlCustAcct" runat="server" OnSelectedIndexChanged="ddlCustAcct_SelectedIndexChanged" AutoPostBack="true" /></div></div>
		<div class="control-group"><asp:Label ID="lbCatalogueId" runat="server" AssociatedControlID="ddlCatalogue" Text="Select Catalog:" CssClass="control-label"/>
		<div class="controls"><asp:DropDownList ID="ddlCatalogue" runat="server"/></div></div>
		<div class="control-group"><asp:Label ID="lbFeedSource" runat="server" AssociatedControlID="ddlFeedSource" Text="Feed source:" CssClass="control-label" />
		<div class="controls"><asp:DropDownList ID="ddlFeedSource" runat="server" /></div></div>
		<div class="control-group form-actions"><div class="controls"><asp:Button ID="Search" runat="server" Text="Submit" OnClick="Search_Click" CssClass="btn btn-large" /></div></div>
	</div>
</div>
<div style="overflow-x:auto">
 <asp:Repeater ID="rptFeedInLogs" runat="server" OnItemDataBound="rptFeedInLogs_ItemDataBound" EnableViewState="false" >
    <HeaderTemplate>
        <table class="footable footable-loaded default" cellpadding="0" cellspacing="0">
            <thead>
                <tr>                    
                    <th scope="col" width="10%">
                        File
                    </th>
                    <th scope="col" width="15%">
                        Feed Source
                    </th>
                    <th scope="col" width="13%">
                        Processed
                    </th>                               
                    <th scope="col" width="7%">
                        Total
                    </th>
                    <th scope="col" width="7%">
                        New
                    </th>
                    <th scope="col" width="7%">
                        Updated 
                    </th>
                    <th scope="col" width="7%">
                        No Change 
                    </th>
                    <th scope="col" width="7%">
                        Expired 
                    </th>
                    <th scope="col" width="7%">
                        Unpurified 
                    </th>
                    <th scope="col" width="7%">
                        Catalog
                    </th>
                    <th scope="col" width="13%">
                       Error Details
                    </th>                    
                </tr>
            </thead>
            <tbody>
    </HeaderTemplate>
    <ItemTemplate>
        <tr>             
            <td>
				 <asp:Panel ID="pnlError" runat="server" CssClass="popupControl" BorderStyle="Solid" BorderWidth="1px" BorderColor="Orange" style="display:none;top: 168px;">
                    <asp:Label runat="server" Text='<%# Eval("ErrorXml")%>' ID="lbError" />
                </asp:Panel>
                <asp:HyperLink runat="server" ID="hlFileName" Text="Download" NavigateUrl='<%# string.Concat("http://feeds.easylist.com.au/", string.Format("{0:yyyy}", Eval("ProcTimeStamp")) , "/inbound/", Eval("UserCode"), "/", Eval("FileName").ToString())%>' Target="_blank" ToolTip='<%# Eval("FileName").ToString() %>' />
            </td>
            <td>
                <%# Eval("FeedSource")%>
            </td>
            <td>
                <%# Convert.ToDateTime(Eval("ProcTimeStamp")).ToLocalTime().ToLocalTime().ToString("d MMM yyyy HH:mm:ss")%>
            </td>
            <td>
                <%# Eval("TotalLst")%>
            </td>
            <td>
                <%# Eval("NewLst")%>
            </td>
            <td>
                <%# Eval("UpdatedLst")%>
            </td>
            <td>
                <%# Eval("NoChangeLst")%>
            </td>
            <td>
                <%# Eval("ExpiredLst")%>
            </td>
            <td>
                <%# Eval("DraftLst")%>
            </td>
            <td>
                 <asp:Label ID="lbCatId" runat="server" Text='<%# Eval("HotlistId")%>' />
            </td>
            <td>
                <asp:HyperLink ID="hlError" runat="server" Text="view details" NavigateUrl="javascript:void(0);" />
                <asp:Label runat="server" ID="lbNoError" Text="None" Visible="false" />
                <asp:PopupControlExtender ID="pceParent" runat="server"
                TargetControlID="hlError"
                PopupControlID="pnlError"
                Position="Left" OffsetX="-240" OffsetY="-30" />
            </td>           
        </tr>
    </ItemTemplate>
    <AlternatingItemTemplate>
        <tr class="even">           
            <td>
				<asp:Panel ID="pnlError" runat="server" CssClass="popupControl" BorderStyle="Solid" BorderWidth="1px" BorderColor="Orange" style="display:none;top: 168px;">
                <asp:Label runat="server" Text='<%# Eval("ErrorXml")%>' ID="lbError" />
                </asp:Panel>
                <asp:HyperLink runat="server" ID="hlFileName" Text="Download" NavigateUrl='<%# string.Concat("http://feeds.easylist.com.au/", string.Format("{0:yyyy}", Eval("ProcTimeStamp")) , "/inbound/", Eval("UserCode"), "/", Eval("FileName").ToString())%>' Target="_blank" ToolTip='<%# Eval("FileName").ToString() %>' />
            </td>
            <td>
                <%# Eval("FeedSource")%>
            </td>
            <td>
                <asp:Label runat="server" ID="lbProcTimeStamp" Text='<%# Convert.ToDateTime(Eval("ProcTimeStamp")).ToLocalTime().ToString("d MMM yyyy HH:mm:ss") %>' />
            </td>
            <td>
                <asp:Label runat="server" ID="lbTotalLst" Text='<%# Eval("TotalLst")%>' /> 
            </td>
            <td>
                <asp:Label runat="server" ID="lbNewLst" Text='<%# Eval("NewLst")%>' />
            </td>
            <td>
                <asp:Label runat="server" ID="lbUpdatedLst" Text='<%# Eval("UpdatedLst")%>' />
            </td>
            <td>
                <asp:Label runat="server" ID="lbNoChangeLst" Text='<%# Eval("NoChangeLst")%>' />
            </td>
            <td>
                <asp:Label runat="server" ID="lbExpiredLst" Text='<%# Eval("ExpiredLst")%>' />
            </td>
            <td>
                <asp:Label runat="server" ID="lbDraftLst" Text='<%# Eval("DraftLst")%>' />
            </td>
            <td>
                 <asp:Label ID="lbCatId" runat="server" Text='<%# Eval("HotlistId")%>' />
            </td>
            <td>
                <asp:HyperLink ID="hlError" runat="server" Text="view details" NavigateUrl="javascript:void(0);" />
                <asp:Label runat="server" ID="lbNoError" Text="None" Visible="false" />
                <asp:PopupControlExtender ID="pceParent" runat="server"
                TargetControlID="hlError"
                PopupControlID="pnlError"
                Position="Left" OffsetX="-240" OffsetY="-30" />
            </td>          
        </tr>
    </AlternatingItemTemplate>
    <FooterTemplate>
        <asp:Label ID="lblErrorMsg" runat="server" CssClass="errMsg" Text="There are no recent feed history items to display."
            Visible='<%# bool.Parse((rptFeedInLogs.Items.Count == 0).ToString()) %>' style="margin:10px;">
        </asp:Label>
        </tbody></table>
    </FooterTemplate>
</asp:Repeater>

</div>
</ContentTemplate>
</asp:UpdatePanel>


