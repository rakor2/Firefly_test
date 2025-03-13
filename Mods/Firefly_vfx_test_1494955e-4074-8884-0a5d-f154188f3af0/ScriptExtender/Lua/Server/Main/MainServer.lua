print("[S][FIREFLY]")

fireflyExists = 0

fireFlyPositionOffsetX = 0 --Noth/Sounth
fireFlyPositionOffsetY = 2 --Up/Down
fireFlyPositionOffsetZ = 1 --East/West


local function FireflyCreate()
    pos = GetHostPositionServer()
    if fireflyExists == 1 then
        print("[S][FIREFLY] Firefly exists, can't summon a new one")
    else
        fireFlyUUID = Osi.CreateAt(FireflyGUID, pos.x, pos.y, pos.z, 0, 1, "")
        fireflyExists = 1
    end
end


local function FireflyDelete()
    Osi.RequestDelete(fireFlyUUID)
    fireflyExists = 0
end


local function StartPositionUpdates() --Updates light's position every tick
    if fireflyExists == 1 then
    if positionUpdateSubscription then return end --If positionUpdateSubscription = nil, then no sibscribe 
        positionUpdateSubscription = Ext.Events.Tick:Subscribe(function()
            local pos = GetHostPositionServer()
            Osi.ToTransform(fireFlyUUID, pos.x+fireFlyPositionOffsetX, pos.y+fireFlyPositionOffsetY, pos.z+fireFlyPositionOffsetZ, 0, 0, 0)
        end)
        print("[S][FIREFLY] Tick subscribtion started")
    else 
        print("[S][FIREFLY] No firefly creted, can not subscribe to tick")
    end
end


local function StopPositionUpdates()
    if positionUpdateSubscription then
        Ext.Events.Tick:Unsubscribe(positionUpdateSubscription)
        positionUpdateSubscription = nil
        print("[S][FIREFLY] Tick subscribtion ended")
    end
end


local function FireflyPositionToCharacter()
    pos = GetHostPositionServer()
    Osi.ToTransform(fireFlyUUID, pos.x, pos.y, pos.z, 0, 0, 0)
end


local function FireflyCreateAndSub()
    FireflyCreate()
    StartPositionUpdates()
end


local function FireflyDeleteAndUnSub()
    StopPositionUpdates()
    FireflyDelete()
end

--Console commands
--Example: !ffC creates the light
Ext.RegisterConsoleCommand("ffC", FireflyCreate);
Ext.RegisterConsoleCommand("ffD",  FireflyDelete);
Ext.RegisterConsoleCommand("ffPTC",  FireflyPositionToCharacter);
Ext.RegisterConsoleCommand("ffSubT",  StartPositionUpdates);
Ext.RegisterConsoleCommand("ffSubF",  StopPositionUpdates);
Ext.RegisterConsoleCommand("ffCnS",  FireflyCreateAndSub);
Ext.RegisterConsoleCommand("ffDnU",  FireflyDeleteAndUnSub);






--NEEDED STUFF
-- https://mod.io/g/baldursgate3/r/adding-a-new-spell-projectile
-- https://mod.io/g/baldursgate3/r/adding-a-new-spell-basic

-- Ext.Osiris.RegisterListener('CastSpell', 5, 'after', function(caster, spellName, spellType, spellElement, storyActionID)
--     print(caster .. ' casted spell "' .. spellName .. '")
--   end)


-- Ext.Osiris.RegisterListener("CastSpell", 5, "after", function(caster, spell)
--     if spell then 
--         Osi.ApplyStatus(caster, "SpellPoint_Interrupt_Restore_1", 1, 0)
--     end
-- end)

-- Ext.Osiris.RegisterListener("CastSpell", 5, "after", function(caster, spell)
--     if spell == "Target_Attune_Orcus" then
--         Osi.ApplyStatus(Osi.GetItemByTemplateInInventory("d8642e1a-ec0a-4288-8a95-1a954afcadcc", Osi.GetHostCharacter()), "Status_Bound_Artifact", -1, 100)
--     end
-- end)

-- -- Chaos Bolt Target
-- Ext.Osiris.RegisterListener("UsingSpellOnTarget", 6, "before", function (caster, target, spell, _, _, _)
-- 	local ran = Random(8)
-- 	if	(spell == "Target_ChaosBolt" or spell == "Target_ChaosBolt_2" or spell == "Target_ChaosBolt_3" or spell == "Target_ChaosBolt_4" or spell == "Target_ChaosBolt_5" or spell == "Target_ChaosBolt_6" or spell == "Target_ChaosBolt_7" or spell == "Target_ChaosBolt_8" or spell == "Target_ChaosBolt_9") and ran == 0 and Osi.HasActiveStatus(target,"CHAOS_BOLT_ACID") == 0 and Osi.HasActiveStatus(target,"CHAOS_BOLT_COLD") == 0 and Osi.HasActiveStatus(target,"CHAOS_BOLT_FIRE") == 0 and Osi.HasActiveStatus(target,"CHAOS_BOLT_FORCE") == 0 and Osi.HasActiveStatus(target,"CHAOS_BOLT_LIGHTNING") == 0 and Osi.HasActiveStatus(target,"CHAOS_BOLT_POISON") == 0 and Osi.HasActiveStatus(target,"CHAOS_BOLT_PSYCHIC") == 0 and Osi.HasActiveStatus(target,"CHAOS_BOLT_THUNDER") == 0 then
-- 		Osi.ApplyStatus(target, "CHAOS_BOLT_ACID",6.0,1,caster)
-- 		Osi.SetVarInteger(caster,"RandomNumbe2r",ran)

-- -- Chaos Bolt Self
-- Ext.Osiris.RegisterListener("UsingSpell", 5, "before", function (caster, spell, _, _, _)
-- 	local number = Random(8)
-- 	if	(spell == "Target_ChaosBolt" or spell == "Target_ChaosBolt_2" or spell == "Target_ChaosBolt_3" or spell == "Target_ChaosBolt_4" or spell == "Target_ChaosBolt_5" or spell == "Target_ChaosBolt_6" or spell == "Target_ChaosBolt_7" or spell == "Target_ChaosBolt_8" or spell == "Target_ChaosBolt_9") and number == 0 and Osi.HasActiveStatus(caster,"CHAOS_BOLT_ACID") == 0 and Osi.HasActiveStatus(caster,"CHAOS_BOLT_COLD") == 0 and Osi.HasActiveStatus(caster,"CHAOS_BOLT_FIRE") == 0 and Osi.HasActiveStatus(caster,"CHAOS_BOLT_FORCE") == 0 and Osi.HasActiveStatus(caster,"CHAOS_BOLT_LIGHTNING") == 0 and Osi.HasActiveStatus(caster,"CHAOS_BOLT_POISON") == 0 and Osi.HasActiveStatus(caster,"CHAOS_BOLT_PSYCHIC") == 0 and Osi.HasActiveStatus(caster,"CHAOS_BOLT_THUNDER") == 0 then
-- 		Osi.ApplyStatus(caster, "CHAOS_BOLT_ACID",6.0,1,caster)
-- 		Osi.SetVarInteger(caster,"RandomNumber",number)


-- Ext.Osiris.RegisterListener("StatusApplied", 4, "before", function (character, status, causee, _)
-- 	if status == "LIFE_TRANSFERENCE" then
-- 		local previoushp = GetVarInteger(causee, "BeforeHP")
-- 		local currenthp = GetHitpoints(causee)
-- 		local hp = 0
-- 		hp = previoushp - currenthp
-- 		hp = hp * 2
-- 		local ltstatus = "LIFE_TRANSFERENCE_HP_" .. hp
-- 		Osi.ApplyStatus(character,ltstatus,0.0,1,causee)


-- <Enumeration Name="SummonDuration">
-- <Label>UntilLongRest</Label>
-- <Label>Permanent</Label>
-- </Enumeration>

-- Osi.ApplyStatus(object, status, duration, force, source)