function xyzSliderValue(value)
    print("[C][FIREFLY] Post slider values:", value.Value[1], value.Value[2], value.Value[3])
    local sliderValues = Ext.Json.Stringify({
        x = value.Value[1],
        y = value.Value[2],
        z = value.Value[3]
    })
    Ext.Net.PostMessageToServer("PostXYZSliderValue", sliderValues)
end