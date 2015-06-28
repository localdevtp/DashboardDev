<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="EasyListFixSpecCtrl.ascx.cs" Inherits="TeamUniquemail.Controls.EasyListFixSpecCtrl" %>

<%@ Register Assembly="TeamUniquemail" Namespace="TeamUniquemail.Controls" TagPrefix="cc1" %>

<%@ Register src="FixVehicleSpec.ascx" tagname="FixVehicleSpec" tagprefix="ucFix" %>
<%@ Register src="FixMotorSpec.ascx" tagname="FixMotorSpec" tagprefix="ucFix" %>
<%@ Register src="FixGeneral.ascx" tagname="FixGeneral" tagprefix="ucFix" %>

<asp:HiddenField ID="hdListingCode" runat="server" />
<asp:HiddenField ID="hdUserName" runat="server" />

<ucFix:FixVehicleSpec ID="FixVehicleSpecCtrl" runat="server"/>
<ucFix:FixMotorSpec ID="FixMotorSpecCtrl" runat="server" />
<ucFix:FixGeneral ID="ucFixGeneral" runat="server" />

<br />
<div align="center">
    <asp:Button ID="btnConfirm" runat="server" Text="Confirm" 
        onclick="btnConfirm_Click" CssClass="btn btn-info push-bottom" />&nbsp;

    <asp:Button ID="btnCancel" CssClass="btn btn-danger push-bottom" runat="server" 
            Text="Close" OnClientClick="parent.CancelPopup();" onclick="btnCancel_Click" />

    <cc1:MessageControl ID="MessageControl" runat="server" />

</div>