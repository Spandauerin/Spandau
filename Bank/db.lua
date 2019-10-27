--
-- Created by IntelliJ IDEA.
-- User: Spandauerin
-- Date: 20.10.19
-- Time: 22:07
-- To change this template use File | Settings | File Templates.
--
DB.Bank = {}
function DB.Bank:readItemsToDB()
    local bankCharEntry = {}
    local bag = {}
    local scanning = true
    ScanButton:SetText("Scanning...")
    for i=-1,11 do
        for j=0,24 do
            local _, itemCount, _, _, _, _, itemIDLong = GetContainerItemInfo(i, j);

            if itemIDLong then
                local itemID = select(1,GetItemInfoInstant(itemIDLong))
                if bag[itemID] then
                    bag[itemID] = bag[itemID] + itemCount
                else
                    bag[itemID] = itemCount
                end
            end
        end

    end
    local timeNow = Utils:getServerTimeAsNumber()
    Spandau.db.realm.bankItems[Spandau.db.char.name] = {}
    for itemID, count in pairs(bag) do
        local bagEntry = {}
        bagEntry["itemID"] = itemID
        bagEntry["count"] = count
        bagEntry["time"] = timeNow
        local itemName = select(1,GetItemInfo(itemID))
        Spandau:Print(itemName .. " scanned!")
        table.insert(Spandau.db.realm.bankItems[Spandau.db.char.name],bagEntry)
    end
    local money = GetMoney()
    local bagEntry = {}
    bagEntry["itemID"] = Spandau.confs.goldID
    bagEntry["count"] = money
    bagEntry["time"] = timeNow
    table.insert(Spandau.db.realm.bankItems[Spandau.db.char.name],bagEntry)
    local bankString = Utils:bankItemCharToString(Spandau.db.realm.bankItems[Spandau.db.char.name],Spandau.db.char.name)
    Spandau:broadcastNewItems(bankString)
    ScanButton:SetText("Scan Items")

end
function DB.Bank:getNewestItems()
    local lastUpdate;
    local items = {}
    local itemsPerPlayer = {}
    for player,timeStamps in pairs(Spandau.db.realm.bankItems) do
        itemsPerPlayer[player] = {}
        for _,entry in pairs(timeStamps) do
            lastUpdate = entry.time
            if items[entry.itemID] then
                items[entry.itemID] = items[entry.itemID] + entry.count
            else
                items[entry.itemID] = entry.count
            end
            itemsPerPlayer[player][entry.itemID] = entry.count

        end

    end
    return items, lastUpdate, itemsPerPlayer
end