--
-- Created by IntelliJ IDEA.
-- User: Spandauerin
-- Date: 20.10.19
-- Time: 19:57
-- To change this template use File | Settings | File Templates.
--

local function getMessageType(msg)
    if not string.match(msg, Spandau.confs.delimiterType) then
        Spandau:Print("Message:" .. msg .. "- wrong format")
        return nil
    end

    if string.match(msg, Spandau.confs.messageType.DeathListEntry .. Spandau.confs.delimiterType) then
        return Spandau.confs.messageType.DeathListEntry, string.gsub(msg, Spandau.confs.messageType.DeathListEntry.. Spandau.confs.delimiterType, "")
    elseif string.match(msg, Spandau.confs.messageType.DeathListRequest .. Spandau.confs.delimiterType) then
        return Spandau.confs.messageType.DeathListRequest, string.gsub(msg, Spandau.confs.messageType.DeathListRequest.. Spandau.confs.delimiterType, "")
    elseif string.match(msg, Spandau.confs.messageType.BankChar.. Spandau.confs.delimiterType) then
        return Spandau.confs.messageType.BankCharItem, string.gsub(msg, Spandau.confs.messageType.BankChar.. Spandau.confs.delimiterType, "")
    else
        return nil
    end
end

function Spandau:broadcastNewItems(bankItems)
    Spandau:SendCommMessage(Spandau.confs.prefix, Spandau.confs.messageType.BankChar ..
            Spandau.confs.delimiterType .. bankItems, "GUILD")
end

function Spandau:broadcastNewPlayerDeathlist(entry)
    Spandau:SendCommMessage(Spandau.confs.prefix, Spandau.confs.messageType.DeathListEntry ..
            Spandau.confs.delimiterType .. Utils:deathListEntryToString(entry), "GUILD")
end

function Spandau:OnCommReceived(pref,msg,typ,user,...)

    local messageType, clearedMessage = getMessageType(msg)
    if not messageType then
        do return end
    end

    Spandau:Print("MessageType:" .. messageType)

    if messageType == Spandau.confs.messageType.DeathListEntry then
        local entry = Utils:stringToDeathListEntry(msg)
        Utils:addPlayerToDeathList(entry)
    elseif messageType == Spandau.confs.messageType.DeathListRequest then
        for _, entry in pairs(Spandau.db.char.deathList) do
            Spandau:broadcastNewPlayerDeathlist(entry)
        end
    elseif messageType == Spandau.confs.messageType.BankChar then
        local entries = Utils:stringToBankItemChar(clearedMessage)
        --SPA.DB.BANKCHARS:addItemToBankChar(entry)
    else
        local messageSplitted = split(msg,Spandau.confs.delimiterType)
        if typ == "GUILD" and messageSplitted[1] ==  "DeathList" then
            Spandau:Print(messageSplitted[1])
        end
    end
    Spandau:Print(msg .. " von user:" .. user)
end



