--
-- Created by IntelliJ IDEA.
-- User: Spandauerin
-- Date: 20.10.19
-- Time: 21:49
-- To change this template use File | Settings | File Templates.
--

function Utils:stringToBankItemChar(msg)
    local clearedMessage = msg:gsub(Spandau.confs.messageType.BankCharItem .. Spandau.confs.delimiterType, "")
    local splittedMessage = split(clearedMessage,Spandau.confs.delimiterVariables)
    local entry = {}
    entry["char"] = splittedMessage[1];
    entry["time"] = tonumber(splittedMessage[2]);
    entry["itemID"] = splittedMessage[3];
    entry["count"] = splittedMessage[4];
    return entry
end


function Utils:bankItemCharToString(bankItems,player)
    local bankString = ""
    for _, entry in pairs(bankItems) do
        bankString = bankString .. Spandau.confs.delimiterType .. entry.count .. Spandau.confs.delimiterVariables .. entry.itemID
    end
    return bankItems[1].time .. Spandau.confs.delimiterType .. player .. bankString
end

function Utils:stringToBankItemChar(bankItems)
    local splittedMessage = self:split(bankItems,Spandau.confs.delimiterType)
    local time = splittedMessage[1]
    local player = splittedMessage[2]
    for i=3,#splittedMessage do
        local itemSplit = self:split(splittedMessage[i],Spandau.confs.delimiterVariables)
        local bagEntry = {}
        bagEntry["time"] = time
        bagEntry["itemID"] = itemSplit[2]
        bagEntry["count"] = itemSplit[1]
    end

end

function Utils:tablelength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end

