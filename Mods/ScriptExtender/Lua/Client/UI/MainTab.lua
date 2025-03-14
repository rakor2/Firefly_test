function MainTab(mt)

-------- This prevents menu from duplication on each code reload
    if MainTab ~= nil then return end
    MainTab = mt
-----------------------------------------------------------------

    local xyzSlider = mt:AddSlider("X,Y,Z", 0, -5, 5, 0.001)
    xyzSlider.Components = 3 --Instead of making 3 slider, this splits the slider into 3 pieces 
    xyzSlider.Value = {0,2,1,0} --Set default values
    xyzSlider.OnChange = function(value)
        xyzSliderValue(value)
    end

end

Mods.BG3MCM.IMGUIAPI:InsertModMenuTab(ModuleUUID, "Firefly vfx test", MainTab)