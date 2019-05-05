require("addon_game_mode")
require("_util")

moditem = nil

function placeGhost(keys)
    if(keys.caster:GetTeam()==3) then
        return nil;
    end
    PLACED_BUILDING_RADIUS = 45.0;
    blocking_counter = 0;
    groundclickpos = GetGroundPosition(keys.target_points[1], nil);
    xpos = GridNav:WorldToGridPosX(groundclickpos.x);
    ypos = GridNav:WorldToGridPosY(groundclickpos.y);
    groundclickpos.x = GridNav:GridPosToWorldCenterX(xpos);
    groundclickpos.y = GridNav:GridPosToWorldCenterY(ypos);

    if GridNav:IsTraversable(groundclickpos) then
    else
        blocking_counter = blocking_counter + 1
    end

    for _,thing in pairs(Entities:FindAllInSphere(groundclickpos, PLACED_BUILDING_RADIUS) )  do
        if thing:GetClassname() == "npc_dota_creep" or string.match(thing:GetClassname(),"npc_dota_hero") then
            blocking_counter = blocking_counter + 1
        end
    end

    if( blocking_counter < 1) then
    else
        --keys.caster:ModifyGold(keys.AbilityGoldCost,false,0)
        sendError(keys.caster:GetPlayerOwnerID(),
            "Not enough mana on hero")
        sendError(keys.caster:GetPlayerOwnerID(), "Cannot build there")
        keys.caster:Interrupt()
        keys.caster:InterruptChannel()
        return nil
    end




--[[
    local player = keys.caster:GetPlayerOwner()

    if player == nil then
        return nil
    end


    groundclickpos = GetGroundPosition(keys.target_points[1], nil)
    xpos = GridNav:WorldToGridPosX(groundclickpos.x)
    ypos = GridNav:WorldToGridPosY(groundclickpos.y)
    groundclickpos.x = GridNav:GridPosToWorldCenterX(xpos)
    groundclickpos.y = GridNav:GridPosToWorldCenterY(ypos)




    if player.modelGhostDummy ~= nil then
        player.modelGhostDummy:RemoveSelf()
        player.modelGhostDummy = nil
    end


    local OutOfWorldVector = Vector(11000,11000,0)


    player.modelGhostDummy = CreateUnitByName(keys.unitname, OutOfWorldVector, false, nil, nil, keys.caster:GetTeam())


    local mgd = player.modelGhostDummy -- alias
    mgd.isBuildingDummy = true -- store this for later use

    local modelParticle = ParticleManager:CreateParticleForPlayer("particles/buildinghelper/ghost_model.vpcf", PATTACH_ABSORIGIN, mgd, player)

    player.ghostParticle = modelParticle;

    if modelParticle ~= nil then
        ParticleManager:SetParticleControlEnt(modelParticle, 1, mgd, 1, "follow_origin", mgd:GetAbsOrigin(), true)                      
        ParticleManager:SetParticleControl(modelParticle, 3, Vector(40,0,0))   -- alpha 0-100

        ParticleManager:SetParticleControl(modelParticle, 4, Vector(keys.unitscale,0,0))  -- scale 0-1

    end

    local centerX = groundclickpos.x;
    local centerY = groundclickpos.y;
    local z = groundclickpos.z;

    local vBuildingCenter = Vector(centerX,centerY,z)


    if modelParticle ~= nil then
        -- move model ghost particle
        ParticleManager:SetParticleControl(modelParticle, 0, vBuildingCenter)

        -- this stuff is not done yet. Recolor model green probably best
        if RECOLOR_GHOST_MODEL then
            if areaBlocked then
                ParticleManager:SetParticleControl(modelParticle, 2, Vector(255,0,0))   
            else
                ParticleManager:SetParticleControl(modelParticle, 2, Vector(0,255,0))
            end
        else
            ParticleManager:SetParticleControl(modelParticle, 2, Vector(255,255,255)) -- Draws the ghost with the original colors
        end
    end
]]

end

function removeGhost(keys)
    local player = keys.caster:GetPlayerOwner()

    if player ~= nil then

        if player.ghostParticle ~= nil then
            ParticleManager:DestroyParticle(player.ghostParticle, true)
            player.ghostParticle = nil
        end
        if player.modelGhostDummy ~= nil then
            player.modelGhostDummy:RemoveSelf()
            player.modelGhostDummy = nil
        end
    
    end
end


function placeBuilding(keys)
    if(keys.caster:GetTeam()==3) then
        return nil;
    end

    PLACED_BUILDING_RADIUS = 45.0;

    blocking_counter = 0

    groundclickpos = GetGroundPosition(keys.target_points[1], nil)

    xpos = GridNav:WorldToGridPosX(groundclickpos.x)
    ypos = GridNav:WorldToGridPosY(groundclickpos.y)

    groundclickpos.x = GridNav:GridPosToWorldCenterX(xpos)
    groundclickpos.y = GridNav:GridPosToWorldCenterY(ypos)


    if GridNav:IsTraversable(groundclickpos) then
    else
        blocking_counter = blocking_counter + 1
    end

    for _,thing in pairs(Entities:FindAllInSphere(groundclickpos, PLACED_BUILDING_RADIUS) )  do
        if thing:GetClassname() == "npc_dota_creep" or string.match(thing:GetClassname(),"npc_dota_hero") then
            blocking_counter = blocking_counter + 1
        end
    end

    if( blocking_counter < 1) then

        --tower = CreateUnitByName("npc_treetag_building_mine_1", groundclickpos, false, keys.caster, keys.caster, keys.caster:GetPlayerOwner():GetTeam() ) 

        --tower = CreateUnitByName("npc_treetag_building_mine_1", groundclickpos, false, nil, nil, keys.caster:GetTeam() ) 
        --tower:SetContext("tagtype", "npc_treetag_building_mine", 0)
        --tower:SetContext("tagtypelevel", "1", 0)
        --tower:SetAngles(0.0,90.0,0.0)
        --tower:SetOwner(keys.caster:GetPlayerOwner():GetAssignedHero());

        tower = CreateUnitByName("npc_treetag_building_mine_1", groundclickpos, false, keys.caster, keys.caster:GetOwner(), keys.caster:GetTeamNumber() ) 
        
        if tower ~= nil then
            tower:SetAngles(0.0,90.0,0.0)
            tower:SetControllableByPlayer(keys.caster:GetPlayerID(), true);
            tower:SetOwner(keys.caster:GetPlayerOwner():GetAssignedHero());
            learnabilities(tower)
        end

        --tower:SetControllableByPlayer(keys.caster:GetPlayerOwner():GetPlayerID(), true);
        keys.caster:GetItemInSlot(0):SetActivated(false)
    else
        keys.caster:ModifyGold(keys.AbilityGoldCost,false,0)
        sendError(keys.caster:GetPlayerOwnerID(), "Cannot build there")
        keys.caster:GetItemInSlot(0):StartCooldown(0.5)
    end
end

function spawnghost(keys)
    print("spawning ghost");
    if keys.caster:GetClassname() == "npc_dota_hero_furion" then
        local helper = CreateUnitByName("npc_treetag_radiant_ghost_furion",
            keys.caster:GetAbsOrigin(), false, keys.caster, keys.caster:GetOwner(), keys.caster:GetTeamNumber()) 
        
        if helper ~= nil then
            helper:SetAngles(0.0,90.0,0.0)
            helper:SetControllableByPlayer(keys.caster:GetPlayerID(), true);
            helper:SetOwner(keys.caster:GetPlayerOwner():GetAssignedHero());
            learnabilities(helper)
        end
    else 
        local helper = CreateUnitByName("npc_treetag_radiant_ghost", keys.caster:GetAbsOrigin(), false, keys.caster, keys.caster:GetOwner(), keys.caster:GetTeamNumber() ) 
        
        if helper ~= nil then
            helper:SetAngles(0.0,90.0,0.0)
            helper:SetControllableByPlayer(keys.caster:GetPlayerID(), true);
            helper:SetOwner(keys.caster:GetPlayerOwner():GetAssignedHero());
            learnabilities(helper)
        end
    end
end

function spawnghostdire(keys)
    print("spawning ghost");
    local helper = CreateUnitByName("npc_treetag_dire_ghost", keys.caster:GetAbsOrigin(), false, keys.caster, keys.caster:GetOwner(), keys.caster:GetTeamNumber() ) 
    
    if helper ~= nil then
        helper:SetAngles(0.0,90.0,0.0)
        helper:SetControllableByPlayer(keys.caster:GetPlayerID(), true);
        helper:SetOwner(keys.caster:GetPlayerOwner():GetAssignedHero());
            learnabilities(helper)
    end
end

function placeWall(keys)
    if(keys.caster:GetTeam()==3) then
        return nil;
    end
    PLACED_BUILDING_RADIUS = 45.0;
    blocking_counter = 0

    local groundclickpos = GetGroundPosition(keys.target_points[1], nil)
    local xpos = GridNav:WorldToGridPosX(groundclickpos.x)
    local ypos = GridNav:WorldToGridPosY(groundclickpos.y)
    groundclickpos.x = GridNav:GridPosToWorldCenterX(xpos)
    groundclickpos.y = GridNav:GridPosToWorldCenterY(ypos)

    if GridNav:IsTraversable(groundclickpos) then
    else
        blocking_counter = blocking_counter + 1
    end

    for _,thing in pairs(Entities:FindAllInSphere(groundclickpos, PLACED_BUILDING_RADIUS) )  do
        if thing:GetClassname() == "npc_dota_creep" or string.match(thing:GetClassname(),"npc_dota_hero") then
            blocking_counter = blocking_counter + 1
        end
    end
    if( blocking_counter < 1) then
        tower = CreateUnitByName("npc_treetag_building_wall_1", groundclickpos, false, keys.caster, keys.caster:GetOwner(), keys.caster:GetTeamNumber())

        if tower ~= nil then
            tower:SetContext("tagtype", "npc_treetag_building_wall", 0)
            tower:SetContext("tagtypelevel", "1", 0)
            tower:SetOwner(keys.caster:GetPlayerOwner():GetAssignedHero());
            tower:SetControllableByPlayer(keys.caster:GetPlayerID(), true);
            learnabilities(tower)
        end

    else
        keys.caster:ModifyGold(keys.AbilityGoldCost,false,0)
        sendError(keys.caster:GetPlayerOwnerID(), "Cannot build there")
    end
end

function learnyourfuckingspells(keys)
    learnabilities(keys.target)
end

function learnabilities(unit)

    if unit==nil then 
        return nil;
    end
    if not unit:IsAlive() then
        return nil;
    end

    for aaaai=0, unit:GetAbilityCount()-1 do
        local aab = unit:GetAbilityByIndex(aaaai)
        if aab ~= nil then
            if aab:GetLevel() <1 then
                aab:SetLevel(1)
            end
        end
    end
end

function placeTurret(keys)
    if(keys.caster:GetTeam()==3) then
        return nil;
    end
    PLACED_BUILDING_RADIUS = 45.0;

    blocking_counter = 0
    attempt_place_location = keys.target_points[1]

    local groundclickpos = GetGroundPosition(attempt_place_location, nil)
    local xpos = GridNav:WorldToGridPosX(groundclickpos.x)
    local ypos = GridNav:WorldToGridPosY(groundclickpos.y)
    groundclickpos.x = GridNav:GridPosToWorldCenterX(xpos)
    groundclickpos.y = GridNav:GridPosToWorldCenterY(ypos)

    if GridNav:IsTraversable(groundclickpos) then
    else
        blocking_counter = blocking_counter + 1
    end

    for _,thing in pairs(Entities:FindAllInSphere(groundclickpos, PLACED_BUILDING_RADIUS) )  do
        if thing:GetClassname() == "npc_dota_creep" or string.match(thing:GetClassname(),"npc_dota_hero") then
            blocking_counter = blocking_counter + 1
        end
    end

    if( blocking_counter < 1) then
        tower = CreateUnitByName("npc_treetag_building_turret_1", groundclickpos, false, keys.caster, keys.caster:GetOwner(), keys.caster:GetTeamNumber())
        if tower ~= nil then
            tower:SetControllableByPlayer(keys.caster:GetPlayerID(), true);
            tower:SetOwner(keys.caster:GetPlayerOwner():GetAssignedHero());
            learnabilities(tower)
        end
    else
        keys.caster:ModifyGold(keys.AbilityGoldCost,false,0)
        sendError(keys.caster:GetPlayerOwnerID(), "Cannot build there")
    end
end

function placewell(keys)
    if(keys.caster:GetTeam()==3) then
        return nil;
    end
    PLACED_BUILDING_RADIUS = 45.0;

    blocking_counter = 0
    attempt_place_location = keys.target_points[1]

    local groundclickpos = GetGroundPosition(attempt_place_location, nil)
    local xpos = GridNav:WorldToGridPosX(groundclickpos.x)
    local ypos = GridNav:WorldToGridPosY(groundclickpos.y)
    groundclickpos.x = GridNav:GridPosToWorldCenterX(xpos)
    groundclickpos.y = GridNav:GridPosToWorldCenterY(ypos)

    if GridNav:IsTraversable(groundclickpos) then
    else
        blocking_counter = blocking_counter + 1
    end

    for _,thing in pairs(Entities:FindAllInSphere(groundclickpos, PLACED_BUILDING_RADIUS) )  do
        if thing:GetClassname() == "npc_dota_creep" or string.match(thing:GetClassname(),"npc_dota_hero") then
            blocking_counter = blocking_counter + 1
        end
    end
    if( blocking_counter < 1) then
        local tower = CreateUnitByName("npc_treetag_building_well_1", groundclickpos, false, keys.caster, keys.caster:GetOwner(), keys.caster:GetTeamNumber())
        if tower ~= nil then
            tower:SetAngles(0.0,90.0,0.0)
            tower:SetControllableByPlayer(keys.caster:GetPlayerID(), true);
            tower:SetOwner(keys.caster:GetPlayerOwner():GetAssignedHero());
            learnabilities(tower)
        end
    else
        keys.caster:ModifyGold(keys.AbilityGoldCost,false,0)
        sendError(keys.caster:GetPlayerOwnerID(), "Cannot build there")
    end
end





function endManyTreesSetCooldown(keys)
    keys.ability:StartCooldown(60)
end


watchingtree=false

function manageancients(keys)
    if keys.caster:HasModifier("waitingforend") then
        return      -- end buff has not been added: main game still in progress
    end

    -- give radiant stun ability
    for _,hero in pairs(HeroList:GetAllHeroes()) do
        if hero:GetTeam() == 2 then
            hero:AddAbility("drainstun")
            hero:SwapAbilities("drainstun", hero:GetAbilityByIndex(0):GetAbilityName(), true, false)
            hero:GetAbilityByIndex(0):SetLevel(1)
        end
    end

    -- remove ancbuff (buff hiding healthbars etc)
    keys.caster:RemoveModifierByName("ancbuff")

    -- set tree hp to half
    if keys.caster:GetUnitName() == "npc_treetag_bigtree" then
        keys.caster:SetHealth(math.floor(keys.caster:GetMaxHealth()*0.5))
        watchingtree=true
    end
end



ancientphasedone = false

function createmoditem(caster)
    if not moditem then
        moditem = CreateItem( "item_apply_modifiers", caster, caster )
    end
end

function managebigtree(keys)
    if ancientphasedone then
        keys.caster:SetModel("models/props_tree/dire_tree006.vmdl")
        while keys.caster:HasModifier("healerer") do
            keys.caster:RemoveModifierByName("healerer")
        end
        return
    end
    if watchingtree then
        if keys.caster:GetHealth()>=keys.caster:GetMaxHealth() then
            createmoditem(keys.caster)
            moditem:ApplyDataDrivenModifier(keys.caster, keys.caster, "ancientdone", {duration="-1"})
            GameRules:GetGameModeEntity():SetFogOfWarDisabled(true)
            for _,hero in pairs(HeroList:GetAllHeroes()) do
                if hero:GetTeam() == 2 then
                    createmoditem(hero)
                    moditem:ApplyDataDrivenModifier(hero, hero, "megatree", {duration="-1"})
                    hero:SetModelScale(2.2)
                end
            end
            ancientphasedone = true
        end
    end
end

function radiantinvisthink(keys)
    if ancientphasedone then
        return 1
    end
    if watchingtree then
        if keys.caster:HasAbility("drainstun") then
            return 10
        else
            keys.caster:AddAbility("drainstun")
            keys.caster:SwapAbilities("drainstun", keys.caster:GetAbilityByIndex(0):GetAbilityName(), true, false)
            keys.caster:GetAbilityByIndex(0):SetLevel(1)
            return 10
        end
    end
    return 10
end


function treedied(keys)
    if ancientphasedone then
        return
    end
    GameRules:GetGameModeEntity():SetFogOfWarDisabled(true)
    for _,hero in pairs(HeroList:GetAllHeroes()) do
        if hero:GetTeam() == 3 then
            createmoditem(hero)
            moditem:ApplyDataDrivenModifier(hero, hero, "megatree", {duration="-1"})
            hero:SetModelScale(2.2)
        end
    end
    -- todo:  keys.caster:SetModel(blabla) ?
    ancientphasedone = true
end

function suicidefarm(keys)
    -- farm refund amounts
    if keys.caster:GetUnitName() == "npc_treetag_building_mine_2" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(50,true,0)
    elseif keys.caster:GetUnitName() == "npc_treetag_building_mine_3" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(100+50,true,0)
    elseif keys.caster:GetUnitName() == "npc_treetag_building_mine_4" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(200+100+50,true,0)
    elseif keys.caster:GetUnitName() == "npc_treetag_building_mine_5" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(400+200+100+50,true,0)
    elseif keys.caster:GetUnitName() == "npc_treetag_building_mine_6" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(800+400+200+100+50,true,0)
        keys.caster:GetPlayerOwner():GetAssignedHero():GiveMana(32)
    elseif keys.caster:GetUnitName() == "npc_treetag_building_mine_7" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(1600+800+400+200+100+50,true,0)
        keys.caster:GetPlayerOwner():GetAssignedHero():GiveMana(64+32)
    elseif keys.caster:GetUnitName() == "npc_treetag_building_mine_8" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(3200+1600+800+400+200+100+50,true,0)
        keys.caster:GetPlayerOwner():GetAssignedHero():GiveMana(128+64+32)
    elseif keys.caster:GetUnitName() == "npc_treetag_building_mine_9" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(6400+1600+800+400+200+100+50,true,0)
        keys.caster:GetPlayerOwner():GetAssignedHero():GiveMana(256+128+64+32)
    elseif keys.caster:GetUnitName() == "npc_treetag_building_mine_10" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(12800+6400+1600+800+400+200+100+50,true,0)
        keys.caster:GetPlayerOwner():GetAssignedHero():GiveMana(512+256+128+64+32)
    end

    keys.caster:GetPlayerOwner():GetAssignedHero():GetItemInSlot(0):SetActivated(true)
    keys.caster:RemoveSelf()   -- must come AFTER refunds
end

function resetfarm(keys)
    if keys.caster:GetPlayerOwner() == nil then
        return
    end
    keys.caster:GetPlayerOwner():GetAssignedHero():GetItemInSlot(0):SetActivated(true)
end

function swapteam(keys)
    print("Current team of player "..keys.caster:GetPlayerOwnerID()..": "..keys.caster:GetTeam())
    if keys.caster:GetTeam()==2 then
        local newteam = 3;
        local owner = keys.caster:GetOwner();
        owner:SetTeam(newteam);
        keys.caster:SetTeam(newteam);
        print("new team: "..newteam);
    elseif keys.caster:GetTeam()==3 then
        local newteam = 2;
        local owner = keys.caster:GetOwner();
        owner:SetTeam(newteam);
        keys.caster:SetTeam(newteam);
        print("new team: "..newteam);
    end
end

function explosionsoundoncaster(keys)
    EmitSoundOnLocationWithCaster(keys.caster:GetAbsOrigin(),"Creep_Siege_Radiant.Destruction",keys.caster)
end

function suicide(keys)
    local refundwallmod = 0.75
    local refundwallmodmana = 0.75

    if keys.caster:GetUnitName() == "npc_treetag_building_wall_1" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(math.floor(refundwallmod*(4)),true,0)
    elseif keys.caster:GetUnitName() == "npc_treetag_building_wall_2" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(math.floor(refundwallmod*(12)),true,0)
    elseif keys.caster:GetUnitName() == "npc_treetag_building_wall_3" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(math.floor(refundwallmod*(28)),true,0)
    elseif keys.caster:GetUnitName() == "npc_treetag_building_wall_4" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(math.floor(refundwallmod*(60)),true,0)
    elseif keys.caster:GetUnitName() == "npc_treetag_building_wall_5" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(math.floor(refundwallmod*(124)),true,0)
    elseif keys.caster:GetUnitName() == "npc_treetag_building_wall_6" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(math.floor(refundwallmod*(252)),true,0)
    elseif keys.caster:GetUnitName() == "npc_treetag_building_wall_7" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(math.floor(refundwallmod*(508)),true,0)
    elseif keys.caster:GetUnitName() == "npc_treetag_building_wall_8" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(math.floor(refundwallmod*(1020)),true,0)
    elseif keys.caster:GetUnitName() == "npc_treetag_building_wall_9" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(math.floor(refundwallmod*(2044)),true,0)
    elseif keys.caster:GetUnitName() == "npc_treetag_building_wall_10" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(math.floor(refundwallmod*(4092)),true,0)
    elseif keys.caster:GetUnitName() == "npc_treetag_building_wall_11" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(math.floor(refundwallmod*(8188)),true,0)
        keys.caster:GetPlayerOwner():GetAssignedHero():GiveMana(math.floor(refundwallmodmana*(32)))
    elseif keys.caster:GetUnitName() == "npc_treetag_building_wall_12" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(math.floor(refundwallmod*(16380)),true,0)
        keys.caster:GetPlayerOwner():GetAssignedHero():GiveMana(math.floor(refundwallmodmana*(96)))
    elseif keys.caster:GetUnitName() == "npc_treetag_building_wall_13" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(math.floor(refundwallmod*(32764)),true,0)
        keys.caster:GetPlayerOwner():GetAssignedHero():GiveMana(math.floor(refundwallmodmana*(224)))
    elseif keys.caster:GetUnitName() == "npc_treetag_building_wall_14" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(math.floor(refundwallmod*(65532)),true,0)
        keys.caster:GetPlayerOwner():GetAssignedHero():GiveMana(math.floor(refundwallmodmana*(480)))
    elseif keys.caster:GetUnitName() == "npc_treetag_building_wall_15" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(math.floor(refundwallmod*(131068)),true,0)
        keys.caster:GetPlayerOwner():GetAssignedHero():GiveMana(math.floor(refundwallmodmana*(992)))
    elseif keys.caster:GetUnitName() == "npc_treetag_building_wall_16" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(math.floor(refundwallmod*(262140)),true,0)
        keys.caster:GetPlayerOwner():GetAssignedHero():GiveMana(math.floor(refundwallmodmana*(2016)))

    elseif keys.caster:GetUnitName() == "npc_treetag_building_well_1" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(64,true,0)
    elseif keys.caster:GetUnitName() == "npc_treetag_building_well_2" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(192,true,0)
    elseif keys.caster:GetUnitName() == "npc_treetag_building_well_3" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(448,true,0)

    elseif keys.caster:GetUnitName() == "npc_treetag_building_turret_1" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(8,true,0)
    elseif keys.caster:GetUnitName() == "npc_treetag_building_turret_2" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(32,true,0)
    elseif keys.caster:GetUnitName() == "npc_treetag_building_turret_3" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(64,true,0)
    elseif keys.caster:GetUnitName() == "npc_treetag_building_turret_4" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(128,true,0)
    elseif keys.caster:GetUnitName() == "npc_treetag_building_turret_5" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(256,true,0)
    elseif keys.caster:GetUnitName() == "npc_treetag_building_turret_6" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(512,true,0)
    elseif keys.caster:GetUnitName() == "npc_treetag_building_turret_7" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(1024,true,0)
        keys.caster:GetPlayerOwner():GetAssignedHero():GiveMana(16)
    elseif keys.caster:GetUnitName() == "npc_treetag_building_turret_8" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(2048,true,0)
        keys.caster:GetPlayerOwner():GetAssignedHero():GiveMana(48)
    elseif keys.caster:GetUnitName() == "npc_treetag_building_turret_9" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(4096,true,0)
        keys.caster:GetPlayerOwner():GetAssignedHero():GiveMana(64+48)
    elseif keys.caster:GetUnitName() == "npc_treetag_building_turret_10" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(8192,true,0)
        keys.caster:GetPlayerOwner():GetAssignedHero():GiveMana(128+64+48)
    elseif keys.caster:GetUnitName() == "npc_treetag_building_turret_11" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(999999,true,0)
        keys.caster:GetPlayerOwner():GetAssignedHero():GiveMana(2000+128+64+48)
    elseif keys.caster:GetUnitName() == "npc_treetag_building_turret_12" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(999999,true,0)
        keys.caster:GetPlayerOwner():GetAssignedHero():GiveMana(3000+2000+128+64+48)
    elseif keys.caster:GetUnitName() == "npc_treetag_building_turret_13" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(999999,true,0)
        keys.caster:GetPlayerOwner():GetAssignedHero():GiveMana(4000+3000+2000+128+64+48)
    end

    keys.caster:RemoveSelf()   -- must come after refunds because checking info of unit
end

function destroy_aoe(keys)
    groundclickpos = GetGroundPosition(keys.target_points[1], nil)
    for _,sudoku in pairs(Entities:FindAllByClassnameWithin("npc_dota_creep", groundclickpos, tonumber(keys.Radius))) do
        if keys.caster:GetPlayerOwnerID() == sudoku:GetPlayerOwnerID() then
            if sudoku:HasAbility("destroy_unit") then
                sudoku:Interrupt()
                sudoku:InterruptChannel()
                sudoku:CastAbilityNoTarget(sudoku:FindAbilityByName("destroy_unit"), sudoku:GetPlayerOwnerID())
            elseif sudoku:HasAbility("destroy_farm") then
                sudoku:Interrupt()
                sudoku:InterruptChannel()
                sudoku:CastAbilityNoTarget(sudoku:FindAbilityByName("destroy_farm"), sudoku:GetPlayerOwnerID())
            end
        end
    end
end

function maketargetsudoku(keys)
    tprint(keys)
    local sudoku = keys.target;
    if keys.caster:GetPlayerOwnerID() == sudoku:GetPlayerOwnerID() then
        if sudoku:HasAbility("destroy_unit") then
            sudoku:Interrupt()
            sudoku:InterruptChannel()
            sudoku:CastAbilityNoTarget(sudoku:FindAbilityByName("destroy_unit"), sudoku:GetPlayerOwnerID())
        elseif sudoku:HasAbility("destroy_farm") then
            sudoku:Interrupt()
            sudoku:InterruptChannel()
            sudoku:CastAbilityNoTarget(sudoku:FindAbilityByName("destroy_farm"), sudoku:GetPlayerOwnerID())
        end
    else
        keys.caster:Interrupt()
        keys.caster:InterruptChannel()
    end
end

-- set caster's mana to assigned hero's mana
function ownermana(keys)
    local ownermana = keys.caster:GetPlayerOwner():GetAssignedHero():GetMana();
    local maxmana = keys.caster:GetMaxMana();

    if ownermana > maxmana then
        keys.caster:SetMana(maxmana);
    else
        keys.caster:SetMana(ownermana);
    end
end

function collectmanafromspirits(keys)
    for _,spirit in pairs(Entities:FindAllByClassname("npc_dota_creep") )  do
        if keys.caster:GetPlayerOwnerID() == spirit:GetPlayerOwnerID() then
            if string.find(spirit:GetUnitName(),"npc_treetag_spirit") then
                if keys.caster:GetMana()>=keys.caster:GetMaxMana() then
                    --print("well full")
                elseif spirit:GetMana()<=0 then
                    --print("spirit not full yet: "..keys.caster:GetMana().."/"..keys.caster:GetMaxMana())
                else
                    keys.caster:GiveMana(spirit:GetMana())
                    spirit:SpendMana(spirit:GetMana(), nil)
                end
            end
        end
    end
end

--used for cosmetic pets in a thinker
function followcaster(keys)
    if keys.target == nil then
        return nil
    end
    if keys.caster == nil then
        keys.target:RemoveSelf()
        return
    end
    if not keys.caster:IsAlive() then
        keys.target:RemoveSelf()
        return
    end
    
    local dist = CalcDistanceBetweenEntityOBB(keys.caster,keys.target);
    if dist > 450 then
        FindClearSpaceForUnit( keys.target, keys.caster:GetAbsOrigin(), true )
    end

    if dist > 60 then
        --keys.target:MoveToNPC(keys.caster)

        --local difvec = keys.target:GetAbsOrigin()+keys.caster:GetAbsOrigin()

        --local targetloc = keys.caster:GetAbsOrigin()-65*difvec:Normalized()
        local targetloc = keys.caster:GetAbsOrigin()

        local randomvec = Vector(math.random()*2-1,math.random()*2-1,0)

        targetloc = targetloc + randomvec:Normalized()*50

        keys.target:MoveToPosition(targetloc)
    end
end

function validatesuicidetarget(keys)
    if keys.target:GetPlayerOwner()~=keys.caster:GetPlayerOwner() then
        keys.caster:Interrupt()
        keys.caster:InterruptChannel()
        return nil
    end

    keys.ability.suicidetarget = keys.target

    if string.find(keys.ability.suicidetarget:GetUnitName(),"npc_treetag_building_wall") then
    elseif string.find(keys.ability.suicidetarget:GetUnitName(),"npc_treetag_building_turret") then
    elseif string.find(keys.ability.suicidetarget:GetUnitName(),"npc_treetag_building_well") then
    else
        keys.caster:Interrupt()
        keys.caster:InterruptChannel()
        sendError(keys.caster:GetPlayerOwnerID(), "That unit cannot be sacrificed")
        return nil
    end

end

--used for suicide squad in a thinker
function suicideattack(keys)
    if keys.target == nil then
        return nil
    end
    if keys.target:IsNull() then
        return nil
    end
    if keys.target:IsChanneling() then
        return nil
    end
    if keys.ability.suicidetarget == nil then
        keys.target:RemoveSelf()
        return nil
    end
    if not keys.ability.suicidetarget:IsAlive() then
        keys.target:RemoveSelf()
        return nil
    end

    local dist = CalcDistanceBetweenEntityOBB(keys.ability.suicidetarget,keys.target);

    if dist < 30 then
        if string.find(keys.ability.suicidetarget:GetUnitName(),"npc_treetag_building_wall") then
            keys.target:AddAbility("techies_stun")
            local abzx2 = keys.target:FindAbilityByName("techies_stun")
            abzx2:SetAbilityIndex(1)

            local nlevel = 7
            local unm = keys.ability.suicidetarget:GetUnitName()
            if unm == "npc_treetag_building_wall_1" then
                nlevel=1
            elseif unm == "npc_treetag_building_wall_2" then
                nlevel=2
            elseif unm == "npc_treetag_building_wall_3" then
                nlevel=3
            elseif unm == "npc_treetag_building_wall_4" then
                nlevel=4
            elseif unm == "npc_treetag_building_wall_5" then
                nlevel=5
            elseif unm == "npc_treetag_building_wall_6" then
                nlevel=6
            end
            abzx2:SetLevel(nlevel)

            keys.target:CastAbilityNoTarget(abzx2, keys.target:GetPlayerOwnerID())
            keys.target:RemoveModifierByName("suicidesquadbuff")
            keys.ability.suicidetarget:RemoveSelf()
        elseif string.find(keys.ability.suicidetarget:GetUnitName(),"npc_treetag_building_turret") then
            keys.target:AddAbility("techies_explode")
            local abzx2 = keys.target:FindAbilityByName("techies_explode")
            abzx2:SetAbilityIndex(1)

            local nlevel = 7
            local unm = keys.ability.suicidetarget:GetUnitName()
            if unm == "npc_treetag_building_turret_1" then
                nlevel=1
            elseif unm == "npc_treetag_building_turret_2" then
                nlevel=2
            elseif unm == "npc_treetag_building_turret_3" then
                nlevel=3
            elseif unm == "npc_treetag_building_turret_4" then
                nlevel=4
            elseif unm == "npc_treetag_building_turret_5" then
                nlevel=5
            elseif unm == "npc_treetag_building_turret_6" then
                nlevel=6
            end
            abzx2:SetLevel(nlevel)

            keys.target:CastAbilityNoTarget(abzx2, keys.target:GetPlayerOwnerID())
            keys.target:RemoveModifierByName("suicidesquadbuff")
            keys.ability.suicidetarget:RemoveSelf()
        elseif string.find(keys.ability.suicidetarget:GetUnitName(),"npc_treetag_building_well") then
            keys.target:AddAbility("techies_emp")
            local abzx2 = keys.target:FindAbilityByName("techies_emp")
            abzx2:SetAbilityIndex(1)

            local nlevel = 3
            local unm = keys.ability.suicidetarget:GetUnitName()
            if unm == "npc_treetag_building_well_1" then
                nlevel=1
            elseif unm == "npc_treetag_building_well_2" then
                nlevel=2
            end
            abzx2:SetLevel(nlevel)

            keys.target:CastAbilityNoTarget(abzx2, keys.target:GetPlayerOwnerID())
            keys.target:RemoveModifierByName("suicidesquadbuff")
            keys.ability.suicidetarget:RemoveSelf()
        end
    else
        keys.target:MoveToPosition(keys.ability.suicidetarget:GetAbsOrigin())
    end


end

-- EMP suicide ability
function empaoe(keys)
    print(keys.manadrain)
    for _,targetenemy in pairs(keys.target_entities) do
        local manadrained = math.max(targetenemy:GetMana()-keys.manadrain,0)
        targetenemy:SetMana(manadrained)
    end
end




function speedifnobuildings(keys)
    for _,unit in pairs( Entities:FindAllByClassnameWithin("npc_dota_creep", keys.caster:GetAbsOrigin(), 500)) do
        if unit:GetTeam() == keys.caster:GetTeam() then
            if string.find(unit:GetUnitName(), "npc_treetag_building_turret") 
            or string.find(unit:GetUnitName(), "npc_treetag_building_wall") 
            or string.find(unit:GetUnitName(), "npc_treetag_building_well")
            or string.find(unit:GetUnitName(), "npc_treetag_building_mine") then
                return 0.5
            end
        end
    end

    createmoditem(keys.caster)
    moditem:ApplyDataDrivenModifier(keys.caster, keys.caster, "lone_wolf", {duration="0.6"})

end


function followcasterfurion(keys)
    if keys.target == nil then
        return nil
    end
    if keys.caster == nil then
        keys.target:RemoveSelf()
        return
    end
    if not keys.caster:IsAlive() then
        keys.target:RemoveSelf()
        return
    end

    local dist = CalcDistanceBetweenEntityOBB(keys.caster,keys.target);
    if dist > 500 then
        FindClearSpaceForUnit( keys.target, keys.caster:GetAbsOrigin(), true )
    end

    keys.target:MoveToNPC(keys.caster)
    --keys.target:MoveToPosition(keys.caster:GetAbsOrigin())
end


function toggleautocast(keys)
    keys.ability:ToggleAutoCast()
end

-- spirit collecting mana from trees
function acquiremana(keys)
    if keys.Mana == "max" then
        -- if spirit is in gold zone give full mana otherwise give half of full mana;   Go and double the max mana of spirits to compensate for this

        -- round up most of the time kkkkkkk
        local mana = math.floor( 0.01 * keys.caster:GetMaxMana() );

        if keys.caster:HasModifier("fastmine") then
            mana = math.floor( 0.01 * keys.caster:GetMaxMana() * 1.2 + 0.9 )
        end

        keys.caster:GiveMana(mana)


        -- pop mana numbers up above spirit
        popupNumbers(keys.caster, "gold", Vector(0, 150, 255), 1.0, mana, nil, nil)


    else
        keys.caster:GiveMana(tonumber(keys.Mana))
    end
end




function removedrainstun(keys)
    if keys.target==nil or keys.target:IsNull() then 
        return nil
    end
    if not keys.target:IsAlive() then
        return nil
    end
    if keys.target:HasModifier("drainstun") then
        keys.target:RemoveModifierByName("drainstun")
    end
end




-- spirit thinker, find trees and go sap them
function manacollectautocast(keys)
    if not keys.ability:GetAutoCastState() then
        return
    end
    if not keys.caster:IsIdle() then
        return
    end
    if not keys.ability:IsCooldownReady() then
        return
    end

    for _,tree in pairs(GridNav:GetAllTreesAroundPoint(GetGroundPosition(keys.target:GetOrigin(),nil), 75, true) )  do
        if tree:IsStanding() then
            local inuse = false
            for _,otherspirit in pairs(Entities:FindAllByClassnameWithin("npc_dota_creep",GetGroundPosition(tree:GetOrigin(),nil), 15) )  do
                if string.find(otherspirit:GetUnitName(),"npc_treetag_spirit") then
                    if otherspirit ~= keys.caster then
                        inuse=true
                        break
                    end
                end
            end
            if not inuse then
                keys.caster:CastAbilityOnTarget(tree, keys.ability, keys.caster:GetPlayerOwnerID())
                return
            end
        end
    end

    for _,tree in pairs(GridNav:GetAllTreesAroundPoint(GetGroundPosition(keys.target:GetOrigin(),nil), 150, true) )  do
        if tree:IsStanding() then
            local inuse = false
            for _,otherspirit in pairs(Entities:FindAllByClassnameWithin("npc_dota_creep",GetGroundPosition(tree:GetOrigin(),nil), 15) )  do
                if string.find(otherspirit:GetUnitName(),"npc_treetag_spirit") then
                    if otherspirit ~= keys.caster then
                        inuse=true
                        break
                    end
                end
            end
            if not inuse then
                keys.caster:CastAbilityOnTarget(tree, keys.ability, keys.caster:GetPlayerOwnerID())
                return
            end
        end
    end

    for _,tree in pairs(GridNav:GetAllTreesAroundPoint(GetGroundPosition(keys.target:GetOrigin(),nil), 280, true) )  do
        if tree:IsStanding() then
            local inuse = false
            for _,otherspirit in pairs(Entities:FindAllByClassnameWithin("npc_dota_creep",GetGroundPosition(tree:GetOrigin(),nil), 15) )  do
                if string.find(otherspirit:GetUnitName(),"npc_treetag_spirit") then
                    if otherspirit ~= keys.caster then
                        inuse=true
                        break
                    end
                end
            end
            if not inuse then
                keys.caster:CastAbilityOnTarget(tree, keys.ability, keys.caster:GetPlayerOwnerID())
                return
            end
        end
    end
end

function recastcollectmana(keys)

    if keys.target:IsStanding() then
        local inuse = false
        for _,otherspirit in pairs(Entities:FindAllByClassnameWithin("npc_dota_creep",GetGroundPosition(keys.target:GetOrigin(),nil), 15) )  do
            if string.find(otherspirit:GetUnitName(),"npc_treetag_spirit") then
                if otherspirit ~= keys.caster then
                    inuse=true
                        break
                end
            end
        end
        if not inuse then
            keys.caster:CastAbilityOnTarget(tree, keys.ability, keys.caster:GetPlayerOwnerID())
            return
        end
    end

    for _,tree in pairs(GridNav:GetAllTreesAroundPoint(GetGroundPosition(keys.target:GetOrigin(),nil), 75, true) )  do
        if tree:IsStanding() then
            local inuse = false
            for _,otherspirit in pairs(Entities:FindAllByClassnameWithin("npc_dota_creep",GetGroundPosition(tree:GetOrigin(),nil), 15) )  do
                if string.find(otherspirit:GetUnitName(),"npc_treetag_spirit") then
                    if otherspirit ~= keys.caster then
                        inuse=true
                        break
                    end
                end
            end
            if not inuse then
                keys.caster:CastAbilityOnTarget(tree, keys.ability, keys.caster:GetPlayerOwnerID())
                return
            end
        end
    end

    for _,tree in pairs(GridNav:GetAllTreesAroundPoint(GetGroundPosition(keys.target:GetOrigin(),nil), 150, true) )  do
        if tree:IsStanding() then
            local inuse = false
            for _,otherspirit in pairs(Entities:FindAllByClassnameWithin("npc_dota_creep",GetGroundPosition(tree:GetOrigin(),nil), 15) )  do
                if string.find(otherspirit:GetUnitName(),"npc_treetag_spirit") then
                    if otherspirit ~= keys.caster then
                        inuse=true
                        break
                    end
                end
            end
            if not inuse then
                keys.caster:CastAbilityOnTarget(tree, keys.ability, keys.caster:GetPlayerOwnerID())
                return
            end
        end
    end

    for _,tree in pairs(GridNav:GetAllTreesAroundPoint(GetGroundPosition(keys.target:GetOrigin(),nil), 280, true) )  do
        if tree:IsStanding() then
            local inuse = false
            for _,otherspirit in pairs(Entities:FindAllByClassnameWithin("npc_dota_creep",GetGroundPosition(tree:GetOrigin(),nil), 15) )  do
                if string.find(otherspirit:GetUnitName(),"npc_treetag_spirit") then
                    if otherspirit ~= keys.caster then
                        inuse=true
                        break
                    end
                end
            end
            if not inuse then
                keys.caster:CastAbilityOnTarget(tree, keys.ability, keys.caster:GetPlayerOwnerID())
                return
            end
        end
    end
end

function emptymana(keys)
    keys.caster:SetMana(0)
end

-- hero taking mana from mana well
function takemanafromwell(keys)
    if keys.caster:GetMana() >= keys.caster:GetMaxMana() then
        return
    end
    for _,well in pairs(Entities:FindAllByClassnameWithin("npc_dota_creep",GetGroundPosition(keys.caster:GetOrigin(),nil), 600) )  do
        if keys.caster:GetPlayerOwnerID() == well:GetPlayerOwnerID() then
            --if (well:GetUnitName() == "npc_treetag_building_well_1") then
            if string.find(well:GetUnitName(), "npc_treetag_building_well") then
                manaamt = 10 + math.floor(0.3*well:GetMana())
                if manaamt>=well:GetMana() then
                    manaamt = well:GetMana()-1
                end

                well:SpendMana(manaamt, nil)
                keys.target:GiveMana(manaamt)

                if manaamt > 0 then

                    -- pop mana numbers up above hero
                    popupNumbers(keys.caster, "gold", Vector(0, 150, 255), 1.0, manaamt, nil, nil)

                    createmoditem(keys.caster)
                    -- todo: beam temporarily disabled because reborn makes it permanent. Thanks volvo
                    --moditem:ApplyDataDrivenModifier(keys.caster, well, "beamtarget", {duration=0.1})
                end
            end
        end
    end

end

function spiritthink(keys)

    for _,thing in pairs(Entities:FindAllByClassnameWithin("npc_dota_creep",GetGroundPosition(keys.target:GetOrigin(),nil), 350) )  do
        if keys.caster:GetPlayerOwnerID() == thing:GetPlayerOwnerID() then
            if string.find(thing:GetUnitName(), "npc_treetag_building_well") then
                keys.caster:RemoveModifierByName(keys.Buff) -- remove spirit from hero
                spiritus = CreateUnitByName("npc_treetag_spirit", thing:GetOrigin(), false, keys.caster, keys.caster:GetOwner(), keys.caster:GetTeamNumber() ) 
                if spiritus ~= nil then
                    spiritus:SetControllableByPlayer(keys.caster:GetPlayerID(), true);
                    spiritus:SetOwner(keys.caster:GetPlayerOwner():GetAssignedHero());
                    learnabilities(spiritus)
                end
                return 5
            end
        end
    end

    for _,thing in pairs(Entities:FindAllByClassnameWithin("npc_dota_creature",GetGroundPosition(keys.target:GetOrigin(),nil), 350) )  do
        if (thing:GetUnitName() == "npc_treetag_bigtree") then
            if watchingtree then
                createmoditem(keys.caster)
                moditem:ApplyDataDrivenModifier(thing, thing, "bigtreespirit", {duration="120"})
                keys.caster:RemoveModifierByName(keys.Buff) -- remove spirit from hero
                return 5
            end
        end
    end
end

gemitem = nil

function givetruesight(keys)
    if not gemitem then
        gemitem = CreateItem("item_gem", keys.caster, keys.caster)
    end
    keys.caster:AddNewModifier(keys.caster, gemitem, "modifier_item_gem_of_true_sight", {duration=keys.Duration})
end

-- item to apply log-carrying modifier
log_item = nil;

-- dire tree-midas
function choptree(keys)
    abzx = keys.caster:FindAbilityByName("goldattack")
    if abzx:GetCooldownTimeRemaining() <= 0 then

        keys.target:CutDownRegrowAfter(35, keys.caster:GetTeam())

        --StartSoundEvent("DOTA_Item.Hand_Of_Midas", keys.caster:GetPlayerOwner():GetAssignedHero())
        EmitSoundOnLocationWithCaster( keys.caster:GetAbsOrigin(), "DOTA_Item.Hand_Of_Midas", keys.caster )


        if not log_item then
            log_item = CreateItem( "item_apply_logs", keys.caster, keys.caster )
        end

        log_item:ApplyDataDrivenModifier(keys.caster, keys.caster, "holding_log", {duration="240"})

        local attacktime = keys.caster:GetBaseAttackTime() / keys.caster:GetAttackSpeed()

        keys.ability:EndCooldown();
        keys.ability:StartCooldown(attacktime * 3.4);
        abzx:StartCooldown(attacktime * 3.4);
    else
        sendError(keys.caster:GetPlayerOwnerID(), "That ability is still on cooldown")
    end
end


-- thinker for the log-carrying buff
function logthink(keys)
    for _,thing in pairs(Entities:FindAllByClassnameWithin("ent_dota_fountain",GetGroundPosition(keys.target:GetOrigin(),nil), 450)) do
        keys.caster:RemoveModifierByName("holding_log")

        local gold = math.floor(1 * keys.caster:GetAverageTrueAttackDamage(keys.caster))
        popupNumbers(keys.caster, "gold", Vector(255, 200, 33), 1.0, gold, nil, nil)
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(gold,true,0)

        StartSoundEvent("DOTA_Item.Hand_Of_Midas", keys.caster:GetPlayerOwner():GetAssignedHero())

        return 1.0
    end
end


-- riki give spirit to target
function givespirit(keys)
    spiritus = CreateUnitByName("npc_treetag_spirit", keys.target:GetOrigin(), false, keys.target, keys.target:GetOwner(), keys.target:GetTeamNumber() ) 
    if spiritus ~= nil then
        spiritus:SetControllableByPlayer(keys.target:GetPlayerID(), true);
        spiritus:SetOwner(keys.target:GetPlayerOwner():GetAssignedHero());
        learnabilities(spiritus)
    end
end

function eatspirit(keys)
    if keys.target:GetClassname()=="ent_dota_tree" then
        if not keys.caster:HasModifier("holding_spirit") then
            if keys.target:IsStanding() then
                for _,thing in pairs(Entities:FindAllInSphere(GetGroundPosition(keys.target:GetOrigin(),nil), 15) )  do
                    -- add another if for gold trees (decid)
                    if (thing:GetName() == "treesaver") then
                        --print("found tree saver")
                        createmoditem(keys.caster)
                        moditem:ApplyDataDrivenModifier(keys.caster, keys.caster, "holding_spirit", {duration="90.0"})
                        keys.target:CutDownRegrowAfter(60, keys.caster:GetTeam())
                        keys.caster:Interrupt()
                        keys.caster:InterruptChannel()
                        return -- found treesaver
                    end
                end
            end
        else
            sendError(keys.caster:GetPlayerOwnerID(),
                "You can only hold 1 spirit at a time")
            keys.caster:Interrupt()
            keys.caster:InterruptChannel()
            return  -- already holding spirit
        end

        -- finding a treesaver results in return
        -- can only reach this point if tree is not in treesaver trigger
        sendError(keys.caster:GetPlayerOwnerID(),
            "You can only rescue a spirit from a dying tree")

        keys.caster:Interrupt()
        keys.caster:InterruptChannel()
    elseif keys.target:GetClassname()=="npc_dota_creature" then
        local uname = keys.target:GetUnitName()
        if uname == "npc_treetag_bigtree" then
            keys.caster:Interrupt()
            keys.caster:InterruptChannel()
            sendError(keys.caster:GetPlayerOwnerID(),
                "You must fetch spirits from dying trees to heal the World Tree!")
        end
    end
    --tprint(keys)
end

function setabilitytarget(keys)
    keys.ability.target=keys.target
end

function canceliftargetdead(keys)
    if keys.ability.target == nil or keys.ability.target:IsNull() then
        keys.caster:Interrupt()
        keys.caster:InterruptChannel()
    elseif not keys.ability.target:IsAlive() then
        keys.caster:Interrupt()
        keys.caster:InterruptChannel()
    end
end

function stopiffull(keys)
    -- DISABLED BECAUSE AUTO HEAL TARGET SWITCHING IS OP AF

    --if keys.caster:GetPlayerOwner():GetAssignedHero():FindAbilityByName("tree_repair"):IsCooldownReady() then
    --    if keys.target:GetHealth()>=keys.target:GetMaxHealth() then
    --        --print(keys.target:GetMostRecentDamageTime())
    --        keys.caster:Interrupt()
    --    end
    --end

    -- stop if dead code:
    if keys.target == nil then
        keys.caster:Interrupt()
        keys.caster:InterruptChannel()
    elseif keys.target:IsNull() then
        keys.caster:Interrupt()
        keys.caster:InterruptChannel()
    elseif not keys.target:IsAlive() then
        keys.caster:Interrupt()
        keys.caster:InterruptChannel()
    end

end


-- generic-ish autocast thinker
-- used for chronoboost
function autocastspell(keys)
    -- example:
    --local targetstring = "npc_treetag_building_mine";
    --local spelltocast = "chronoboost";
    --local range = 750;
    --local avoidbuff = "fastmine";

    local targetstring = keys.targetstring;
    local spelltocast = keys.spelltocast;
    local range = keys.range;
    local avoidbuff = keys.avoidbuff;
    local castonfullhp = keys.castonfullhp;
    local ignoreidle = keys.ignoreidle;


    if keys.caster==nil then
        return 0.5
    end
    if keys.caster:IsNull() then
        return 0.5
    end

    if ignoreidle == "false" then
        if not keys.caster:IsIdle() then
            return 0.5
        end
    end

    local castthispls = keys.caster:FindAbilityByName(spelltocast)
    if castthispls==nil then
        return 0.5
    end
    if castthispls:IsNull() then
        return 0.5
    end

    if not castthispls:IsCooldownReady() then
        return 0.5
    end
    if not castthispls:GetAutoCastState() then
        return 0.5
    end

    for _,unit in pairs( Entities:FindAllByClassnameWithin("npc_dota_creep", keys.caster:GetAbsOrigin(), range)) do
        if unit:IsAlive() and (unit:GetTeam() == keys.caster:GetTeam()) then
            if castonfullhp=="true" or unit:GetHealth() < unit:GetMaxHealth() then
                if not unit:HasModifier(avoidbuff) then
                    if string.find(unit:GetUnitName(), targetstring) then
                        keys.caster:CastAbilityOnTarget(unit, keys.caster:FindAbilityByName(spelltocast), keys.caster:GetPlayerOwnerID())
                        return 0.5
                    end
                end
            end
        end
    end

    keys.caster:CastAbilityOnTarget(healtarget, keys.caster:FindAbilityByName(spelltocast), keys.caster:GetPlayerOwnerID())

end

-- autocast repair thinker
function autorepair(keys)
    if not keys.caster:IsIdle() then
        return 0.5
    end
    if not keys.caster:GetPlayerOwner():GetAssignedHero():FindAbilityByName("tree_repair"):IsCooldownReady() then
        return 0.5
    end
    if not keys.caster:GetPlayerOwner():GetAssignedHero():FindAbilityByName("tree_repair"):GetAutoCastState() then
        return 0.5
    end

    local healtarget = nil
    for _,unit in pairs( Entities:FindAllByClassnameWithin("npc_dota_creep", keys.caster:GetAbsOrigin(), 350)) do
        if unit:GetTeam() == keys.caster:GetTeam() then
            if unit:IsAlive() and (unit:GetHealth() < unit:GetMaxHealth()) then
                if string.find(unit:GetUnitName(), "npc_treetag_building_wall") then
                    keys.caster:CastAbilityOnTarget(unit, keys.caster:GetPlayerOwner():GetAssignedHero():FindAbilityByName("tree_repair"), keys.caster:GetPlayerOwnerID())
                    return 0.5
                elseif string.find(unit:GetUnitName(), "npc_treetag_building_") then
                    healtarget = unit;
                end
            end
        end
    end
    if healtarget == nil then
        return 0.5
    end

    keys.caster:CastAbilityOnTarget(healtarget,
        keys.caster:GetPlayerOwner():GetAssignedHero():FindAbilityByName("tree_repair"),
        keys.caster:GetPlayerOwnerID())
end

function clearmodel(keys)
    keys.caster:SetModelScale(0.01)
end

-- used as a passive drain for timbersaw tree destroy
-- witchdoctor heal style
function eatmana(keys)
    mana = keys.ability:GetCaster():GetMana()
    if mana<20 then
        keys.ability:ToggleAbility()
    else
        keys.ability:GetCaster():ReduceMana(20)
    end
end





function goldattack(keys)
    local armor = keys.target:GetPhysicalArmorValue();
    local armormod = 1

    if armor > 0 then
        armormod = 1 - ((0.06 * armor) / (1 + 0.06 * armor));
    elseif armor < 0 then
        armormod = 1 + ((0.06 * (0 - armor)) / (1 + 0.06 * (0 - armor)));
    end
    
    local gold = math.floor( armormod * keys.attacker:GetAverageTrueAttackDamage(keys.attacker))

    popupNumbers(keys.caster, "gold", Vector(255, 200, 33), 1.0, gold, nil, nil)
    keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(gold, true, 0)
end



function interruptifnotech(keys)
    local techrange = 1000

    if keys.techrange==nil then
    elseif keys.techrange == "" then
    else
        techrange=keys.techrange
    end

    if keys.techunit==nil then

    elseif keys.techunit=="" then

    else
        if techinrange(keys.caster,keys.techunit,tonumber(keys.techunitlevel),techrange) then

        else
            keys.caster:Interrupt()
            keys.caster:InterruptChannel()

            keys.ability:GetCaster():GetAbilityByIndex(0):EndCooldown() -- upgrade ability is in first slot

            -- print("notech " .. keys.techunit)

            if keys.techunit=="npc_treetag_building_wall" then
                sendError(keys.caster:GetPlayerOwnerID(),
                    "Requires nearby wall " .. keys.techunitlevel)
            elseif keys.techunit=="npc_treetag_building_well" then
                sendError(keys.caster:GetOwner():GetPlayerID(),
                    "Requires nearby well " .. keys.techunitlevel)
            end

            return                      -- return if tech not found
        end
    end


    local manaprice = keys.ability:GetManaCost(0)

    if manaprice==0 then
        return                      -- return if no mana cost
    end

    if keys.caster:GetPlayerOwner():GetAssignedHero():GetMana() < manaprice then
        keys.caster:Interrupt()
        keys.caster:InterruptChannel()

        keys.ability:EndCooldown() -- upgrade ability is in first slot

        sendError(keys.caster:GetPlayerOwnerID(),
            "Not enough mana on hero")
        StartSoundEvent("treant_treant_nomana_01", keys.caster:GetPlayerOwner():GetAssignedHero())
        
        --print("nomana")
    else
        keys.caster:GetPlayerOwner():GetAssignedHero():SpendMana(manaprice, nil)
    end

end


function cancelifnomana(keys)
    --local manacost = keys.ability:GetManaCost(0)
    --local heromana = keys.caster:GetPlayerOwner():GetAssignedHero():GetMana()
    --print(manacost.."/"..heromana)
    --if manacost > heromana then
    --    keys.caster:Interrupt()
    --    keys.caster:InterruptChannel()
    --end
end


function techinrange(caster, targetunit, targetunitlevel, techrange)
    local tech1found = false
    for _,unit in pairs( Entities:FindAllInSphere(GetGroundPosition(caster:GetAbsOrigin(), nil), techrange )) do
        if unit:GetClassname() == "npc_dota_creep" then
            local uname = unit:GetUnitName()
            if string.find(unit:GetUnitName(), targetunit) then
                local uul = string.gsub(unit:GetUnitName(), "(" .. targetunit .. "_)", "")
                local ulevel = tonumber(uul)
                --if tonumber(unit:GetContext("tagtypelevel")) >= techlevel then
                if ulevel >= targetunitlevel then
                    local id = unit:GetPlayerOwnerID()
                    if id ~= -1 then
                        if caster:GetPlayerOwnerID() == id then
                            --print("tech unit found for ID: " .. id)
                            tech1found = true
                            break
                        end
                    else
                        --print("unit has no ownerino")
                    end
                end
            end
        end
    end

    if tech1found then
        --print(":)")
        return true
    else
        return false
    end
end

function refundcost(keys)
    keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(keys.ability:GetGoldCost(1), true, 0)
end

function passivegold(keys)
    if keys.caster == nil or keys.caster:GetPlayerOwner() == nil then
        return nil
    end

    local goldMineLevel = string.gsub(keys.caster:GetUnitName(), "(npc_treetag_building_mine_)", "")
    local gold = 2 ^ (goldMineLevel - 1);

    if keys.caster:HasModifier("slowmine") or keys.caster:HasModifier("scannedmine") then
        gold = math.floor(gold*0.5+0.5)
    end

    -- round up most of the time
    if keys.caster:HasModifier("fastmine") then
        gold = math.floor(gold * 1.2 + 0.9)
    end

    popupNumbers(keys.caster, "gold", Vector(255, 200, 33), 1.0, gold, nil, nil)
    keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(gold, true, 0)

    for _, unit in pairs(Entities:FindAllByClassnameWithin("npc_dota_creep", keys.caster:GetAbsOrigin(), 600)) do
        if unit:GetTeam() == keys.caster:GetTeam() then
            if unit:GetPlayerOwnerID() ~= keys.caster:GetPlayerOwnerID() then
                if string.find(unit:GetUnitName(), "npc_treetag_building_mine") then
                    -- apply slow mine debuff
                    local item = CreateItem( "item_apply_stack_debuffs", unit, unit )
                    item:ApplyDataDrivenModifier(unit, unit, "slowmine", {duration = "1.5"})    -- overlap important or code below doesnt detect the modifier
                end
            end
        end
    end

end


function turretreducedamage(keys)
    for _,unit in pairs( Entities:FindAllByClassnameWithin("npc_dota_creep", keys.caster:GetAbsOrigin(), 600)) do
        if unit:GetTeam() == keys.caster:GetTeam() then
            if unit:GetPlayerOwnerID() ~= keys.caster:GetPlayerOwnerID() then
                if string.find(unit:GetUnitName(), "npc_treetag_building_turret") then
                    -- apply reduced damage to turret
                    local item = CreateItem( "item_apply_stack_debuffs", unit, unit )
                    item:ApplyDataDrivenModifier(unit, unit, "reduceddamage", {duration = "1.5"})
                elseif string.find(unit:GetUnitName(), "npc_treetag_building_wall") then
                    -- reduce armor of wall
                    local item = CreateItem( "item_apply_stack_debuffs", unit, unit )
                    item:ApplyDataDrivenModifier(unit, unit, "reducedarmor", {duration = "1.5"})
                end
            end
        end
    end
end

