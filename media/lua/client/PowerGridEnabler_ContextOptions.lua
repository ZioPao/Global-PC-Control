
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


ISWorldObjectContextMenu.onManagingPowerGrid = function(_, status)

    -- Enable it or disable it
    local currentOptions = SandboxOptions.new()
    currentOptions:copyValuesFrom(getSandboxOptions())
    local elecShutModifier = currentOptions:getOptionByName("ElecShutModifier")
    if status then
        elecShutModifier:setValue(-1)
    else
        elecShutModifier:setValue(2147483647)
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

    local managerMainString
    local powerGridStatus = PowerGridManager.GetPowerStatus()
    if powerGridStatus then
        managerMainString = "Disable PowerGrid"
    else
        managerMainString = "Enable PowerGrid"
    end

    -- if clickedObject:getSquare() then
    --     print(moveableObject.name)
    --     if clickedObject:getContainer() then
    --         print("Electricity!!")

    --     else
    --         print("No electricity here")

    --     end

    -- end
    
    if instanceof(clickedObject, "IsoObject") and moveableObject.name == pcTileName and clickedObjectModData.powerGridManager and clickedObject:getContainer() and clickedObject:getContainer():isPowered() and (playerInv:containsTypeRecurse(cdItemName) or adminCheck) then
        context:addOption(managerMainString, worldObjects, ISWorldObjectContextMenu.onManagingPowerGrid, powerGridStatus)
    end
end


Events.OnFillWorldObjectContextMenu.Add(PowerGridManagerOptions)