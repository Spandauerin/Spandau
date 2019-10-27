Spandau = LibStub("AceAddon-3.0"):NewAddon("Spandau", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0", "AceComm-3.0")
Utils = {}
DB = {}
function Spandau:OnInitialize()
    Spandau:Print("Initialisiert!")
  -- Code that you want to run when the addon is first loaded goes here.
    self.db = LibStub("AceDB-3.0"):New("SpandauDB")

    if not self.db.char.name then
        self.db.char.name = UnitName("player");
    end
    if not self.db.char.isBankChar then
        BankCharQuestion:Show()
    end
    if not self.db.realm.bankItems then
        self.db.realm.bankItems = {};
    end

    if not self.db.char.deathList then
        self.db.char.deathList = {}
    end

    Spandau:RegisterEvent("UNIT_TARGET")
    Spandau:RegisterEvent("NAME_PLATE_UNIT_REMOVED")
    Spandau:RegisterEvent("NAME_PLATE_UNIT_ADDED")
    Spandau:RegisterEvent("PLAYER_TARGET_CHANGED")
    Spandau:RegisterEvent("BANKFRAME_OPENED")

    Spandau:RegisterMessage("UPDATE_DEATHLIST")

    self:SecureHook("UnitPopup_ShowMenu")
    Spandau:RegisterComm(Spandau.confs.prefix)

end

function Spandau:OnEnable()
    -- Called when the addon is enabled
    Spandau:Print("Enabled!")
end

function Spandau:OnDisable()
    -- Called when the addon is disabled
    Spandau:Print("Disabled!")
end

