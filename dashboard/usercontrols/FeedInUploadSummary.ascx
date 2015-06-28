<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="FeedInUploadSummary.ascx.cs" Inherits="TeamUniquemail.Controls.FeedInUploadSummary" %>
<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script>
<asp:Panel ID="pnlBody" runat="server">
    <fieldset style="margin-top:-45px;">
        <div class="form-left">
            <asp:Panel ID="pnlCatalogue" runat="server" class="control-group">
                <div class="control-group">
                        <asp:Label ID="lblCustAcct" runat="server" Text="Customer Account: " AssociatedControlID="ddlCustAcct" 
                        class="control-label"></asp:Label>
                        <div class="controls"><asp:DropDownList ID="ddlCustAcct" runat="server" OnSelectedIndexChanged="ddlCustAcct_SelectedIndexChanged" AutoPostBack="true" class="value" /></div>
                </div>
                <div class="control-group">
                    <asp:Label ID="lblCatalogue" runat="server" Text="Select Catalog: " AssociatedControlID="ddlCatalogue" class="control-label"></asp:Label>
                    <div class="controls"><asp:DropDownList ID="ddlCatalogue" runat="server" OnSelectedIndexChanged="ddlCatalogue_SelectedIndexChanged" AutoPostBack="true" class="value" /></div>
                </div>
                 <div class="control-group">
                    <asp:Repeater ID="rpSummary" runat="server">
                        <HeaderTemplate>
                            <table class="upload-summary">                              
                        </HeaderTemplate>
                        <ItemTemplate>
                        <tr>
                            <td class="uploadfield"><%# Eval("Key") %></td>
                            <td><%# Eval("Value") == null ? "-" : Eval("Value")%></td>
                        </tr>
                        </ItemTemplate>                          
                        <FooterTemplate>
                            </table>
                        </FooterTemplate>
                    </asp:Repeater>
                </div>                 
                 <div class="control-group"><asp:Label ID="lblError" runat="server" Text="Alerts " class="control-label" style="margin-left:-50px;"></asp:Label></div>
                <asp:Repeater ID="rpError" runat="server">
                    <HeaderTemplate>
                        <table class="failed-upload">  
                        <tr class="failed-upload-header">
                            <th>Stock Number</th>
                            <th>Error Message</th>
                        </tr>                            
                    </HeaderTemplate>
                    <ItemTemplate>
                    <tr>
                        <td><%# Eval("ExCol") %></td>
                        <td><%# Eval("ExMessage") %></td>
                    </tr>
                    </ItemTemplate>                          
                    <FooterTemplate>
                        </table>
                    </FooterTemplate>
                </asp:Repeater>
                <div class="controls" style="margin-top:10px;margin-left:107px;"><asp:Label ID="lblEmptyRow" runat="server" Text="There were no alerts for this upload."></asp:Label></div>
                
            </asp:Panel>
            
        </div>
    </fieldset>
</asp:Panel>
<script type="text/javascript">
    $(function () {
        $("#hlFileName").append(" ").after(GenerateToolTip("Click here to download the last file sent to Easylist Bulk Upload Tool."));
        $("#<%=lblError.ClientID %>").append(GenerateToolTip("Check these errors, these ads are unpublished.  Contact us if you need help.  1800 810 541."));
    })

    function GenerateToolTip(text) {
        return $('<i class="icon-info-2" data-toggle="tooltip" title="" ></i>').attr("data-original-title", text);
    }
</script>