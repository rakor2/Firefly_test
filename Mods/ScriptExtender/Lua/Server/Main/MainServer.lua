print("[S][FIREFLY]")


fireFlyPositionOffsetX = 0 -- Position offset for East/West 
fireFlyPositionOffsetY = 2 -- Position offset for Up/Down
fireFlyPositionOffsetZ = 1 -- Position offset for North/South

fireFlyUUID = {} --table for light UUIDs
createdFireFlyUUIDs = {}
charactersWhoGotStatus = {}
characterFireflyMap = {}
charactersPositions = {}

positionUpdateSubscriptions = {}

-- Listener for spell casting
Ext.Osiris.RegisterListener('CastSpell', 5, 'after', function(caster, spell)
    --If Eldritch Blast was found then
    if spell == "Projectile_EldritchBlast" then
        -- Check if the caster already has the POTION_OF_STRENGTH_HILL_GIANT status
        if Osi.HasActiveStatus(caster, "POTION_OF_STRENGTH_HILL_GIANT") == 1 then
            -- If the caster has the status, remove it
            Osi.RemoveStatus(caster, "POTION_OF_STRENGTH_HILL_GIANT")
            print("[S][FIREFLY] Status removed:", caster)
        else
            -- If the caster does not have the status, apply it
            Osi.ApplyStatus(caster, "POTION_OF_STRENGTH_HILL_GIANT", -1, 1)  -- -1 means permanent, but if it's not flagged as IgnoreResting, it's gonna last until long rest
            print("[S][FIREFLY] Status applied to:", caster)
        end
    end
end)

-- Listener for any status applied to a character
Ext.Osiris.RegisterListener("StatusApplied", 4, "after", function(character, status, causee, _)
    -- Check if the applied status is POTION_OF_STRENGTH_HILL_GIANT
    if status == "POTION_OF_STRENGTH_HILL_GIANT" then
        print("[S][FIREFLY] POTION_OF_STRENGTH_HILL_GIANT status found on:", character)

        -- Add the character who received the status to the charactersWhoGotStatus table
        table.insert(charactersWhoGotStatus, character)

        -- Get the position of the character
        local x, y, z = Osi.GetPosition(character)

        -- Update the light index based on how many lights have been created
        local fireflyIndex = #createdFireFlyUUIDs + 1

        -- Create a new light at the character's position and store its UUID
        fireFlyUUID[fireflyIndex] = Osi.CreateAt(FireflyGUID, x, y, z, 0, 1, "")

        -- Link (map) the character to the newly created lgiht UUID
        characterFireflyMap[character] = fireFlyUUID[fireflyIndex]

        -- Add the new light UUID to the createdFireFlyUUIDs table
        table.insert(createdFireFlyUUIDs, fireFlyUUID[fireflyIndex])

        -- Check if the character already has a position update subscription
        if positionUpdateSubscriptions[character] then return end --if it has one, then do nothing

        -- Create a new subscription to track the character's new position every tick
        positionUpdateSubscriptions[character] = Ext.Events.Tick:Subscribe(function()

            -- Get the character's position every tick
            local x, y, z = Osi.GetPosition(character)

            -- Update the position in the charactersPositions table
            charactersPositions[character] = {x = x, y = y, z = z}

            -- Get the light UUID mapped to the character
            local fireflyToTransform = characterFireflyMap[character]

            -- Update the light's position with offsets and 0 rotation
            Osi.ToTransform(fireflyToTransform, x + fireFlyPositionOffsetX, y + fireFlyPositionOffsetY, z + fireFlyPositionOffsetZ, 0, 0, 0)
        end)

        print("[S][FIREFLY] Tick subscription started for", character)
    end
end)

-- Listener for status removed from a character
Ext.Osiris.RegisterListener("StatusRemoved", 4, "after", function(character, status, _, _)
    if status == "POTION_OF_STRENGTH_HILL_GIANT" then
        -- If the "POTION_OF_STRENGTH_HILL_GIANT" status is removed, detach the light

        -- Get the light mapped to the character.
        local fireflyToDelete = characterFireflyMap[character]

        -- If a light exists for the character, delete it
        if fireflyToDelete then
            Osi.RequestDelete(fireflyToDelete)
            characterFireflyMap[character] = nil
        end

        -- Unsubscribe from the position update for the character
        local subscriptionToUnsubscribe = positionUpdateSubscriptions[character]
        if subscriptionToUnsubscribe then
            Ext.Events.Tick:Unsubscribe(subscriptionToUnsubscribe)
            positionUpdateSubscriptions[character] = nil
        end

        -- Clear the character's position
        charactersPositions[character] = nil

        -- Remove the character from the charactersWhoGotStatus table
        for i, caster in ipairs(charactersWhoGotStatus) do
            if caster == character then
                table.remove(charactersWhoGotStatus, i)
                break
            end
        end

        -- Remove the light UUID from the createdFireFlyUUIDs table
        for i, ffUuid in ipairs(createdFireFlyUUIDs) do
            if ffUuid == fireflyToDelete then
                table.remove(createdFireFlyUUIDs, i)
                break
            end
        end

        print("[S][FIREFLY] Firefly detached and tables cleared for:", character)
    end
end)




-- local function FireflyCreate()
--     pos = GetHostPositionServer()
--     if fireflyExists == 1 then
--         print("[S][FIREFLY] Firefly exists, can't summon a new one")
--     else
--         fireFlyUUID = Osi.CreateAt(FireflyGUID, pos.x, pos.y, pos.z, 0, 1, "")
--         fireflyExists = 1
--     end
-- end


-- local function FireflyDelete()
--     for i = 1, #createdFireFlyUUIDs do
--     Osi.RequestDelete(createdFireFlyUUIDs[i])
--     end
--     -- fireflyExists = 0
-- end


-- local function StartPositionUpdates() --Updates light's position every tick
--     if fireflyExists == 1 then
--     if positionUpdateSubscription then return end --If positionUpdateSubscription = nil, then no sibscribe 
--         positionUpdateSubscription = Ext.Events.Tick:Subscribe(function()
--             -- local pos = GetHostPositionServer()
--             -- Osi.ToTransform(fireFlyUUID, pos.x+fireFlyPositionOffsetX, pos.y+fireFlyPositionOffsetY, pos.z+fireFlyPositionOffsetZ, 0, 0, 0)
            
--         end)
--         print("[S][FIREFLY] Tick subscribtion started")
--     else 
--         print("[S][FIREFLY] No firefly creted, can not subscribe to tick")
--     end
-- end


-- local function StopPositionUpdates()
--     if positionUpdateSubscription2 then
--     Ext.Events.Tick:Unsubscribe(positionUpdateSubscription2)
--     positionUpdateSubscription2 = nil
--     elseif positionUpdateSubscription then
--         Ext.Events.Tick:Unsubscribe(positionUpdateSubscription)
--         positionUpdateSubscription = nil
--         print("[S][FIREFLY] Tick subscribtion ended")
--     end
-- end


-- local function FireflyPositionToCharacter()
--     pos = GetHostPositionServer()
--     Osi.ToTransform(fireFlyUUID, pos.x, pos.y, pos.z, 0, 0, 0)
-- end


-- local function FireflyCreateAndSub()
--     FireflyCreate()
--     StartPositionUpdates()
-- end


-- local function FireflyDeleteAndUnSub()
--     StopPositionUpdates()
--     FireflyDelete()
-- end

--Console commands
--Example: !ffC creates the light
-- Ext.RegisterConsoleCommand("ffC", FireflyCreate);
-- Ext.RegisterConsoleCommand("ffD",  FireflyDelete);
-- Ext.RegisterConsoleCommand("ffPTC",  FireflyPositionToCharacter);
-- Ext.RegisterConsoleCommand("ffSubT",  StartPositionUpdates);
-- Ext.RegisterConsoleCommand("ffSubF",  StopPositionUpdates);
-- Ext.RegisterConsoleCommand("ffCnS",  FireflyCreateAndSub);
-- Ext.RegisterConsoleCommand("ffDnU",  FireflyDeleteAndUnSub);







--NEEDED STUFF
-- https://mod.io/g/baldursgate3/r/adding-a-new-spell-projectile
-- https://mod.io/g/baldursgate3/r/adding-a-new-spell-basic

-- Ext.Osiris.RegisterListener('CastSpell', 5, 'after', function(caster, spellName, spellType, spellElement, storyActionID)
--     print(caster .. ' casted spell "' .. spellName .. '")
--   end)


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


-- Ext.Osiris.RegisterListener("CastSpell", 5, "before", function(caster, spell, spellType, spellElement, storyActionID)
--     local casterEntity = Ext.Entity.Get(caster)
--     casterEntity.SpellCastIsCasting.Cast = nil
--     casterEntity:Replicate("SpellCastIsCasting")
-- end)

-- <Enumeration Name="SummonDuration">
-- <Label>UntilLongRest</Label>
-- <Label>Permanent</Label>
-- </Enumeration>

-- Osi.ApplyStatus(object, status, duration, force, source)