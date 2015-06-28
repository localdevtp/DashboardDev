<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="CountryRegionPostcodeDisplayAdd.ascx.cs"
Inherits="EasyList.Web.CustomControl.CountryRegionPostcodeDisplayAdd" %>

<%--<asp:TextBox ID="txtCountry" runat="server"></asp:TextBox>--%>

<asp:HiddenField ID="FieldCountryCode" runat="server" />
<asp:HiddenField ID="FieldCountryName" runat="server" />
<asp:HiddenField ID="FieldRegionName" runat="server" />
<asp:HiddenField ID="FieldRegionID" runat="server" />
<asp:HiddenField ID="FieldPostCode" runat="server" />
<asp:HiddenField ID="FieldDistrict" runat="server" />

<div class="control-group clear">
    <asp:Label ID="LabelCountry" runat="server" Text="Country" 
      AssociatedControlID="DropDownListCountry" class="control-label"></asp:Label>
      <div class="controls">
            <asp:DropDownList ID="DropDownListCountry" runat="server" Width="205px" 
              AutoPostBack="True" 
              OnSelectedIndexChanged="DropDownListCountry_SelectedIndexChanged" 
              class="drop-down add-display-country">
            </asp:DropDownList>
       </div>
</div>

<asp:Panel ID="PanelRegion" runat="server">

<div class="control-group clear">
    <asp:Label ID="LabelRegion" runat="server" Text="Region" AssociatedControlID="DropDownListRegion" class="control-label"></asp:Label>
    <div class="controls">
            <asp:DropDownList ID="DropDownListRegion" runat="server" class="drop-down add-display-region"
              Width="205px" AutoPostBack="True" 
              onselectedindexchanged="DropDownListRegion_SelectedIndexChanged"></asp:DropDownList>
            <%--<asp:RangeValidator ID="rv1" runat="server" 
              ControlToValidate="DropDownListRegion" ErrorMessage="Please select a region." 
              MaximumValue="999999999" MinimumValue="1" CssClass="form-validator"></asp:RangeValidator>--%>
    </div>
</div>
</asp:Panel>

<asp:Panel ID="PanelPostCode" runat="server">
    <div class="control-group clear">
    <asp:Label ID="LabelPostCode" runat="server" Text="Post Code" 
      AssociatedControlID="TextBoxPostCode" class="control-label"></asp:Label>
      <div class="controls">
            <asp:TextBox ID="TextBoxPostCode" runat="server" MaxLength="15"  class="input-xlarge add-display-postalcode" 
              AutoCompleteType="BusinessZipCode"
              AutoPostBack="True" ontextchanged="TextBoxPostCode_TextChanged"></asp:TextBox>
            <%--<asp:RequiredFieldValidator ID="rf1" runat="server" 
              ControlToValidate="TextBoxPostCode" ErrorMessage="Please enter a postal code." 
              CssClass="form-validator"></asp:RequiredFieldValidator>--%>
        </div>
    </div>
</asp:Panel>

<asp:Panel ID="PanelSuburb" runat="server">
    <div class="control-group clear">
        <asp:Label ID="LabelSuburb" runat="server" Text="Suburb/District" 
          class="control-label"></asp:Label>
        <div class="controls">

            <asp:DropDownList ID="ListDistrict" runat="server" class="drop-down add-display-district-dropdown" 
              DataTextField="District" DataValueField="ID" Visible="False" Width="205px">
            </asp:DropDownList>

            <asp:TextBox ID="TextDistrict" class="input-xlarge add-display-district" runat="server"></asp:TextBox>

             <%--<asp:RangeValidator ID="rv2" runat="server" ControlToValidate="ListDistrict" 
              CssClass="form-validator" Display="Dynamic" Enabled="False" 
              ErrorMessage="Please select a district." MaximumValue="999999999" 
              MinimumValue="1"></asp:RangeValidator>
             <asp:RequiredFieldValidator ID="rf2" runat="server" 
              ControlToValidate="TextDistrict" CssClass="form-validator" Display="Dynamic" 
              ErrorMessage="Please enter a suburb/district."></asp:RequiredFieldValidator>--%>

       </div>
    </div>
</asp:Panel>

