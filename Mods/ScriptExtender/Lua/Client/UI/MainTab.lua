function MainTab(mt)

    if MainTab ~= nil then return end
    MainTab = mt

    local xyzSlider = mt:AddSlider("", 0, -5, 5, 0.001)
    xyzSlider.Components = 3
    xyzSlider.OnChange = function(value)
        xyzSliderValue(value)
    end

end

Mods.BG3MCM.IMGUIAPI:InsertModMenuTab(ModuleUUID, "Firefly vfx test", MainTab)