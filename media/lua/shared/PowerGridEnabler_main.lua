PowerGridManager = {}


local function GetCurrentOptions()
    local currentOptions = SandboxOptions.new()
    currentOptions:copyValuesFrom(getSandboxOptions())
    return currentOptions
end

PowerGridManager.GetPowerStatus = function()

    local options = GetCurrentOptions()
    local elecShutModifierOption = options:getOptionByName("ElecShutModifier")
    print(elecShutModifierOption:getValue())
    if elecShutModifierOption:getValue() > 0 then
        return true
    end

    return false
 
end