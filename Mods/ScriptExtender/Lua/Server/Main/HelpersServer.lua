function GetHostPositionServer()
    local x, y, z = Osi.GetPosition(GetHostCharacter())
    return {
        x = x,
        y = y,
        z = z
    }
end

local function ghpsPrint()
    pos = GetHostPositionServer()
    print("[C][FIREFLY] Server character position:", pos.x, pos.y, pos.z)
end

Ext.RegisterConsoleCommand("ghps", ghpsPrint);