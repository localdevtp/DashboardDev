<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="FixMotorSpec.ascx.cs" Inherits="TeamUniquemail.Controls.FixMotorSpec" %>

<div class="widget-box">
	<div class="widget-content">
			
		<!--<form id ="new-listing" class="form-horizontal break-desktop-large">-->
			<div class="AutomotiveListingTemplate">
					
				<fieldset id="AutomotiveListing">
					<legend>Select your spec</legend>
					<div class="loading-container">
						<div class="control-group">
							<div class="controls">
								<span class="label-header hidden-phone">Current Value</span>
								<span class="label-header hidden-phone">New Value</span>
							</div>
						</div>
							
						<div id="AutomotiveListingEdit">
								
							<div class="control-group">
								<label class="control-label">Make</label>
								<div class="controls">
                                    <asp:TextBox ID="CurrentMake" ReadOnly="true" runat="server"></asp:TextBox>
                                    &nbsp;&nbsp;
                                    <asp:DropDownList ID="easylistMakes" AutoPostBack="True" OnSelectedIndexChanged="EasylistMakes_SelectedIndexChanged" runat="server">
                                         <asp:ListItem Text="Select an option"  Value=""></asp:ListItem>
                                    </asp:DropDownList>
								</div>
							</div>
							<div class="control-group">
								<label class="control-label">Model</label>
								<div class="controls">
                                    <asp:TextBox ID="CurrentModel" ReadOnly="true" runat="server"></asp:TextBox>
                                    &nbsp;&nbsp;
                                    <asp:DropDownList ID="easylistModels" AutoPostBack="True" OnSelectedIndexChanged="EasylistModels_SelectedIndexChanged" runat="server">
                                        <asp:ListItem Text="Select an option"  Value=""></asp:ListItem>
                                    </asp:DropDownList>
								</div>
							</div>
							<div class="control-group"><label class="control-label">Year</label>
								<div class="controls">
                                    <asp:TextBox ID="CurrentYear" ReadOnly="true" runat="server"></asp:TextBox>
                                    &nbsp;&nbsp;
									<asp:DropDownList ID="easylistYear" AutoPostBack="True" OnSelectedIndexChanged="EasylistYear_SelectedIndexChanged" runat="server">
                                        <asp:ListItem Text="Select an option"  Value=""></asp:ListItem>
                                    </asp:DropDownList>
								</div>
							</div>
							<div class="control-group"><label class="control-label">Variant</label>
								<div class="controls">
                                    <asp:TextBox ID="CurrentVariant" ReadOnly="true" runat="server"></asp:TextBox>
                                    &nbsp;&nbsp;
                                    <asp:DropDownList ID="easylistVariant" AutoPostBack="True" OnSelectedIndexChanged="EasylistVariant_SelectedIndexChanged" runat="server">
                                        <asp:ListItem Text="Select an option"  Value=""></asp:ListItem>
                                    </asp:DropDownList>
								</div>
							</div>
								
						</div>
					</div>
				</fieldset>
					
				<fieldset id="UpdateData">
					<legend>Update data</legend>
					<div class="control-group">
						<label class="control-label">New Item Title</label>
						<div class="controls">
                            <asp:TextBox ID="listingTitle" Width="700px" name="listingTitle" runat="server" ReadOnly = "true"></asp:TextBox>
						</div>
					</div>
					<div class="control-group">
						<label class="control-label">Standard Features</label>
						<div class="controls">
							<label class="checkbox">
                                <asp:CheckBox ID="OverwriteStdFeatures" name="stdFeatureOverwrite" runat="server" />
								Overwrite standard features list
							</label>
						</div>
					</div>
					<div class="alert alert-error" id ="ErrMsgDiv" style="display:none;">
						<label id="ErrMsg"/>
					</div>
				</fieldset>
			</div>
				
			<div class="tab-submit">
				<input type="hidden" id="easylist-standard-features"/>
				<input type="hidden" id="easylist-optional-features"/>

                <asp:HiddenField ID="hlistingTitle" runat="server" />
                <asp:HiddenField ID="SelectedNVIC" runat="server" />
			</div>
		<!--</form>-->
	</div>
</div>