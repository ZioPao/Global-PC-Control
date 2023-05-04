GridControlManager = {}


local function GetCurrentOptions()
    local currentOptions = SandboxOptions.new()
    currentOptions:copyValuesFrom(getSandboxOptions())
    return currentOptions
end



GridControlManager.GetStatus = function(option)

    local options = GetCurrentOptions()
    local moidifier = options:getOptionByName(option)
    print("PowerGridManager: ".. option .." => " .. tostring(moidifier:getValue()))
    if moidifier:getValue() > 0 then
        return true
    end

    return false
end