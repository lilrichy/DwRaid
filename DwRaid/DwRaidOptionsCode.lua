--Begin Options
 -- Global
 DwRaid_variablesLoaded = false;
   -- for configuration saving
 DwRaidRealm = GetCVar("realmName");
 DwRaidChar = UnitName("player");
   -- default options settings
 local DwRaidConfig_defaultEnabled = true; --Enable or Disable the addon?
 local DwRaidConfig_defaultHideOnCombat = true; -- Hide window when entering combat?
 local DwRaidConfig_defaultShowWhenGrouped = true;	-- Automatically show main frame when entering a group?
 local DwRaidConfig_defaultGroupSizeDisplay  = true; -- Display group size in chat window?
 local DwRaidConfig_defaultLootRulezText  = "Enter your Loot Rulez"; -- Text to be displayed in the Loot Rulez edit Text Box and chat spam.
 local DwRaidConfig_defaultVoiceInfoText  = "Enter your Voice Info: Vent, Mumble, Teamspeak...."; -- Text to be displayed in the Voice Info edit Text Box and chat spam.




function DwRaid_VARIABLES_LOADED()
--Initialize SavedVariable
if DwRaidConfigValues == nil then
DwRaidConfigValues = {};
end
--Initialize Realm and Character Saves
if DwRaidConfigValues[DwRaidRealm] == nil then
DwRaidConfigValues[DwRaidRealm] = {};
end
if DwRaidConfigValues[DwRaidRealm][DwRaidChar]  == nil then
DwRaidConfigValues[DwRaidRealm][DwRaidChar] = {};
end

--Load Options, Set to Default if Missing
if DwRaidConfigValues[DwRaidRealm][DwRaidChar].Enabled == nil then
DwRaidConfigValues[DwRaidRealm][DwRaidChar].Enabled = DwRaidConfig_defaultEnabled;
end
if DwRaidConfigValues[DwRaidRealm][DwRaidChar].HideOnCombat == nil then
DwRaidConfigValues[DwRaidRealm][DwRaidChar].HideOnCombat = DwRaidConfig_defaultHideOnCombat;
end
if DwRaidConfigValues[DwRaidRealm][DwRaidChar].ShowWhenGrouped == nil then
DwRaidConfigValues[DwRaidRealm][DwRaidChar].ShowWhenGrouped = DwRaidConfig_defaultShowWhenGrouped;
end
if DwRaidConfigValues[DwRaidRealm][DwRaidChar].GroupSizeDisplay == nil then
DwRaidConfigValues[DwRaidRealm][DwRaidChar].GroupSizeDisplay = DwRaidConfig_defaultGroupSizeDisplay;
end
if DwRaidConfigValues[DwRaidRealm][DwRaidChar].LootRulezText == nil then
DwRaidConfigValues[DwRaidRealm][DwRaidChar].LootRulezText = DwRaidConfig_defaultLootRulezText;
end
if DwRaidConfigValues[DwRaidRealm][DwRaidChar].VoiceInfoText == nil then
DwRaidConfigValues[DwRaidRealm][DwRaidChar].VoiceInfoText = DwRaidConfig_defaultVoiceInfoText;
end
	
DwRaid_variablesLoaded = true;
DwRaid_ConfigChange();

end




 -- OnShow
 function DwRaidOptionsFrame_OnShow()
        -- read settings and change check buttons
        DwRaidOptionsFrameCheckButtonEnabled:SetChecked(DwRaidConfigValues[DwRaidRealm][DwRaidChar].Enabled);
        DwRaidOptionsFrameCheckButtonHideOnCombat:SetChecked(DwRaidConfigValues[DwRaidRealm][DwRaidChar].HideOnCombat);           
        DwRaidOptionsFrameCheckButtonShowWhenGrouped:SetChecked(DwRaidConfigValues[DwRaidRealm][DwRaidChar].ShowWhenGrouped);
        DwRaidOptionsFrameCheckButtonGroupSizeDisplay:SetChecked(DwRaidConfigValues[DwRaidRealm][DwRaidChar].GroupSizeDisplay);  
		
		--ChatFrame1:AddMessage("Settings read");
		
		DwRaid_ConfigChange();
 end
 
 
 
 
  -- OnClick
 function DwRaidOptionsFrame_OnClick()
      	--Update settings when user changes something
		
        DwRaidConfigValues[DwRaidRealm][DwRaidChar].Enabled = DwRaidOptionsFrameCheckButtonEnabled:GetChecked(); 
		DwRaidConfigValues[DwRaidRealm][DwRaidChar].HideOnCombat = DwRaidOptionsFrameCheckButtonHideOnCombat:GetChecked();
		DwRaidConfigValues[DwRaidRealm][DwRaidChar].ShowWhenGrouped = DwRaidOptionsFrameCheckButtonShowWhenGrouped:GetChecked();
	    DwRaidConfigValues[DwRaidRealm][DwRaidChar].GroupSizeDisplay = DwRaidOptionsFrameCheckButtonGroupSizeDisplay:GetChecked();
       		
		--ChatFrame1:AddMessage("click");
        DwRaid_ConfigChange();
 end
 
 
 
  function DwRaid_ConfigChange()
        if DwRaidConfigValues[DwRaidRealm][DwRaidChar].Enabled then
			--[[ChatFrame1:AddMessage("DwRaid- Enabled, showing main UI!");--]]
			EnableDisable()
			DwRaid_Frame:Show();
        else
            DwRaid_Frame:Hide();
			--[[ChatFrame1:AddMessage("DwRaid- Disabled, hiding main UI!");--]]
			
        end
		
	
		--[[ChatFrame1:AddMessage("DwRaid- Config Change!");--]]
		
 end
 
 
 
 
 -- reset to defaults
 function DwRaid_SetToDefault()
        DwRaidConfigValues[DwRaidRealm][DwRaidChar].Enabled = DwRaidConfig_defaultEnabled;
		DwRaidConfigValues[DwRaidRealm][DwRaidChar].HideOnCombat = DwRaidConfig_defaultHideOnCombat;
		DwRaidConfigValues[DwRaidRealm][DwRaidChar].ShowWhenGrouped = DwRaidConfig_defaultShowWhenGrouped;
		DwRaidConfigValues[DwRaidRealm][DwRaidChar].GroupSizeDisplay = DwRaidConfig_defaultGroupSizeDisplay;
		DwRaidConfigValues[DwRaidRealm][DwRaidChar].LootRulezText = DwRaidConfig_defaultLootRulezText;
		DwRaidConfigValues[DwRaidRealm][DwRaidChar].VoiceInfoText = DwRaidConfig_defaultVoiceInfoText;

        -- Reset the location of the main frame
        DwRaid_Frame:SetPoint("CENTER",0,0);
		DwRaidOptionsFrame:SetPoint("CENTER",0,0);

        DwRaid_ConfigChange();
		DwRaidOptionsFrame_OnShow();
		
		ChatFrame1:AddMessage("DwRaid- Reset to Defualt settings!");
 end

