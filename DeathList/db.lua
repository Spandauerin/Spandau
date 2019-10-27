--
-- Created by IntelliJ IDEA.
-- User: Spandauerin
-- Date: 20.10.19
-- Time: 22:01
-- To change this template use File | Settings | File Templates.
--

DB.DeathList = {}

function DB.DeathList:playerIsInDeathList(targetPlayer)
    for _, value in pairs(Spandau.db.char.deathList) do
        if value.player == targetPlayer then
            return true
        end
    end
    return false;
end

function DB.DeathList:addPlayerToDeathList(playerEntry)

    for _, value in pairs(Spandau.db.char.deathList) do
        if value.player == playerEntry.player then
            Spandau:Print(playerEntry.player .. " schon in der Liste!")
            return false
        end
    end

    table.insert(Spandau.db.char.deathList, playerEntry)
    Spandau:Print(playerEntry.player .. " der Todesliste hinzugefügt!")
    return true
end

