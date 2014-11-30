--Begin Options
 -- Global
 DwUtilities_variablesLoaded = false;
   -- for configuration saving
 DwUtilitiesRealm = GetCVar("realmName");
 DwUtilitiesChar = UnitName("player");
   -- default options settings
 local DwUtilitiesConfig_defaultEnabled = true; --Enable or Disable the addon?
 local DwUtilitiesConfig_defaultHideOnCombat = true; -- Hide window when entering combat?
 local DwUtilitiesConfig_defaultShowWhenGrouped = true;	-- Automatically show main frame when entering a group?
 local DwUtilitiesConfig_defaultGroupSizeDisplay  = true; -- Display group size in chat window?
 local DwUtilitiesConfig_defaultLootRulezText  = "Enter your Loot Rulez"; -- Text to be displayed in the Loot Rulez edit Text Box and chat spam.
 local DwUtilitiesConfig_defaultVoiceInfoText  = "Enter your Voice Info: Vent, Mumble, Teamspeak...."; -- Text to be displayed in the Voice Info edit Text Box and chat spam.




function DwUtilities_VARIABLES_LOADED()
--Initialize SavedVariable
if DwUtilitiesConfigValues == nil then
DwUtilitiesConfigValues = {};
end
--Initialize Realm and Character Saves
if DwUtilitiesConfigValues[DwUtilitiesRealm] == nil then
DwUtilitiesConfigValues[DwUtilitiesRealm] = {};
end
if DwUtilitiesConfigValues[DwUtilitiesRealm][DwUtilitiesChar]  == nil then
DwUtilitiesConfigValues[DwUtilitiesRealm][DwUtilitiesChar] = {};
end

--Load Options, Set to Default if Missing
if DwUtilitiesConfigValues[DwUtilitiesRealm][DwUtilitiesChar].Enabled == nil then
DwUtilitiesConfigValues[DwUtilitiesRealm][DwUtilitiesChar].Enabled = DwUtilitiesConfig_defaultEnabled;
end
if DwUtilitiesConfigValues[DwUtilitiesRealm][DwUtilitiesChar].HideOnCombat == nil then
DwUtilitiesConfigValues[DwUtilitiesRealm][DwUtilitiesChar].HideOnCombat = DwUtilitiesConfig_defaultHideOnCombat;
end
if DwUtilitiesConfigValues[DwUtilitiesRealm][DwUtilitiesChar].ShowWhenGrouped == nil then
DwUtilitiesConfigValues[DwUtilitiesRealm][DwUtilitiesChar].ShowWhenGrouped = DwUtilitiesConfig_defaultShowWhenGrouped;
end
if DwUtilitiesConfigValues[DwUtilitiesRealm][DwUtilitiesChar].GroupSizeDisplay == nil then
DwUtilitiesConfigValues[DwUtilitiesRealm][DwUtilitiesChar].GroupSizeDisplay = DwUtilitiesConfig_defaultGroupSizeDisplay;
end
if DwUtilitiesConfigValues[DwUtilitiesRealm][DwUtilitiesChar].LootRulezText == nil then
DwUtilitiesConfigValues[DwUtilitiesRealm][DwUtilitiesChar].LootRulezText = DwUtilitiesConfig_defaultLootRulezText;
end
if DwUtilitiesConfigValues[DwUtilitiesRealm][DwUtilitiesChar].VoiceInfoText == nil then
DwUtilitiesConfigValues[DwUtilitiesRealm][DwUtilitiesChar].VoiceInfoText = DwUtilitiesConfig_defaultVoiceInfoText;
end
	
DwUtilities_variablesLoaded = true;
DwUtilities_ConfigChange();

end




 -- OnShow
 function DwUtilitiesOptionsFrame_OnShow()
        -- read settings and change check buttons
        DwUtilitiesOptionsFrameCheckButtonEnabled:SetChecked(DwUtilitiesConfigValues[DwUtilitiesRealm][DwUtilitiesChar].Enabled);
        DwUtilitiesOptionsFrameCheckButtonHideOnCombat:SetChecked(DwUtilitiesConfigValues[DwUtilitiesRealm][DwUtilitiesChar].HideOnCombat);           
        DwUtilitiesOptionsFrameCheckButtonShowWhenGrouped:SetChecked(DwUtilitiesConfigValues[DwUtilitiesRealm][DwUtilitiesChar].ShowWhenGrouped);
        DwUtilitiesOptionsFrameCheckButtonGroupSizeDisplay:SetChecked(DwUtilitiesConfigValues[DwUtilitiesRealm][DwUtilitiesChar].GroupSizeDisplay);  
		
		--ChatFrame1:AddMessage("Settings read");
		
		DwUtilities_ConfigChange();
 end
 
 
 
 
  -- OnClick
 function DwUtilitiesOptionsFrame_OnClick()
      	--Update settings when user changes something
		
        DwUtilitiesConfigValues[DwUtilitiesRealm][DwUtilitiesChar].Enabled = DwUtilitiesOptionsFrameCheckButtonEnabled:GetChecked(); 
		DwUtilitiesConfigValues[DwUtilitiesRealm][DwUtilitiesChar].HideOnCombat = DwUtilitiesOptionsFrameCheckButtonHideOnCombat:GetChecked();
		DwUtilitiesConfigValues[DwUtilitiesRealm][DwUtilitiesChar].ShowWhenGrouped = DwUtilitiesOptionsFrameCheckButtonShowWhenGrouped:GetChecked();
	    DwUtilitiesConfigValues[DwUtilitiesRealm][DwUtilitiesChar].GroupSizeDisplay = DwUtilitiesOptionsFrameCheckButtonGroupSizeDisplay:GetChecked();
       		
		--ChatFrame1:AddMessage("click");
        DwUtilities_ConfigChange();
 end
 
 
 
  function DwUtilities_ConfigChange()
        if DwUtilitiesConfigValues[DwUtilitiesRealm][DwUtilitiesChar].Enabled then
			--[[ChatFrame1:AddMessage("DwUtilities- Enabled, showing main UI!");--]]
			EnableDisable()
			DwUtilities_Frame:Show();
        else
            DwUtilities_Frame:Hide();
			--[[ChatFrame1:AddMessage("DwUtilities- Disabled, hiding main UI!");--]]
			
        end
		
	
		--[[ChatFrame1:AddMessage("DwUtilities- Config Change!");--]]
		
 end
 
 
 
 
 -- reset to defaults
 function DwUtilities_SetToDefault()
        DwUtilitiesConfigValues[DwUtilitiesRealm][DwUtilitiesChar].Enabled = DwUtilitiesConfig_defaultEnabled;
		DwUtilitiesConfigValues[DwUtilitiesRealm][DwUtilitiesChar].HideOnCombat = DwUtilitiesConfig_defaultHideOnCombat;
		DwUtilitiesConfigValues[DwUtilitiesRealm][DwUtilitiesChar].ShowWhenGrouped = DwUtilitiesConfig_defaultShowWhenGrouped;
		DwUtilitiesConfigValues[DwUtilitiesRealm][DwUtilitiesChar].GroupSizeDisplay = DwUtilitiesConfig_defaultGroupSizeDisplay;
		DwUtilitiesConfigValues[DwUtilitiesRealm][DwUtilitiesChar].LootRulezText = DwUtilitiesConfig_defaultLootRulezText;
		DwUtilitiesConfigValues[DwUtilitiesRealm][DwUtilitiesChar].VoiceInfoText = DwUtilitiesConfig_defaultVoiceInfoText;

        -- Reset the location of the main frame
        DwUtilities_Frame:SetPoint("CENTER",0,0);
		DwUtilitiesOptionsFrame:SetPoint("CENTER",0,0);

        DwUtilities_ConfigChange();
		DwUtilitiesOptionsFrame_OnShow();
		
		ChatFrame1:AddMessage("DwUtilities- Reset to Defualt settings!");
 end

