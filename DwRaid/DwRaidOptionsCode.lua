-- Global variables
appName = "|cFF0000FFDwGuild:|r ";
DwRaid_variablesLoaded = false;
DwRaidRealm = GetCVar("realmName");
DwRaidChar = UnitName("player");
 
-- default options settings
local DwRaidConfig_defaultLootRulesText  = "Enter your Loot Rules"; -- Text to be displayed in the Loot Rules edit Text Box and chat spam.
local DwRaidConfig_defaultVoiceInfoText  = "Enter your Voice Info: Vent, Mumble, Teamspeak...."; -- Text to be displayed in the Voice Info edit Text Box and chat spam.

function DwRaid_VARIABLES_LOADED()
--Initialize SavedVariable
	if DwRaidConfigValues == nil then DwRaidConfigValues = {}; end
--Initialize Realm and Character Saves
	if DwRaidConfigValues[DwRaidRealm] == nil then DwRaidConfigValues[DwRaidRealm] = {}; end
	if DwRaidConfigValues[DwRaidRealm][DwRaidChar]  == nil then DwRaidConfigValues[DwRaidRealm][DwRaidChar] = {}; end
--Load Options, Set to Default if Missing
	if DwRaidConfigValues[DwRaidRealm][DwRaidChar].Enabled == nil then DwRaidConfigValues[DwRaidRealm][DwRaidChar].Enabled = true; end--Enable or Disable the addon?
	if DwRaidConfigValues[DwRaidRealm][DwRaidChar].HideOnCombat == nil then DwRaidConfigValues[DwRaidRealm][DwRaidChar].HideOnCombat = true; end-- Hide window when entering combat?
	if DwRaidConfigValues[DwRaidRealm][DwRaidChar].ShowWhenGrouped == nil then DwRaidConfigValues[DwRaidRealm][DwRaidChar].ShowWhenGrouped = true; end-- Automatically show main frame when entering a group?
	if DwRaidConfigValues[DwRaidRealm][DwRaidChar].GroupSizeDisplay == nil then DwRaidConfigValues[DwRaidRealm][DwRaidChar].GroupSizeDisplay = true; end-- Display group size in chat window?
	if DwRaidConfigValues[DwRaidRealm][DwRaidChar].AutoStart == nil then DwRaidConfigValues[DwRaidRealm][DwRaidChar].AutoStart = true; end-- Enable or Disable the addon AutoStarting?
	if DwRaidConfigValues[DwRaidRealm][DwRaidChar].LootRulesText == nil then DwRaidConfigValues[DwRaidRealm][DwRaidChar].LootRulesText = DwRaidConfig_defaultLootRulesText; end
	if DwRaidConfigValues[DwRaidRealm][DwRaidChar].VoiceInfoText == nil then DwRaidConfigValues[DwRaidRealm][DwRaidChar].VoiceInfoText = DwRaidConfig_defaultVoiceInfoText; end
	DwRaid_variablesLoaded = true;
	DwRaid_ConfigChange();
end

function DwRaidOptionsFrame_OnShow()
-- read settings and change check buttons
    DwRaidOptionsFrameCheckButtonEnabled:SetChecked(DwRaidConfigValues[DwRaidRealm][DwRaidChar].Enabled);
    DwRaidOptionsFrameCheckButtonHideOnCombat:SetChecked(DwRaidConfigValues[DwRaidRealm][DwRaidChar].HideOnCombat);           
    DwRaidOptionsFrameCheckButtonShowWhenGrouped:SetChecked(DwRaidConfigValues[DwRaidRealm][DwRaidChar].ShowWhenGrouped);
    DwRaidOptionsFrameCheckButtonGroupSizeDisplay:SetChecked(DwRaidConfigValues[DwRaidRealm][DwRaidChar].GroupSizeDisplay);
	DwRaidOptionsFrameCheckButtonAutoStart:SetChecked(DwRaidConfigValues[DwRaidRealm][DwRaidChar].AutoStart);
	LootRulesTextEditBox:SetText(DwRaidConfigValues[DwRaidRealm][DwRaidChar].LootRulesText);
	VoiceInfoTextEditBox:SetText(DwRaidConfigValues[DwRaidRealm][DwRaidChar].VoiceInfoText);
	--ChatFrame1:AddMessage("Settings read");
	DwRaid_ConfigChange();
end
 
function DwRaidOptionsFrame_OnClick()
--Update settings when user changes something
    DwRaidConfigValues[DwRaidRealm][DwRaidChar].Enabled = DwRaidOptionsFrameCheckButtonEnabled:GetChecked(); 
	DwRaidConfigValues[DwRaidRealm][DwRaidChar].HideOnCombat = DwRaidOptionsFrameCheckButtonHideOnCombat:GetChecked();
	DwRaidConfigValues[DwRaidRealm][DwRaidChar].ShowWhenGrouped = DwRaidOptionsFrameCheckButtonShowWhenGrouped:GetChecked();
	DwRaidConfigValues[DwRaidRealm][DwRaidChar].GroupSizeDisplay = DwRaidOptionsFrameCheckButtonGroupSizeDisplay:GetChecked();
	DwRaidConfigValues[DwRaidRealm][DwRaidChar].AutoStart = DwRaidOptionsFrameCheckButtonAutoStart:GetChecked();
	--ChatFrame1:AddMessage("click");
    DwRaid_ConfigChange();
 end
 
 function LootRulesAcceptBtnClick()
 --Update when click save
	DwRaidConfigValues[DwRaidRealm][DwRaidChar].LootRulesText = LootRulesTextEditBox:GetText();
	DwRaidOptionsLootRulesFrame:Hide();
 end
 
 function VoiceInfoAcceptBtnClick()
 	DwRaidConfigValues[DwRaidRealm][DwRaidChar].VoiceInfoText = VoiceInfoTextEditBox:GetText();
	DwRaidOptionsVoiceInfoFrame:Hide();
 end
 
function DwRaid_ConfigChange()
    if DwRaidConfigValues[DwRaidRealm][DwRaidChar].Enabled then
		--[[
		ChatFrame1:AddMessage("DwRaid- Enabled, showing main UI!");--]]
		EnableDisable()
		DwRaid_Frame:Show();
    else
        DwRaid_Frame:Hide();
		--[[
		ChatFrame1:AddMessage("DwRaid- Disabled, hiding main UI!");--]]
	end
	--[[ChatFrame1:AddMessage("DwRaid- Config Change!");--]]
end
 
-- reset to defaults
function DwRaid_SetToDefault()
    DwRaidConfigValues[DwRaidRealm][DwRaidChar].Enabled = true;
	DwRaidConfigValues[DwRaidRealm][DwRaidChar].HideOnCombat = true;
	DwRaidConfigValues[DwRaidRealm][DwRaidChar].ShowWhenGrouped = true;
	DwRaidConfigValues[DwRaidRealm][DwRaidChar].GroupSizeDisplay = true;
	DwRaidConfigValues[DwRaidRealm][DwRaidChar].AutoStart = true;
	DwRaidConfigValues[DwRaidRealm][DwRaidChar].LootRulesText = DwRaidConfig_defaultLootRulesText;
	DwRaidConfigValues[DwRaidRealm][DwRaidChar].VoiceInfoText = DwRaidConfig_defaultVoiceInfoText;

    -- Reset the location of the main frame
    DwRaid_Frame:SetPoint("CENTER",0,0);
	DwRaidOptionsFrame:SetPoint("CENTER",0,0);
    DwRaid_ConfigChange();
	DwRaidOptionsFrame_OnShow();
	ChatFrame1:AddMessage(appName.. "Settings have been reset to default!");
 end