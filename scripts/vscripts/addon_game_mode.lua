--[[

replace fortify
-- http://hastebin.com/henocemifa.php    fishing for murfle

]]


require("_precache")
require("hero_util")
require("turret_stuff")
require("pick_abilities_radiant")
require("pick_abilities_dire")


Testing = false --Useful for turning off stat-collection when developing


if CTreeTagGameMode == nil then
	CTreeTagGameMode = class({})
	--CTreeTagGameMode = {}
	--CTreeTagGameMode.szEntityClassName = "treetag"
	--CTreeTagGameMode.szNativeClassName = "dota_base_game_mode"
	--CTreeTagGameMode.__index = CTreeTagGameMode
end


function Precache(context)
    preCacheResources(context)
end

-- Create the game mode when we activate
function Activate()
	GameRules.AddonTemplate = CTreeTagGameMode()
	GameRules.AddonTemplate:InitGameMode()
end

function CTreeTagGameMode:InitGameMode()
	print( "Tree Tag is loaded." )
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 1 )

    --if GetMapName() == "mines_trio" then
    -- different team sizes for different maps okok todo:
    GameRules:SetCustomGameTeamMaxPlayers(2, 8)
    GameRules:SetCustomGameTeamMaxPlayers(3, 2)

    GameRules:GetGameModeEntity():SetCustomGameForceHero("npc_dota_hero_wisp")
    GameRules:GetGameModeEntity():SetCustomHeroMaxLevel(1)
    GameRules:GetGameModeEntity():SetBuybackEnabled(false)

	GameRules:SetSameHeroSelectionEnabled(true)
	GameRules:SetHeroRespawnEnabled(false)
	GameRules:SetUseUniversalShopMode(false)
    GameRules:SetHeroSelectionTime(20.0) -- hero selection is not skipped unless this is set to 0 it seems
	GameRules:SetPreGameTime(35.0)
	GameRules:SetPostGameTime(30.0)
	GameRules:SetTreeRegrowTime(5.0)
	GameRules:SetGoldTickTime(60.0)
	GameRules:SetGoldPerTick(0)
    GameRules:SetRuneSpawnTime(30)
    GameRules:SetFirstBloodActive(false)
    GameRules:SetUseBaseGoldBountyOnHeroes(true)

    --GameMode:SetCameraDistanceOverride(1404.0)
end

needshero = {true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true}
needshero[0] = true

starttime = -1

--nonstatsgame = true;

function objectivereached(keys)
    --tprint(keys);
    --print("---------")


    --[[ high score stuff
    print("high scores temporarily disabled")

    if nonstatsgame then
    	print("Stats not recorded this game. Only 5v2 games are recorded for high scores")
        return nil;
    end

    local rad = 0;
    local dir = 0;

    for _,hero in pairs(HeroList:GetAllHeroes()) do
        if hero:GetTeam() == 2 then
            rad = rad + 1;
        elseif hero:GetTeam() == 3 then
        	dir = dir + 1;
        end
    end

    if rad==5 and dir==2 then
    else
    	nonstatsgame = true;
    	print("nonstatsgame: high score not recorded")
    	return nil;
    end


    local pid = keys.caster:GetPlayerOwnerID();
    local objective = keys.objectivename;

    local newscore = GameRules:GetDOTATime(false,false);

    --local newscore = 91987


            --tt_mine10
            --tt_turret10
            --tt_mineandturret10
            --tt_level5set

    if objective=="mine10" then
        print("Player "..pid.." reached "..objective.." after "..newscore.." secs");
        FireGameEvent( 'tt_mine10', { player_ID = pid, score = newscore } );
		keys.caster:GetOwner().mine10=true;
        -- check for turret 10 and then fire tt_mineandturret10
        if keys.caster:GetOwner().turret10 then
        	FireGameEvent( 'tt_mineandturret10', { player_ID = pid, score = newscore } );
        	print("Player "..pid.." reached mineandturret after "..newscore.." secs");
        end

    elseif objective=="turret10" then
        print("Player "..pid.." reached "..objective.." after "..newscore.." secs");
        FireGameEvent( 'tt_turret10', { player_ID = pid, score = newscore } );
		keys.caster:GetOwner().turret10=true;
        -- check for mine 10 and then fire tt_mineandturret10
        if keys.caster:GetOwner().mine10 then
        	FireGameEvent( 'tt_mineandturret10', { player_ID = pid, score = newscore } );
        	print("Player "..pid.." reached mineandturret after "..newscore.." secs");
        end


    end
    -- do the item check bullshit on some item acquired event for dire level5set
    ]]

end

--  have players 8 and 9 been swapped to radiant?
notswapped8 = true
notswapped9 = true
notswapped8a = true
notswapped9a = true

-- Evaluate the state of the game
function CTreeTagGameMode:OnThink()


	--print(GameRules:GetDOTATime(false,false))


	--[[if notswapped8a then
        local owner = PlayerResource:GetPlayer(8);
        if owner then
	        owner:SetTeam(2);
        	notswapped8a=false;
    	end
	end
	if notswapped9a then
        local owner = PlayerResource:GetPlayer(9);
        if owner then
	        owner:SetTeam(2);
        	notswapped9a=false;
    	end
	end]]


	-- temporarily disabled
    --[[if GameRules:State_Get() >= DOTA_GAMERULES_STATE_HERO_SELECTION then
		j = {}
		for i=0,9 do
		j[tostring(i)] = PlayerResource:GetSteamAccountID(i)
		end
		FireGameEvent("stat_collection_steamID", j)
	end]]


	local currentGameTime = GameRules:GetDOTATime(false,false);

	for _,hero in pairs( Entities:FindAllByClassname( "npc_dota_hero_wisp")) do

        if not hero:IsAlive() then
            hero:RemoveSelf()
        elseif hero==nil then
        elseif hero:GetPlayerOwner()==nil then
        elseif hero:GetPlayerOwner():GetPlayerID()==nil then
            if starttime>-1 and currentGameTime >= 60 then
                hero:RemoveSelf()
            end
        else

            local id = hero:GetPlayerOwner():GetPlayerID()
            if id ~= -1 then
           		hero:SetGold(0, false)
               	if hero:GetTeamNumber() == 2 then
                	if starttime>-1 and currentGameTime >= 60 then
                        local powner = hero:GetPlayerOwner();
                        local hero = pickHero(id, "npc_dota_hero_treant")
                        hero:GetAbilityByIndex(0):ToggleAutoCast()
                        hero:GetAbilityByIndex(4):ToggleAutoCast()
                        giveitems(hero)
    					needshero[id] = false
    				elseif needshero[id] then
                        hero:RemoveAbility("picktree")
                        local abilityNames = {
                            'picktree',
                            'pickfurion',
                            'pickriki',
                            'picktechies'
                        }
                        for _, abilityName in pairs(abilityNames) do
                            hero:AddAbility(abilityName)
                            ability = hero:FindAbilityByName(abilityName)
                            ability:SetLevel(1)
                            ability:StartCooldown(5)
                            ability:SetHidden(false)
                            ability:SetActivated(true)
                        end
       					hero:SetAbilityPoints(0)
                        hero:HeroLevelUp(true)
    					needshero[id] = false
    					--print("azpp: "..hero:GetTeamNumber())
       				end
               	elseif hero:GetTeamNumber() == 3 then
                	if starttime>-1 and currentGameTime >= 60 then
                        local hero = pickHero(id, "npc_dota_hero_shredder")
                        giveitemsdire(hero)
    					needshero[id] = false
    				elseif needshero[id] then
                        hero:RemoveAbility("picktree")
                        local abilityNames = {
                            'picktimber',
                            'pickbatrider',
                            'pickpudge'
                        }
                        for _, abilityName in pairs(abilityNames) do
                            hero:AddAbility(abilityName)
                            ability = hero:FindAbilityByName(abilityName)
                            ability:SetLevel(1)
                            ability:StartCooldown(35)
                            ability:SetHidden(false)
                            ability:SetActivated(true)
                        end
                        hero:SetAbilityPoints(0)
                        hero:HeroLevelUp(true)
                        needshero[id] = false
    				end
                end
            end

        end
    end


-- C:Gamerules: entering state 'DOTA_GAMERULES_STATE_HERO_SELECTION'


	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		if starttime == -1 then
			starttime = GameRules:GetGameTime()
		end
		self:_CheckForDefeat()
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
    elseif GameRules:State_Get() == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
        --GameRules:FinishCustomGameSetup()
    end
	return 1
end


local gameending = "not now"

function ending()
	return gameending
end

ended=false
warnA=false
warnB=false
warnC=false

function CTreeTagGameMode:_CheckForDefeat()
	if GameRules:State_Get() ~= DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		return
	end
	local currentGameTime = GameRules:GetDOTATime(false,false);

	local bAllPlayersDead = true
	local bHasPlayers = false

	local aAllPlayersDead = true
	local aHasPlayers = false

	for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
		if PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS then
			if not PlayerResource:HasSelectedHero( nPlayerID ) then
				bAllPlayersDead = false
			else
				local hero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
				if hero then
					bHasPlayers = true;
					if hero:IsAlive() then
						bAllPlayersDead = false
					end
				end
			end
		elseif PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_BADGUYS then
			if not PlayerResource:HasSelectedHero( nPlayerID ) then
				aAllPlayersDead = false
			else
				local hero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
				if hero then
					aHasPlayers = true;
					if hero:IsAlive() then
						aAllPlayersDead = false
					end
				end
			end
		end
	end

	--fb only end if everyone is dead or gametime = X
	--if bAllPlayersDead or not self._entAncient or self._entAncient:GetHealth() <= 0 then
	if starttime > -1 then
		if currentGameTime >= 39 then
			if bAllPlayersDead and bHasPlayers then
				print("Dire lose: all dead")
				GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
				return
			end
			if aAllPlayersDead and aHasPlayers then
				print("Rad lose: all dead")
				GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
				return
			end
		end
	

		-- auto 2 min win for testing
		--if GameRules:GetGameTime()-starttime >= 120 then
		--	GameRules:MakeTeamLose( DOTA_TEAM_BADGUYS )
		--end


		if currentGameTime >= 1759 then
			if not warnB then
				local messageinfo = {message = "Dire, prepare to kill the World Tree!", duration = 5}
				FireGameEvent("show_center_message",messageinfo) 
				warnB=true
			end
		end
		if currentGameTime >= 1764 then
			if not warnC then
				local messageinfo = {message = "Radiant, prepare to heal the World Tree!", duration = 5}
				FireGameEvent("show_center_message",messageinfo) 
				warnC=true
			end
		end
		if currentGameTime >= 1769 then
			if not warnA then
				local messageinfo = {message = "Tree Active in 30s!", duration = 5}
				FireGameEvent("show_center_message",messageinfo) 
				warnA=true
			end
		end

		if currentGameTime >= 1799 then
			if not ended then
					print("check tree")
				for _,bigtree in pairs( Entities:FindAllByName("bigtree")) do
					bigtree:RemoveModifierByName("waitingforend")
					print("tree1")
				end
				ended=true
				local messageinfo = {message = "Save the tree!", duration = 10}
				FireGameEvent("show_center_message",messageinfo) 
			end
			return
		end
	end
end