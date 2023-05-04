
ISWorldObjectContextMenu.onSetupPCTile = function(worldObjects, player)

    local pcTile = worldObjects[1]
    local modData = pcTile:getModData()

    -- Add a simple mod data to check this tile.
    if modData.powerGridManager then
        modData.powerGridManager = false
    else
        if pcTile:getContainer() == nil then
            local itemContainer = ItemContainer.new("PowerGrid Manager", player:getCurrentSquare(), player)
            itemContainer:setActive(false)
            pcTile:setContainer(itemContainer)
        end
        modData.powerGridManager = true
    end


    print("PowerGridManager: pc set as manager => " .. tostring(modData.powerGridManager))


end


ISWorldObjectContextMenu.onManagingGrid = function(_, status, optionName)

    -- Enable it or disable it
    local currentOptions = SandboxOptions.new()
    currentOptions:copyValuesFrom(getSandboxOptions())
    local gridModifier = currentOptions:getOptionByName(optionName)



    if status then
        gridModifier:setValue(-1)
    else
        gridModifier:setValue(2147483647)
    end

    if not isClient() and not isServer() then
        currentOptions:updateFromLua()
    else
        currentOptions:sendToServer()
    end

end



local function PowerGridManagerOptions(playerNum, context, worldObjects)
    local clickedObject = worldObjects[1]
    local clickedObjectModData = clickedObject:getModData()
    local moveableObject = ISMoveableSpriteProps.fromObject(clickedObject)


    local player = getPlayer()
    local playerInv = player:getInventory()

    local pcTileName = "Desktop Computer"
    local cdItemName = "PowerGridFixer"

    --*************************--
    -- Admin Setup stuff


    local adminCheck = (isAccessLevel("admin") or (not isClient() and not isServer()))


    if adminCheck then

        local adminOptionString = "ADMIN: "

        if clickedObjectModData.powerGridManager then
            adminOptionString = adminOptionString .. "disable PowerGrid Manager"
        else
            adminOptionString = adminOptionString .. "convert PC to PowerGrid Manager"
    
        end

        if instanceof(clickedObject, "IsoObject") and moveableObject.name == pcTileName then
            context:addOption(adminOptionString, worldObjects, ISWorldObjectContextMenu.onSetupPCTile, player)
        end

    end



    
    --*************************--

    local powerGridOption
    local powerGridStatus = GridControlManager.GetStatus("ElecShutModifier")
    if powerGridStatus then powerGridOption = "Disable Power Grid" else powerGridOption = "Enable Power Grid" end

    local waterGridOption
    local waterGridStatus = GridControlManager.GetStatus("WaterShutModifier")
    if waterGridStatus then waterGridOption = "Disable Water Grid" else waterGridOption = "Enable Water Grid" end



    
    if instanceof(clickedObject, "IsoObject") and moveableObject.name == pcTileName and clickedObjectModData.powerGridManager and clickedObject:getContainer() and clickedObject:getContainer():isPowered() and (playerInv:containsTypeRecurse(cdItemName) or adminCheck) then
        context:addOption(powerGridOption, worldObjects, ISWorldObjectContextMenu.onManagingGrid, powerGridStatus, "ElecShutModifier")
        context:addOption(waterGridOption, worldObjects, ISWorldObjectContextMenu.onManagingGrid, waterGridStatus, "WaterShutModifier")

    end
end


Events.OnFillWorldObjectContextMenu.Add(PowerGridManagerOptions)