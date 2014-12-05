--[[ Downwinds Addons

DwRaid-
A small collection of commands that are useful for a raid leader, grouped together on a simple panel with 
buttons to make setting up and managing raid groups quicker and easier.

--]]

--Register Slash Command to show UI
SLASH_DOWNWIND1 = '/dw';
function SlashCmdList.DOWNWIND(msg, editbox)
 EnableDisable();
 DwRaid_Frame:Show();
end

--Functions that happen when Player Logs in or does Reload
local LogInEventFrame = CreateFrame("Frame")
LogInEventFrame:RegisterEvent("PLAYER_LOGIN")
LogInEventFrame:SetScript("OnEvent", function(self,event,...) 
	EnableDisable();  
	DisableUnused();--Temporary disable buttons
	ChatFrame1:AddMessage("Hello ".. UnitName("Player").. " DwRaid has been Loaded!");
	DwRaid_VARIABLES_LOADED();
	--[[This line should be commented by removing 1 " - " at the start, when not developing. Starts addon UI immediately on login for development 
	DwRaid_Frame:Show();--]]
end)




--Hide the UI when entering Combat
local EnterCombatFrame = CreateFrame("Frame")
EnterCombatFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
EnterCombatFrame:SetScript("OnEvent", function(self,event,...)
	if DwRaidConfigValues[DwRaidRealm][DwRaidChar].HideOnCombat then
		if DwRaid_Frame:IsVisible() then
		DwRaid_Frame:Hide();
		ChatFrame1:AddMessage("DwRaid- Entering Combat, DwRaid is now hidden type /dw to show again.");
		end
		if DwRaidOptionsFrame:IsVisible() then
		DwRaidOptionsFrame:Hide();
		end
	end
	
end)

--Show the UI when Joining a group and update the buttons text
local JoinGroupFrame = CreateFrame("Frame")
JoinGroupFrame:RegisterEvent("GROUP_JOINED")
JoinGroupFrame:SetScript("OnEvent", function(self,event,...)
if DwRaidConfigValues[DwRaidRealm][DwRaidChar].Enabled then
	if DwRaidConfigValues[DwRaidRealm][DwRaidChar].ShowWhenGrouped then
		EnableDisable();
		DwRaid_Frame:Show();
	end
end
end)




--Enable and Disable buttons based on group
function EnableDisable()
local DwRaid_inGroup = IsInGroup();
if DwRaid_inGroup then

DwRaid_FrameButtonRaidPartySwitch:Enable();
DwRaid_FrameButtonLootMethSwitch:Enable();
DwRaid_FrameButtonLootThreshold:Enable();

UpdateLootMethButton();
UpdateLootThresholdButton();
GroupButtonUpdate();

else
DwRaid_FrameButtonRaidPartySwitch:Disable();
DwRaid_FrameButtonRaidPartySwitch:SetText("Convert Group");

DwRaid_FrameButtonLootMethSwitch:Disable();
DwRaid_FrameButtonLootMethSwitch:SetText("Loot Method");

DwRaid_FrameButtonLootThreshold:Disable();
DwRaid_FrameButtonLootThreshold:SetText("Loot Threshold");

end
end

--Update buttons if group size changes
local ButtonGroupFrame = CreateFrame("Frame")
ButtonGroupFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
ButtonGroupFrame:SetScript("OnEvent", function(self,event,...)
EnableDisable();
end)




--Update the Raid / Party Button Text and state
function GroupButtonUpdate()
local DwRaid_GroupSize
local DwRaid_InRaid = IsInRaid();
if DwRaidConfigValues[DwRaidRealm][DwRaidChar].GroupSizeDisplay then
	if DwRaid_GroupSize ~= GetNumGroupMembers() then
		DwRaid_GroupSize = GetNumGroupMembers();
		ChatFrame1:AddMessage("DwRaid- Group Size: ".. DwRaid_GroupSize);
	end
end

if DwRaid_GroupSize <= 5 and DwRaid_InRaid then
DwRaid_FrameButtonRaidPartySwitch:SetText("Make Party");
else 
DwRaid_FrameButtonRaidPartySwitch:SetText("Make Raid");
end
end

--Change button function for Joining a Party or Raid
function SwitchPartyRaid()
local DwRaid_InRaid = IsInRaid();
local DwRaid_inGroup = IsInGroup();
if DwRaid_inGroup then
if DwRaid_InRaid then
ConvertToParty();
GroupButtonUpdate();
ChatFrame1:AddMessage("DwRaid- Converted group to a Party group 5-man");
else 
ConvertToRaid();
GroupButtonUpdate();
ChatFrame1:AddMessage("DwRaid- Converted group to a Raid group");
end
end
end




--Update the Loot Method Button Text and State
function UpdateLootMethButton()
local DwRaid_method = GetLootMethod()

if DwRaid_method == "freeforall" then
DwRaid_FrameButtonLootMethSwitch:SetText("Free 4 All");
end
if DwRaid_method == "group" then
DwRaid_FrameButtonLootMethSwitch:SetText("Group");
end
if DwRaid_method == "master" then
DwRaid_FrameButtonLootMethSwitch:SetText("Master");
end
if DwRaid_method == "needbeforegreed" then
DwRaid_FrameButtonLootMethSwitch:SetText("Need/Greed");
end
if DwRaid_method == "roundrobin" then
DwRaid_FrameButtonLootMethSwitch:SetText("RoundRobin");
end
if DwRaid_method == "personal" then
DwRaid_FrameButtonLootMethSwitch:SetText("personal");
end
end

--Cycle through the Loot Methods and call for Button Update
function CycleLootMeth()
local DwRaid_method = GetLootMethod();

local DwRaid_inGroup = IsInGroup();
if DwRaid_inGroup then

if DwRaid_method == "personal" then
SetLootMethod("group")
end
if DwRaid_method == "group" then
SetLootMethod("master", UnitName("Player"))
end
if DwRaid_method == "master" then
SetLootMethod("needbeforegreed")
end
if DwRaid_method == "needbeforegreed" then
SetLootMethod("roundrobin")
end
if DwRaid_method == "roundrobin" then
SetLootMethod("freeforall")
end
if DwRaid_method == "freeforall" then
SetLootMethod("personal")
end

UpdateLootMethButton();
ChatFrame1:AddMessage("DwRaid- Looting method changed to: ".. method);
end
end




--[[ Loot Threshold Values
2. Uncommon (green)
3. Rare(blue)
4. Epic (purple)
--]]
--Update Loot Threshold Button
function UpdateLootThresholdButton()
local DwRaid_threshold = GetLootThreshold();

if DwRaid_threshold == 2 then
DwRaid_FrameButtonLootThreshold:SetText("Uncommon");
end
if DwRaid_threshold == 3 then
DwRaid_FrameButtonLootThreshold:SetText("Rare");
end
if DwRaid_threshold == 4 then
DwRaid_FrameButtonLootThreshold:SetText("Epic");
end

end

--Cycle through the Loot Thresholds
function CycleLootThreshold()
local DwRaid_threshold = GetLootThreshold();
local DwRaid_inGroup = IsInGroup();
if DwRaid_inGroup then

if DwRaid_threshold == 2 then
SetLootThreshold(3);
ChatFrame1:AddMessage("DwRaid- Loot threshold set to: Rare - Blue quality items!");
end
if DwRaid_threshold == 3 then
SetLootThreshold(4);
ChatFrame1:AddMessage("DwRaid- Loot threshold set to: Epic - Purple quality items!");
end
if DwRaid_threshold == 4 then
SetLootThreshold(2);
ChatFrame1:AddMessage("DwRaid- Loot threshold set to: Uncommon - Green quality items!");
end

UpdateLootThresholdButton();
end
end




--Pull Timer 
function PullTimer()
local PullTime = 10;
local DwRaid_InRaid = IsInRaid();
if DwRaid_InRaid then
SendChatMessage("Starting 10 Second Pull Timer! Get Ready!", "RAID_WARNING");
SendAddonMessage("BigWigs", "T:BWPull "..PullTime, "RAID");
else
SendChatMessage("Starting 10 Second Pull Timer! Get Ready!", "INSTANCE_CHAT"); --INSTANCE_CHAT 
SendAddonMessage("BigWigs", "T:BWPull "..PullTime);
end
end




--Disable unused buttons "Temporary until finished"
function DisableUnused()
DwRaid_FrameButtonVoiceInfo:Disable();
DwRaid_FrameButtonVoiceInfo:Hide();
DwRaid_FrameButtonLootRulez:Disable();
DwRaid_FrameButtonLootRulez:Hide();


end




















