<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ListingResultDetails.ascx.cs" Inherits="TeamUniquemail.Controls.ListingResultDetails" %>
<%--<%@ Register Src="ListPager.ascx" TagName="ListPager" TagPrefix="uc1" %>--%>

<div id="search_result">	
    <div style="height:3px;"></div>

    <span class="total-wrapper" >
        <%--<asp:Label ID="FilterLabel" runat="server" Text="; Filter : "></asp:Label>--%>
        <asp:Label ID="FilterBy" runat="server" Text="" Visible="false"></asp:Label>
    </span>

    <asp:Button ID="btnRefresh" runat="server" Text="Refresh" 
        onclick="btnRefresh_Click" Visible = "false" />

    <asp:Panel ID="pnlAccountAndCatalogueFilter" runat="server" class="control-group">
     <div class="form-left">
            <div class="control-group">
                <asp:Label ID="lblCustAcct" runat="server" Text="Customer Account: " AssociatedControlID="ddlCustAcct" class="control-label" style = "float:left"></asp:Label>
                <div class="controls">
                    <asp:DropDownList ID="ddlCustAcct" runat="server" OnSelectedIndexChanged="ddlCustAcct_SelectedIndexChanged" AutoPostBack="true" class="CustAccount" ClientIDMode ="Static" />
                 </div>
				 
            </div>
            <div class="control-group">
                <asp:Label ID="lblCatalogue" runat="server" Text="Select Catalog: " AssociatedControlID="ddlCatalogue" class="control-label" style = "float:left"></asp:Label>
                <div class="controls">
                    <asp:DropDownList ID="ddlCatalogue" runat="server" OnSelectedIndexChanged="ddlCatalogue_SelectedIndexChanged" AutoPostBack="true" class="CustCatalog" ClientIDMode ="Static"/>
                    <asp:Label ID="EmptyCatalogLabel" runat="server" 
                        Text="No Catalog and default file format template defined!" ForeColor="#FF3300" 
                        Visible="False"></asp:Label>
                 </div>
            </div>
        </div>
    </asp:Panel>

     <span class="total-wrapper" >
        <asp:Label ID="TotalResultCountLabel" runat="server" Text=""></asp:Label>
    </span>
    <div style="overflow-y: hidden; overflow-x: scroll;">
        <asp:GridView ID="gvListingsData" runat="server" 
            AutoGenerateColumns="false"  
            AutoPostBack="True" 
            CssClass ="result-table"
            OnRowCommand="gvListingsData_RowCommand"
            OnPreRender = "gvListingsData_PreRender" 
            ShowHeaderWhenEmpty="true"  
            GridLines = "None"
            OnRowDataBound = "gvListingsData_RowDataBound">
            <HeaderStyle CssClass = "result-table-first-column" />
            <RowStyle VerticalAlign="Top" />
        </asp:GridView>
    </div>
   <%-- <div class="pagination">
     <uc1:ListPager ID="gvListingsDataPagination" PageSize="50" runat="server" EnableViewState="false" />
    </div>--%>
        
    <asp:HiddenField ID="CurrentRow" runat="server" />
    <asp:HiddenField ID="CurrentLstCode" runat="server" />
</div>

