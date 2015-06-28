<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ListingDetails.ascx.cs" Inherits="TeamUniquemail.Controls.ListingDetails" %>

	<div class="ad-details">							
		<ul class="details-ul">
            <li>
                <asp:Panel ID="pnlErrorMsg" runat="server" CssClas="alert-error" Visible="false">
                    <strong>Error!</strong> <asp:Label runat="server" ID="ExpErrorMsg" />
                </asp:Panel>
                <asp:Panel ID="pnlWarningMsg" runat="server"  CssClass="alert-warning"  Visible="false">
                    <strong>Warning!</strong> <asp:Label runat="server" ID="ExpWarningMsg" />
                </asp:Panel>
            </li>
            <li class="title">
                <h2>
                   <asp:Label runat="server" ID="lbTitle" />
                </h2>
            </li>
            <li><strong><asp:Label runat="server" ID="lbDescriptionSummaryLabel">Summary Description</asp:Label></strong>
                <br />
                <asp:Label runat="server" ID="lbDescriptionSummary" />
            </li>
            <li><strong><asp:Label runat="server" ID="lbDescriptionLabel">Full Description</asp:Label></strong>
                <br />
                <asp:Label runat="server" ID="lbDescription" />
            </li>
             <li><strong><asp:Label runat="server" ID="lbStatusLabel">Status</asp:Label></strong>
                <br />
                <asp:Label runat="server" ID="lbStatus" />
            </li>
            <li><strong><asp:Label runat="server" ID="lbCodeLabel">Code</asp:Label></strong>
                <br />
                <asp:Label runat="server" ID="lbCode" />
            </li>
            <li><strong><asp:Label runat="server" ID="lbStkNoLabel">Stock No</asp:Label></strong>
                <br />
                <asp:Label runat="server" ID="lbStkNo" />
            </li>
            <li><strong><asp:Label runat="server" ID="lbPriceLabel">Price</asp:Label></strong>
                <br />
                <asp:Label runat="server" ID="lbPrice" />
            </li>
            <li>
                <div style="display: block; cursor: pointer; cursor: hand;" onclick='toggles("<%= divAdditions.ClientID %>");'
                    id="divAdditionalInfo">
                    <asp:Image ID="Image1" runat="server" ImageUrl="~/TrustAndSafety/images/Plus.png"
                        Width="10" />
                    <strong>Additional Information</strong></div>
            </li>
            <li>
                <div id="divAdditions" runat="server" style="display: none;">
                    <asp:Label ID="lbAdditionalInformation" runat="server" /></div>
            </li>
            <li><strong>
                <asp:Label runat="server" ID="lbPhotos">Photos</asp:Label></strong><br />				
                <div class="thumbnail_wrapper">
                    <asp:Label ID="lbNoPhotos" runat="server" Visible="false" Style="font-size: small;
                        font-style: italic">no photos</asp:Label>
                    <asp:DataList runat="server" ID="dlImages" RepeatColumns="9" RepeatDirection="Vertical"
                        RepeatLayout="Flow">
                        <ItemTemplate>                            
                            <a href='<%# Eval("FullSizeUrl")%>' class="groupimage">
                                <img src='<%# Eval("ThumbnailUrl")%>' class="thumbnailByPercentage" />
                            </a>
                        </ItemTemplate>
                    </asp:DataList>
                </div>
            </li>
            <li><strong>
                <asp:Label runat="server" ID="lbVideos">Videos</asp:Label></strong><br />
                <div class="thumbnail_wrapper">
                    <asp:Label ID="lbNoVideos" runat="server" Visible="false" Style="font-size: small;
                        font-style: italic">no videos</asp:Label>
                    <asp:DataList runat="server" ID="dlVideos" RepeatColumns="9" RepeatDirection="Vertical"
                        RepeatLayout="Flow">
                        <ItemTemplate>
                            <a href='<%# Eval("VideoPlayerUrl")%>' target="_blank">
                                <img class="thumbnailByPercentage" src='<%# Eval("ThumbnailUrl")%>' /></a>
                        </ItemTemplate>
                    </asp:DataList>
                </div>
            </li>
            <asp:HiddenField ID="LstCode" runat="server" />
        </ul>
    </div>

