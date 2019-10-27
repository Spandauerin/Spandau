--
-- Created by IntelliJ IDEA.
-- User: Spandauerin
-- Date: 20.10.19
-- Time: 22:10
-- To change this template use File | Settings | File Templates.
--
CREATED = FALSE
BUTTON_COUNT = 0
Button = {}
DISPLAYED_BUTTONS = {}
DISPLAYED_PERSONS = {}
PAGES = {}
ITEMS_PER_PAGE = 0
ACTIVE_PAGE= 1
NEEDED_PAGES = 1
SELECTED_PLAYER = ""
function Spandau:BANKFRAME_OPENED()
    if Spandau.db.char.isBankChar then
        BankAddition:Show()
    end
end

function Button:createPerson()
    local person = CreateFrame("BUTTON")
    local buttonWidth = ItemFrame:GetWidth() / Spandau.confs.personsPerRow
    local buttonHeight = buttonWidth / 3
    person:SetWidth(buttonWidth)
    person:SetHeight(buttonHeight)
    person:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight", "ADD")
    person.name = person:CreateFontString(nil,"ARTWORK", "GameFontNormal")
    person.name:SetPoint("CENTER", person, "CENTER")
    person.name:SetJustifyH("CENTER")
    person.name:SetWidth(buttonWidth)
    person.name:SetHeight(0.3 * buttonWidth)

    local ntex = person:CreateTexture()
    ntex:SetTexture("Interface/Buttons/UI-Panel-Button-Up")
    ntex:SetTexCoord(0, 0.625, 0, 0.6875)
    ntex:SetAllPoints()

    person.activeTexture = ntex

    local htex = person:CreateTexture()
    htex:SetTexture("Interface/Buttons/UI-Panel-Button-Highlight")
    htex:SetTexCoord(0, 0.625, 0, 0.6875)
    htex:SetAllPoints()
    person:SetHighlightTexture(htex)

    local ptex = person:CreateTexture()
    ptex:SetTexture("Interface/Buttons/UI-Panel-Button-Down")
    ptex:SetTexCoord(0, 0.625, 0, 0.6875)
    ptex:SetAllPoints()
    person:SetPushedTexture(ptex)

    local dtex = person:CreateTexture()
    dtex:SetTexture("Interface/Buttons/UI-Panel-Button-Disabled")
    dtex:SetTexCoord(0, 0.625, 0, 0.6875)
    dtex:SetAllPoints()
    person.disabledTexture = dtex
    person:SetNormalTexture(dtex)
    person.active = false
    person:Hide()

    person:SetScript("OnClick", function(self)
        if self.active then
            self.active = false
            SELECTED_PLAYER = ""
            self:SetNormalTexture(self.disabledTexture)
        else
            for _, button in pairs(DISPLAYED_PERSONS) do
                button.active = false
                button:SetNormalTexture(button.disabledTexture)
            end
            self.active = true
            self:SetNormalTexture(self.activeTexture)
            SELECTED_PLAYER = self.name:GetText()
        end
        ACTIVE_PAGE = 1
        refreshData()
        changePage()
    end)
    return person
end

function Button:createItem()
    local buttonWidth = ItemFrame:GetWidth() / Spandau.confs.itemsPerRow
    local buttonHeight = buttonWidth * 1.3
    BUTTON_COUNT = BUTTON_COUNT + 1

    local buttonName = "SPANDAU_BANK_"..BUTTON_COUNT
    local button = CreateFrame("BUTTON", buttonName)
    button:SetWidth(buttonWidth)
    button:SetHeight(buttonHeight)
    button:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight", "ADD")
    button:SetText("?")
    button.icon = button:CreateTexture(buttonName.."_icon")
    button.icon:SetPoint("TOPLEFT", button, "TOPLEFT", 1, -1)
    button.icon:SetHeight(buttonWidth)
    button.icon:SetWidth(buttonWidth)
    button.icon:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")

    button.name = button:CreateFontString(buttonName.."_name", "ARTWORK", "GameFontNormal")
    button.name:SetPoint("BOTTOM", button, "BOTTOM")
    button.name:SetJustifyH("CENTER")
    button.name:SetWidth(buttonWidth)
    button.name:SetHeight(0.3 * buttonWidth)

    button.overlay = button:CreateTexture(buttonName.."_overlay", "OVERLAY")
    button.overlay:SetPoint("TOPLEFT", button.icon, "TOPLEFT")
    button.overlay:SetPoint("BOTTOMRIGHT", button.icon, "BOTTOMRIGHT")
    button.overlay:Hide()
    button.overlay.SetQualityBorder = Button_Overlay_SetQualityBorder

    return button
end

function createButtons()
    if CREATED then
        return
    else
        CREATED = true
    end
    local itemWidth = ItemFrame:GetWidth() / Spandau.confs.itemsPerRow
    local itemHeight = itemWidth * 1.3
    local itemsPerColumn = math.floor(ItemFrame:GetHeight() / itemHeight)
    ITEMS_PER_PAGE = itemsPerColumn * Spandau.confs.itemsPerRow
    for i=0, ITEMS_PER_PAGE - 1 do
        local row = math.floor( i / Spandau.confs.itemsPerRow )
        local column = i % Spandau.confs.itemsPerRow
        local xOffset = column * itemWidth
        local yOffset = -1 * row * itemHeight
        local button = Button:createItem()
        button:SetParent(ItemFrame)
        button:SetPoint("TOPLEFT", ItemFrame, "TOPLEFT", xOffset , yOffset)
        DISPLAYED_BUTTONS[i] = button
    end
    local yOffsetBasis = - 30
    for i=0, (Spandau.confs.personsPerRow * 3) - 1 do
        local row = math.floor( i / Spandau.confs.personsPerRow )
        local person = Button:createPerson()
        local personWidth = person:GetWidth()
        local personHeight = person:GetHeight()
        local yOffset = (-1 * row * personHeight) + yOffsetBasis
        local xOffset = (i % Spandau.confs.personsPerRow) * personWidth
        person:SetParent(ItemFrame)
        person:SetPoint("TOPLEFT", ItemFrame, "BOTTOMLEFT",xOffset,yOffset)
        DISPLAYED_PERSONS[i] = person
    end


end

local function formatCount(count)
    if count < 1000 then
        return count
    else
        return string.format("%.2f k", count / 1000)
    end
end

function refreshData()
    PAGES = {}
    local allItems, itemDate, itemsPerPlayer = DB.Bank:getNewestItems()
    local displayedItems

    local person = 0
    for playerName,_ in pairs(itemsPerPlayer) do
        DISPLAYED_PERSONS[person].name:SetText(playerName)
        DISPLAYED_PERSONS[person]:Show()
        person = person + 1
    end

    if SELECTED_PLAYER == "" then
        displayedItems = allItems
    else
        displayedItems = itemsPerPlayer[SELECTED_PLAYER]
    end

    if (Utils:tablelength(displayedItems)-1) %  ITEMS_PER_PAGE == 0 then
        NEEDED_PAGES = math.floor((Utils:tablelength(displayedItems)-1)/ ITEMS_PER_PAGE)
    else
        NEEDED_PAGES = math.floor((Utils:tablelength(displayedItems)-1)/ ITEMS_PER_PAGE) + 1
    end

    BANK_FRAME_TEXT:SetText(SELECTED_PLAYER .. " - Guild Bank char (" .. date('%Y-%m-%d %H:%M:%S', itemDate) .. ")")
    local buttonCount = 0
    for id, count in pairs(displayedItems) do
        if id == Spandau.confs.goldID then
            MoneyString:SetText(GetCoinTextureString(count))
        else
            local page = math.floor(buttonCount / ITEMS_PER_PAGE) + 1
            if not PAGES[page] then
                PAGES[page] = {}
            end
            PAGES[page][buttonCount % ITEMS_PER_PAGE] = {itemID = id, itemCount = formatCount(count)}
            buttonCount = buttonCount + 1
        end
    end
end
function prevPage()
    if ACTIVE_PAGE > 1 then
        ACTIVE_PAGE = ACTIVE_PAGE - 1
        changePage()
    end
end

function nextPage()
    if ACTIVE_PAGE < NEEDED_PAGES then
        ACTIVE_PAGE = ACTIVE_PAGE + 1
        changePage()
    end
end
local function setButtons()
    if ACTIVE_PAGE == NEEDED_PAGES then
        NextButton:SetEnabled(false)
    else
        NextButton:SetEnabled(true)
    end

    if ACTIVE_PAGE == 1 then
        PrevButton:SetEnabled(false)
    else
        PrevButton:SetEnabled(true)
    end
end

function changePage()
    setButtons()
    PageText:SetText(ACTIVE_PAGE .. "/" .. NEEDED_PAGES)
    for i=0,ITEMS_PER_PAGE -1 do
        if (PAGES[ACTIVE_PAGE][i]) then
            if GetItemIcon(PAGES[ACTIVE_PAGE][i].itemID) then
                DISPLAYED_BUTTONS[i].icon:SetTexture(GetItemIcon(PAGES[ACTIVE_PAGE][i].itemID))
            else
                DISPLAYED_BUTTONS[i].icon:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
            end

            DISPLAYED_BUTTONS[i]:SetScript("OnEnter", function(self)
                GameTooltip:SetOwner(DISPLAYED_BUTTONS[i],"ANCHOR_RIGHT")
                GameTooltip:SetHyperlink("item:" .. PAGES[ACTIVE_PAGE][i].itemID)
            end)

            DISPLAYED_BUTTONS[i].name:SetText(PAGES[ACTIVE_PAGE][i].itemCount)
            DISPLAYED_BUTTONS[i]:Show()
        else
            DISPLAYED_BUTTONS[i]:Hide()
        end
    end
end

