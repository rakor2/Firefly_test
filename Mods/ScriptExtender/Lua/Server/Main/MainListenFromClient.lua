Ext.RegisterNetListener("PostXYZSliderValue", function(channel, payload)
    local data = Ext.Json.Parse(payload)
    print("[S][FIREFLY] Listen y slider value:", data.x, data.y, data.z)
    fireFlyPositionOffsetX = data.x
    fireFlyPositionOffsetY = data.y
    fireFlyPositionOffsetZ = data.z
end)