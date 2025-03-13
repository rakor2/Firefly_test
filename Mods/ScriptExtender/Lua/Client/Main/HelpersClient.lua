function GetHostPositionClient()
    local pos = _C().Transform.Transform.Translate
    return {
        x = pos[1], 
        y = pos[2], 
        z = pos[3]
    }
end

local function ghpcPrint()
    pos = GetHostPositionClient()
    print("[C][FIREFLY] Client character position:", pos.x, pos.y, pos.z)
end

Ext.RegisterConsoleCommand("ghpc", ghpcPrint);