--
-- Created by IntelliJ IDEA.
-- User: Spandauerin
-- Date: 20.10.19
-- Time: 17:04
-- To change this template use File | Settings | File Templates.
--

function Spandau:UNIT_TARGET(_event,unitID)
    local targetFaction = select(1,UnitFactionGroup("target"))
    local playerFaction = select(1,UnitFactionGroup("player"))
    --and targetFaction ~= playerFaction
    if unitID == "player" and UnitExists("target") and targetFaction ~= playerFaction and UnitIsPlayer("target") then
        for i = 1, #UnitPopupMenus["PLAYER"] do
            if UnitPopupMenus["PLAYER"][i] == "ADD_BLIST" then
                tremove(UnitPopupMenus["PLAYER"], i)
            end
        end
        tinsert(UnitPopupMenus["PLAYER"], #UnitPopupMenus["PLAYER"] - 1, "ADD_BLIST")
    end
end

function Spandau:NAME_PLATE_UNIT_REMOVED(_event,unitID)

    local nameplate = C_NamePlate.GetNamePlateForUnit(unitID)
    if nameplate.myIndicator then
        nameplate.myIndicator:Hide()
    end

end

function Spandau:NAME_PLATE_UNIT_ADDED(event,unitID)
    local playerName = UnitName(unitID);
    if DB.DeathList:playerIsInDeathList(playerName) then
        local nameplate = C_NamePlate.GetNamePlateForUnit(unitID)
        nameplate.myIndicator = nameplate:CreateTexture(nil, "OVERLAY")
        nameplate.myIndicator:SetTexture(Spandau.confs.deathIcon)
        nameplate.myIndicator:SetSize(25,25)
        nameplate.myIndicator:SetPoint("TOP", 40, 15) -- horizontal, vertical
    end

end


function Spandau:PLAYER_TARGET_CHANGED()
    local name = UnitName("target");
    if name and DB.DeathList:playerIsInDeathList(name) then
        if Totenkopf then
            Totenkopf:Show()
        else
            local icon = TargetFrame:CreateTexture("Totenkopf", "OVERLAY")
            icon:SetTexture(Spandau.confs.deathIcon)
            icon:SetSize(25,25)
            icon:SetPoint("TOP", 10, 0)
        end
    elseif Totenkopf then
        Totenkopf:Hide()
    end

end
function Spandau:UPDATE_DEATHLIST()
    Spandau:PLAYER_TARGET_CHANGED()
    Spandau:NAME_PLATE_UNIT_ADDED(".", "target")
end

local function addPlayerToDeathList()
    local targetName = UnitName("target");
    local entry = Utils:createDeathListEntryFromName(targetName)
    if DB.DeathList:addPlayerToDeathList(entry) then
        Spandau:SendMessage("UPDATE_DEATHLIST")
        Spandau:broadcastNewPlayerDeathlist(entry)
    end
end

UnitPopupButtons["ADD_BLIST"] = {
    text = "Auf die Todesliste",
    func = addPlayerToDeathList
}


function Spandau:UnitPopup_ShowMenu(dropdownMenu, which, unit, name, userData, ...)
    for i=1, UIDROPDOWNMENU_MAXBUTTONS do
        local button = _G["DropDownList"..UIDROPDOWNMENU_MENU_LEVEL.."Button"..i];
        if button.value and button.value == "ADD_BLIST" then
            button.func = UnitPopupButtons["ADD_BLIST"].func
        end
    end
end

