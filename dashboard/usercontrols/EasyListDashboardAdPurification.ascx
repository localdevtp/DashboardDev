<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="EasyListDashboardAdPurification.ascx.cs" Inherits="TeamUniquemail.Controls.EasyListDashboardAdPurification" %>

<%@ Register src="ListingResultDetails.ascx" tagname="ListingResultDetails" tagprefix="ELControls1" %>
<%@ Register src="FixVehicleSpec.ascx" tagname="FixVehicleSpec" tagprefix="ELControls2" %>
<%@ Register src="FixMotorSpec.ascx" tagname="FixMotorSpec" tagprefix="ELControls3" %>

<script type="text/javascript">
    function ShowFixCarSpec() {
//        $('#FixCarSpec').show();
        document.getElementById("FixCarSpec").style.display = "block";
    }

    function ShowFixMotorSpec() {
//        $('#FixMotorSpec').show();
        document.getElementById("FixMotorSpec").style.display = "block";
    }
</script>

<div id="mainContainer">
    <ELControls1:ListingResultDetails ID="ListingResultDetails"  runat="server"  AutoPostBack="True" 
        PageNo = "1" 
        PageSize ="20" 
        DataFieldList = "FeedInExceptionType|Code|StockNumber|Year|Make|Model|Title|Price|Category" 
        HeaderTextList = "|Code|Stock No|Year|Make|Model|Title|Price|Category" 
        LstTypeList = "Car,Motorcycle"
        OnListingsChanged = "ListingResultDetails_ListingsChanged"
    />

    <div id="FixCarSpec" style = "display:none;">
        <ELControls2:FixVehicleSpec ID="FixVehicleSpecCtrl" runat="server"/>
    </div>
    <div id="FixMotorSpec" style = "display:none;">
        <ELControls3:FixMotorSpec ID="FixMotorSpecCtrl" runat="server"/>
    </div>

</div>