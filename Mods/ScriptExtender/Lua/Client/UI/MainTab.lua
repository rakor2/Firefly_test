function MainTab(mt)

    if MainTab ~= nil then return end
    MainTab = mt

    local xyzSlider = mt:AddSlider("X,Y,Z", 0, -5, 5, 0.001)
    xyzSlider.Components = 3
    xyzSlider.Value = {0,2,1,0}
    xyzSlider.OnChange = function(value)
        xyzSliderValue(value)
    end

end

Mods.BG3MCM.IMGUIAPI:InsertModMenuTab(ModuleUUID, "Firefly vfx test", MainTab)