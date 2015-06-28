<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="FixGeneral.ascx.cs" Inherits="TeamUniquemail.Controls.FixGeneral" %>


<div class="widget-box">
	<div class="widget-content">
        <asp:PlaceHolder ID="phValid" runat="server">
            <div class="AutomotiveListingTemplate">
                <fieldset>
                    <legend>Update the details for 
                        <asp:Label ID="lblCode" runat="server" Text="Label"></asp:Label></legend>
                    <div class="control-group">
			            <div class="controls">
				            <span class="label-header hidden-phone">Current Value</span>
				            <span class="label-header hidden-phone">New Value</span>
			            </div>
		            </div>
                    <div>
                        <asp:Repeater ID="rptProperties" runat="server" OnItemDataBound="rptProperties_ItemDataBound">
                            <ItemTemplate>
                                <div class="control-group">
                                    <label class="control-label"><%#Eval("LabelBefore")%></label>
                                    <asp:Label ID="lblMandatory" runat="server" Text="*" ForeColor="Red"></asp:Label>
                                    <asp:HiddenField ID="hidXMLAttrName" runat="server" />
				                    <div class="controls">                                        
                                        <asp:TextBox ID="txtOriValue" runat="server" ReadOnly="true"></asp:TextBox>
                                        <asp:DropDownList ID="ddlNewValue" runat="server" Visible="false">
                                        </asp:DropDownList>
                                        <asp:CheckBoxList ID="chkNewValues" runat="server" Visible="false">
                                        </asp:CheckBoxList>
				                    </div>
			                    </div>    
                            </ItemTemplate>
                            
                        </asp:Repeater>
                        
                    </div>
                </fieldset>
            </div>
        </asp:PlaceHolder>
        <asp:PlaceHolder ID="phInvalid" runat="server" Visible="false">
            <b>Unable to purify this feed</b>
        </asp:PlaceHolder>
    </div>
</div>