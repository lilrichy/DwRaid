--[[ Downwinds Addons

DwRaid-
A small collection of commands that are useful for a raid leader, grouped together on a simple panel with 
buttons to make setting up and managing raid groups quicker and easier.

--]]

--Global Variables 
local appName = "|cFF0000FFDwRaid:|r ";

local DwRaid = CreateFrame("FRAME")
DwRaid:RegisterEvent("ADDON_LOADED")
DwRaid:RegisterEvent("PLAYER_LOGIN")
DwRaid:RegisterEvent("PLAYER_REGEN_DISABLED")
--DwRaid:RegisterEvent("PLAYER_REGEN_ENABLED")
DwRaid:RegisterEvent("GROUP_JOINED")
DwRaid:RegisterEvent("GROUP_ROSTER_UPDATE")

function DwRaid:OnEvent(event,arg1,...)
	if (event == "ADDON_LOADED" and arg1 == "DwRaid") then
		
		DwRaid:UnregisterEvent("ADDON_LOADED")
		DwRaid_VARIABLES_LOADED();
		
--Functions that happen when Player Logs in or does Reload		
	elseif (event == "PLAYER_LOGIN") then
		EnableDisable();  
		ChatFrame1:AddMessage("Hello ".. UnitName("Player").. " DwRaid has been Loaded!");
		--[[This line should be commented by removing 1 " - " at the start, when not developing. Starts addon UI immediately on login for development 
		DwRaid_Frame:Show();--]]

--Hide the UI when entering Combat
	elseif (event == "PLAYER_REGEN_DISABLED") then
		if DwRaidConfigValues[DwRaidRealm][DwRaidChar].HideOnCombat then
			if DwRaid_Frame:IsVisible() then
				DwRaid_Frame:Hide();
				ChatFrame1:AddMessage(appName.. "Entering Combat, DwRaid is now hidden type /DW to show again.");
			end
			if DwRaidOptionsFrame:IsVisible() then
				DwRaidOptionsFrame:Hide();
			end
		end
--[[Show when not in Combat
	elseif (event == "PLAYER_REGEN_ENABLED") then
		if DwRaidConfigValues[DwRaidRealm][DwRaidChar].AutoStart then
			DwRaid_Frame:Show();
			print(appName.."Not in combat")
		end--]]

--Show the UI when Joining a group and update the buttons text
	elseif (event == "GROUP_JOINED") then
		if DwRaidConfigValues[DwRaidRealm][DwRaidChar].Enabled then
			if DwRaidConfigValues[DwRaidRealm][DwRaidChar].ShowWhenGrouped then
				EnableDisable();
				DwRaid_Frame:Show();
			end
		end
		
--Update buttons if group size changes
	elseif (event == "GROUP_ROSTER_UPDATE") then
		EnableDisable();
	end
	
--[[Handle AutoStart
	if DwRaidConfigValues[DwRaidRealm][DwRaidChar].AutoStart then
		DwRaid_Frame:Show();
	end--]]
end
DwRaid:SetScript("OnEvent", DwRaid.OnEvent);

--Register Slash Command to show UI
SLASH_DOWNWIND1 = "/DWR";
SLASH_DOWNWIND2 = "/DwRaid";
SLASH_DOWNWIND3 = "/DW";
function SlashCmdList.DOWNWIND(msg, editbox)
 EnableDisable();
 DwRaid_Frame:Show();
end
	
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

--Update the Raid / Party Button Text and state
function GroupButtonUpdate()
local DwRaid_GroupSize
local DwRaid_InRaid = IsInRaid();
	if DwRaidConfigValues[DwRaidRealm][DwRaidChar].GroupSizeDisplay then
		if DwRaid_GroupSize ~= GetNumGroupMembers() then
			DwRaid_GroupSize = GetNumGroupMembers();
			ChatFrame1:AddMessage(appName.. "Group Size: ".. DwRaid_GroupSize);
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
			ChatFrame1:AddMessage(appName.. "Converted group to a Party group 5-man");
		else 
			ConvertToRaid();
			GroupButtonUpdate();
			ChatFrame1:AddMessage(appName.. "Converted group to a Raid group");
		end
	end
end

--Update the Loot Method Button Text and State
function UpdateLootMethButton()
	if GetLootMethod() == "freeforall" then	DwRaid_FrameButtonLootMethSwitch:SetText("Free 4 All");
	elseif GetLootMethod() == "group" then DwRaid_FrameButtonLootMethSwitch:SetText("Group");
	elseif GetLootMethod() == "master" then	DwRaid_FrameButtonLootMethSwitch:SetText("Master");
	elseif GetLootMethod() == "needbeforegreed" then DwRaid_FrameButtonLootMethSwitch:SetText("Need/Greed");
	elseif GetLootMethod() == "roundrobin" then	DwRaid_FrameButtonLootMethSwitch:SetText("RoundRobin");
	elseif GetLootMethod() == "personalloot" then DwRaid_FrameButtonLootMethSwitch:SetText("Personal");
	end
end

--Cycle through the Loot Methods and call for Button Update
function CycleLootMeth()
	if IsInGroup() then
		if GetLootMethod() == "personalloot" then SetLootMethod("group");
		elseif GetLootMethod() == "group" then SetLootMethod("master", UnitName("Player"));
		elseif GetLootMethod() == "master" then SetLootMethod("needbeforegreed");
		elseif GetLootMethod() == "needbeforegreed" then SetLootMethod("roundrobin");
		elseif GetLootMethod() == "roundrobin" then SetLootMethod("freeforall");
		elseif GetLootMethod() == "freeforall" then SetLootMethod("personalloot");
		end
	end
	UpdateLootMethButton();
	ChatFrame1:AddMessage(appName.. "Looting method changed to: ".. GetLootMethod());
end

--Update Loot Threshold Button
function UpdateLootThresholdButton()
	if GetLootThreshold() == 2 then DwRaid_FrameButtonLootThreshold:SetText("Uncommon");
	elseif GetLootThreshold() == 3 then DwRaid_FrameButtonLootThreshold:SetText("Rare");
	elseif GetLootThreshold() == 4 then DwRaid_FrameButtonLootThreshold:SetText("Epic");
	end
end

--Cycle through the Loot Thresholds
function CycleLootThreshold()
	if IsInGroup() then
		if GetLootThreshold() == 2 then
			SetLootThreshold(3);
			ChatFrame1:AddMessage(appName.. "Loot threshold set to: Rare - Blue quality items!");
		elseif GetLootThreshold() == 3 then
			SetLootThreshold(4);
			ChatFrame1:AddMessage(appName.. "Loot threshold set to: Epic - Purple quality items!");
		elseif GetLootThreshold() == 4 then
			SetLootThreshold(2);
			ChatFrame1:AddMessage(appName.. "Loot threshold set to: Uncommon - Green quality items!");
		end
	end
	UpdateLootThresholdButton();
end

--Pull Timer 
function PullTimer()
local PullTime = 10;
	if IsInRaid() then
		SendChatMessage("Starting 10 Second Pull Timer! Get Ready!", "RAID_WARNING");
		SendAddonMessage("BigWigs", "T:BWPull "..PullTime, "RAID");
		
	else
		SendChatMessage("Starting 10 Second Pull Timer! Get Ready!", "Yell"); --INSTANCE_CHAT should change to instance when go live ?or maybe an option?
		SendAddonMessage("BigWigs", "T:BWPull "..PullTime);
	end
end

function LootRulesChatSend()
	if DwRaidConfigValues[DwRaidRealm][DwRaidChar].LootRulesText ~= DwRaidConfig_defaultLootRulesText then
		if IsInRaid() then
			SendChatMessage(DwRaidConfigValues[DwRaidRealm][DwRaidChar].LootRulesText, "RAID");
		elseif IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
			SendChatMessage(DwRaidConfigValues[DwRaidRealm][DwRaidChar].LootRulesText, "INSTANCE_CHAT");
		elseif IsInGroup() then
			SendChatMessage(DwRaidConfigValues[DwRaidRealm][DwRaidChar].LootRulesText, "PARTY");
		else
			print(appName.. "You are not in a group!");
			
		end
	else
		print(appName.. "Loot Rules are not set up! Please click options to set Loot Rules chat text.")
	end
end

function VoiceInfoChatSend()

	if DwRaidConfigValues[DwRaidRealm][DwRaidChar].VoiceInfoText ~= DwRaidConfig_defaultVoiceInfoText then
		if IsInRaid() then
			SendChatMessage(DwRaidConfigValues[DwRaidRealm][DwRaidChar].VoiceInfoText, "RAID");
		elseif IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
			SendChatMessage(DwRaidConfigValues[DwRaidRealm][DwRaidChar].VoiceInfoText, "INSTANCE_CHAT");
		elseif IsInGroup() then
			SendChatMessage(DwRaidConfigValues[DwRaidRealm][DwRaidChar].VoiceInfoText, "PARTY");
		else
			print(appName.. "You are not in a group!");
			--print(appName.. "Testing: ".. DwRaidConfigValues[DwRaidRealm][DwRaidChar].VoiceInfoText);
			--SendChatMessage(text, "SAY");
		end
	else
		print(appName.. "Voice Info is not set up! Please click options to set Voice Info chat text.");
	end
end