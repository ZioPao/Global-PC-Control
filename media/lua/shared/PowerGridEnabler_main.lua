PowerGridManager = {}


local function GetCurrentOptions()
    local currentOptions = SandboxOptions.new()
    currentOptions:copyValuesFrom(getSandboxOptions())
    return currentOptions
end

PowerGridManager.GetPowerStatus = function()

    local options = GetCurrentOptions()
    local elecShutModifierOption = options:getOptionByName("ElecShutModifier")

    if elecShutModifierOption:getValue() > 0 then
        return true
    end

    return false
 
end

PowerGridManager.TurnPowerOn = function()
    local currentOptions = GetCurrentOptions()
    local elecShutModifierOption = currentOptions:getOptionByName("ElecShutModifier")
    elecShutModifierOption:setValue(2147483647)
    currentOptions:sendToServer()
  end

PowerGridManager.TurnPowerOff = function()
    local currentOptions = GetCurrentOptions()
    currentOptions:getOptionByName("ElecShutModifier"):setValue(-1)
    currentOptions:sendToServer()
end