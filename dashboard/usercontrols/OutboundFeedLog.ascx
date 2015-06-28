<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="OutboundFeedLog.ascx.cs" Inherits="TeamUniquemail.Controls.OutboundFeedLog" %>
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
		<div class="control-group"><asp:Label ID="lbDestination" runat="server" AssociatedControlID="ddlDestination" Text="Destination:" CssClass="control-label" />
		<div class="controls"><asp:DropDownList ID="ddlDestination" runat="server" /></div></div>
		<div class="control-group form-actions"><div class="controls"><asp:Button ID="Search" runat="server" Text="Submit" OnClick="Search_Click" CssClass="btn btn-large" /></div></div>
	</div>
</div>
<div style="overflow-x:auto">
 <asp:Repeater ID="rptFeedOutLogs" runat="server" OnItemDataBound="rptFeedOutLogs_ItemDataBound" EnableViewState="false" >
    <HeaderTemplate>
        <table class="footable footable-loaded default" cellpadding="0" cellspacing="0">
            <thead>
                <tr>                    
                    <th scope="col" width="10%">
                        File
                    </th>
                    <th scope="col" width="11%">
                        Destination
                    </th>
                    <th scope="col" width="23%">
                        Processed
                    </th>                
                    <th scope="col" width="23%">
                         Updated
                    </th>
                    <th scope="col" width="5%">
                        Total
                    </th>
                    <th scope="col" width="5%">
                        Image 
                    </th>
                    <th scope="col" width="10%">
                        User
                    </th>
                    <th scope="col" style="display:none;visibility:hidden">
                        Cat Id
                    </th>
                     <th scope="col" width="5%">
                        Status
                    </th>
                     <th scope="col" width="8%">
                        Alerts
                    </th>
                </tr>
            </thead>
            <tbody>
    </HeaderTemplate>
    <ItemTemplate>
        <tr>           
            <td>
				<asp:Panel ID="pnlError" runat="server" CssClass="popupControl" BorderStyle="Solid" BorderWidth="1px" BorderColor="Orange">
                    <asp:Label runat="server" Text='<%# Eval("ErrorXml")%>' ID="lbError" />
                </asp:Panel>
                <asp:HyperLink runat="server" ID="hlFileName" Text="Download" NavigateUrl='<%# string.Concat("http://feeds.easylist.com.au/", string.Format("{0:yyyy}", Eval("ProcTimeStamp")) , "/outbound/", Eval("FeedSource") , "/" , Eval("FtpUserName"), "/", GetFileName(Eval("FileName").ToString(), (DateTime)Eval("ProcTimeStamp")) )%>' Target="_blank" ToolTip='<%# GetFileName(Eval("FileName").ToString(), (DateTime)Eval("ProcTimeStamp")) %>' />
            </td>
            <td>
               <%# Eval("DestinationDesc")%>
            </td>
            <td>
                <%# Convert.ToDateTime(Eval("ProcTimeStamp")).ToLocalTime().ToString("d MMM yyyy HH:mm:ss") %>
            </td>
             <td>
                <%# Convert.ToDateTime(Eval("LastTimeStamp")).ToLocalTime().ToString("d MMM yyyy HH:mm:ss")%>
            </td>
            <td>
                <%# Eval("TotalLst")%>
            </td>
            <td>
                <%# Eval("ImageLst")%>
            </td>
            <td>
                 <asp:Label ID="lbUserCode" runat="server" Text='<%# Eval("UserCode")%>' />
            </td>
            <td style="display:none;visibility:hidden">
                <asp:Label ID="lbCatId" runat="server" Text='<%# Eval("HotlistId")%>' />
            </td>
               <td>
                <%# Eval("Status")%>
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
				<asp:Panel ID="pnlError" runat="server" CssClass="popupControl" BorderStyle="Solid" BorderWidth="1px" BorderColor="Orange">
                    <asp:Label runat="server" Text='<%# Eval("ErrorXml")%>' ID="lbError" />
                </asp:Panel>
                <asp:HyperLink runat="server" ID="hlFileName" Text="Download" NavigateUrl='<%# string.Concat("http://feeds.easylist.com.au/", string.Format("{0:yyyy}", Eval("ProcTimeStamp")) , "/outbound/", Eval("FeedSource") , "/" , Eval("FtpUserName"), "/", GetFileName(Eval("FileName").ToString(), (DateTime)Eval("ProcTimeStamp")) )%>' Target="_blank" ToolTip='<%# GetFileName(Eval("FileName").ToString(), (DateTime)Eval("ProcTimeStamp")) %>' />
            </td>
            <td>
                <%# Eval("DestinationDesc")%>
            </td>
            <td>
                <%# Convert.ToDateTime(Eval("ProcTimeStamp")).ToLocalTime().ToLocalTime().ToString("d MMM yyyy HH:mm:ss")%>
            </td>
             <td>
                <%# Convert.ToDateTime(Eval("LastTimeStamp")).ToLocalTime().ToLocalTime().ToString("d MMM yyyy HH:mm:ss")%>
            </td>
            <td>
                <%# Eval("TotalLst")%>
            </td>
            <td>
                <%# Eval("ImageLst")%>
            </td>
            <td>
                 <asp:Label ID="lbUserCode" runat="server" Text='<%# Eval("UserCode")%>' />
            </td>
            <td style="display:none;visibility:hidden">
                <asp:Label ID="lbCatId" runat="server" Text='<%# Eval("HotlistId")%>' />
            </td>
               <td>
                <%# Eval("Status")%>
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
            Visible='<%# bool.Parse((rptFeedOutLogs.Items.Count == 0).ToString()) %>' style="margin:10px;">
        </asp:Label>
        </tbody></table>
    </FooterTemplate>
</asp:Repeater>
</div>
</ContentTemplate>
</asp:UpdatePanel>
