--
-- Created by IntelliJ IDEA.
-- User: Spandauerin
-- Date: 20.10.19
-- Time: 17:32
-- To change this template use File | Settings | File Templates.
--


function Utils:getServerTimeAsNumber()
    return tonumber(GetServerTime());
end

function Utils:split(s, delimiter)
    local result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end

function Utils:tableLength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end

function Utils:stringToDeathListEntry(msg)
    local clearedMessage = msg:gsub(Spandau.confs.messageType.DeathListEntry .. Spandau.confs.delimiterType, "")
    local splittedMessage = self:split(clearedMessage,Spandau.confs.delimiterVariables)
    local entry = {}
    entry["time"] = tonumber(splittedMessage[1]);
    entry["player"] = splittedMessage[2];
    entry["creator"] = splittedMessage[3];
    return entry
end

function Utils:deathListEntryToString(entry)
    return "" .. entry.time .. Spandau.confs.delimiterVariables .. entry.player .. Spandau.confs.delimiterVariables .. entry.creator
end
function Utils:getTimestampFromDeatListRequest(msg)
    local numberAsString = string.gsub(msg,Spandau.confs.messageType.DeathListRequest .. Spandau.confs.delimiterType,"")
    return tonumber(numberAsString)
end
function Utils:createDeathListEntryFromName(name)
    local entry = {}
    entry["time"] = self:getServerTimeAsNumber();
    entry["player"] = name;
    entry["creator"] = Spandau.db.char.name;
    return entry;
end

