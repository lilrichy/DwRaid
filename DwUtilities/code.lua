
--[[ Downwinds Addon Utilities

A small collection of commands that are useful for a raid leader, grouped together on a simple panel with 
buttons to make setting up and managing raid groups quicker and easier.--]]

--Register Slash Command to show UI
SLASH_DOWNWIND1 = '/dw';
function SlashCmdList.DOWNWIND(msg, editbox)
 GroupButtonUpdate();
 UpdateLootMethButton();
 DwUtilities_Frame:Show();
end

--Functions that happen when Player Logs in or does Reload
local LogInEventFrame = CreateFrame("Frame")
LogInEventFrame:RegisterEvent("ADDON_LOADED")
LogInEventFrame:SetScript("OnEvent", function(self,event,...) 
	EnableDisable();
	
    ChatFrame1:AddMessage("Hello ".. UnitName("Player").. " DwUtilities has been Loaded!");

	--[[This line should be commented by removing 1 " - " at the start, when not developing. Starts addon UI immediately on login for development 
	DwUtilities_Frame:Show();--]]
	DisableUnused();--Temporary disable buttons
	
end)




--Hide the UI when entering Combat
local EnterCombatFrame = CreateFrame("Frame")
EnterCombatFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
EnterCombatFrame:SetScript("OnEvent", function(self,event,...)
DwUtilities_Frame:Hide();
--ChatFrame1:AddMessage("Entering Combat, DwUtilities is now hidden type /dw to show again.");
end)

--Show the UI when Joining a group and update the buttons text
local JoinGroupFrame = CreateFrame("Frame")
JoinGroupFrame:RegisterEvent("GROUP_JOINED")
JoinGroupFrame:SetScript("OnEvent", function(self,event,...)
	EnableDisable();
DwUtilities_Frame:Show();
end)






--Enable and Disable buttons based on group
function EnableDisable()
local DwUtilities_inGroup = IsInGroup();
if DwUtilities_inGroup then

DwUtilities_FrameButtonRaidPartySwitch:Enable();
DwUtilities_FrameButtonLootMethSwitch:Enable();
DwUtilities_FrameButtonLootThreshold:Enable();

UpdateLootMethButton();
UpdateLootThresholdButton();
GroupButtonUpdate();

else
DwUtilities_FrameButtonRaidPartySwitch:Disable();
DwUtilities_FrameButtonRaidPartySwitch:SetText("Convert Group");

DwUtilities_FrameButtonLootMethSwitch:Disable();
DwUtilities_FrameButtonLootMethSwitch:SetText("Loot Method");

DwUtilities_FrameButtonLootThreshold:Disable();
DwUtilities_FrameButtonLootThreshold:SetText("Loot Threshold");

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
local DwUtilities_GroupSize = GetNumGroupMembers();
local DwUtilities_InRaid = IsInRaid();
ChatFrame1:AddMessage("DwUtilities- Group Size: ".. DwUtilities_GroupSize);

if DwUtilities_GroupSize <= 5 and DwUtilities_InRaid then
DwUtilities_FrameButtonRaidPartySwitch:SetText("Convert to Party");
else 
DwUtilities_FrameButtonRaidPartySwitch:SetText("Convert to Raid");
end
end

--Change button function for Joining a Party or Raid
function SwitchPartyRaid()
local DwUtilities_InRaid = IsInRaid();
local DwUtilities_inGroup = IsInGroup();
if DwUtilities_inGroup then
if DwUtilities_InRaid then
ConvertToParty();
GroupButtonUpdate();
ChatFrame1:AddMessage("DwUtilities- Converted group to a Party group 5-man");
else 
ConvertToRaid();
GroupButtonUpdate();
ChatFrame1:AddMessage("DwUtilities- Converted group to a Raid group");
end
end
end




--Update the Loot Method Button Text and State
function UpdateLootMethButton()
local DwUtilities_method = GetLootMethod()

if DwUtilities_method == "freeforall" then
DwUtilities_FrameButtonLootMethSwitch:SetText("Free 4 All");
end
if DwUtilities_method == "group" then
DwUtilities_FrameButtonLootMethSwitch:SetText("Group");
end
if DwUtilities_method == "master" then
DwUtilities_FrameButtonLootMethSwitch:SetText("Master");
end
if DwUtilities_method == "needbeforegreed" then
DwUtilities_FrameButtonLootMethSwitch:SetText("Need/Greed");
end
if DwUtilities_method == "roundrobin" then
DwUtilities_FrameButtonLootMethSwitch:SetText("RoundRobin");
end
end

--Cycle through the Loot Methods and call for Button Update
function CycleLootMeth()
local DwUtilities_method = GetLootMethod();

local DwUtilities_inGroup = IsInGroup();
if DwUtilities_inGroup then

if DwUtilities_method == "freeforall" then
SetLootMethod("group")
end
if DwUtilities_method == "group" then
SetLootMethod("master", UnitName("Player"))
end
if DwUtilities_method == "master" then
SetLootMethod("needbeforegreed")
end
if DwUtilities_method == "needbeforegreed" then
SetLootMethod("roundrobin")
end
if DwUtilities_method == "roundrobin" then
SetLootMethod("freeforall")
end

UpdateLootMethButton();
ChatFrame1:AddMessage("DwUtilities- Looting method changed to: ".. method);
end
end




--[[ Loot Threshold Values
2. Uncommon (green)
3. Rare(blue)
4. Epic (purple)
--]]
--Update Loot Threshold Button
function UpdateLootThresholdButton()
local DwUtilities_threshold = GetLootThreshold();

if DwUtilities_threshold == 2 then
DwUtilities_FrameButtonLootThreshold:SetText("Uncommon");
end
if DwUtilities_threshold == 3 then
DwUtilities_FrameButtonLootThreshold:SetText("Rare");
end
if DwUtilities_threshold == 4 then
DwUtilities_FrameButtonLootThreshold:SetText("Epic");
end

end

--Cycle through the Loot Thresholds
function CycleLootThreshold()
local DwUtilities_threshold = GetLootThreshold();
local DwUtilities_inGroup = IsInGroup();
if DwUtilities_inGroup then

if DwUtilities_threshold == 2 then
SetLootThreshold(3);
ChatFrame1:AddMessage("DwUtilities- Loot threshold set to: Rare - Blue quality items!");
end
if DwUtilities_threshold == 3 then
SetLootThreshold(4);
ChatFrame1:AddMessage("DwUtilities- Loot threshold set to: Epic - Purple quality items!");
end
if DwUtilities_threshold == 4 then
SetLootThreshold(2);
ChatFrame1:AddMessage("DwUtilities- Loot threshold set to: Uncommon - Green quality items!");
end

UpdateLootThresholdButton();
end
end




--Pull Timer 
function PullTimer()
local PullTime = 10;
local DwUtilities_InRaid = IsInRaid();
if DwUtilities_InRaid then
SendChatMessage("Starting 10 Second Pull Timer! Get Ready!", "RAID_WARNING");
SendAddonMessage("BigWigs", "T:BWPull "..PullTime);
else
SendChatMessage("Starting 10 Second Pull Timer! Get Ready!", "Yell"); --INSTANCE_CHAT should change to instance when go live ?or maybe an option?
SendAddonMessage("BigWigs", "T:BWPull "..PullTime);
end
end




--Disable unused buttons "Temporary until finished"
function DisableUnused()
DwUtilities_FrameButtonOptions:Disable();
DwUtilities_FrameButtonVoiceInfo:Disable();
DwUtilities_FrameButtonLootRulez:Disable();

end













