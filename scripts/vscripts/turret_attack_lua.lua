turret_attack_lua = class({})
LinkLuaModifier( "modifier_turret_attack_lua", LUA_MODIFIER_MOTION_NONE )

turret_damage = {}
turret_damage["npc_treetag_building_turret_1"] = 2
turret_damage["npc_treetag_building_turret_2"] = 3
turret_damage["npc_treetag_building_turret_3"] = 4
turret_damage["npc_treetag_building_turret_4"] = 8
turret_damage["npc_treetag_building_turret_5"] = 16
turret_damage["npc_treetag_building_turret_6"] = 32
turret_damage["npc_treetag_building_turret_7"] = 70
turret_damage["npc_treetag_building_turret_8"] = 150
turret_damage["npc_treetag_building_turret_9"] = 320
turret_damage["npc_treetag_building_turret_10"] = 700

--------------------------------------------------------------------------------

function getTurretDamage(unit)
    if string.find(unit:GetUnitName(),"npc_treetag_building_turret_") then
    	return turret_damage[unit:GetUnitName()]
    end
    return 0
end

function turret_attack_lua:OnUpgrade()
	local caster = self:GetCaster()
	caster:AddNewModifier( caster, self, "modifier_turret_attack_lua", {duration="-1"} )

	local damage = getTurretDamage(caster)
	if damage > 0 then
		caster.turret_damage = damage
	end

    if not self:GetAutoCastState() then
        self:ToggleAutoCast()
    end

end




function isValidTarget(caster,target,range)
	if target ~= nil then
		if target:IsNull() then
			return false
		elseif CalcDistanceBetweenEntityOBB(caster,target) > range then
			return false
		elseif not target:IsAlive() then
			return false
		elseif target:IsInvulnerable() then
			return false
		elseif target:IsAttackImmune() then
			return false
		elseif not caster:CanEntityBeSeenByMyTeam(target) then
			return false
		end
	else
		return false
	end
	return true
end


--------------------------------------------------------------------------------

--[[	this breaks the spell for some reason   PROBABLY BECAUSE YOU DONT RETURN VALUE OK OK ]]
function turret_attack_lua:OnAbilityPhaseStart()
	local caster = self:GetCaster()

	if not isValidTarget(caster,caster.turret_target,600) then
		if not isValidTarget(caster,caster.next_turret_target,600) then
			caster.turret_target=nil
		else
			caster.turret_target=caster.next_turret_target
			caster.next_turret_target=nil
		end
	end

	if caster.turret_target == 	nil or caster.turret_target:IsNull() then
	    for _,hero in pairs(Entities:FindAllInSphere( GetGroundPosition(caster:GetAbsOrigin(),nil), 600) )  do
		    if string.find(hero:GetClassname(), "npc_dota_hero_") and not(string.find(hero:GetClassname(), "npc_dota_hero_announcer")) then
	    		if hero:GetTeamNumber()~=caster:GetTeamNumber() then
    				if isValidTarget(caster,hero,600) then
						caster.turret_target = hero
			        end
			    end
	    	end
		end
	end



	if caster.turret_target ~= nil and not caster.turret_target:IsNull() then
		caster:StartGesture( ACT_DOTA_ATTACK )
		EmitSoundOn( "Creep_Good_Range.PreAttack", self:GetCaster() )
		return true
	else
		return false
	end





end

--------------------------------------------------------------------------------


function turret_attack_lua:OnSpellStart()
	local caster = self:GetCaster()


	if not isValidTarget(caster,caster.turret_target,600) then
		if not isValidTarget(caster,caster.next_turret_target,600) then
			caster.turret_target=nil
		else
			caster.turret_target=caster.next_turret_target
			caster.next_turret_target=nil
		end
	end

	if caster.turret_target == 	nil or caster.turret_target:IsNull() then
	    for _,hero in pairs(Entities:FindAllInSphere( GetGroundPosition(caster:GetAbsOrigin(),nil), 600) )  do
		    if string.find(hero:GetClassname(), "npc_dota_hero_") and not(string.find(hero:GetClassname(), "npc_dota_hero_announcer")) then
	    		if hero:GetTeamNumber()~=caster:GetTeamNumber() then
    				if isValidTarget(caster,hero,600) then
    					--print(hero:GetClassname())
						caster.turret_target = hero

			        end
			    end
	    	end
		end
	end


	if caster.turret_target ~= nil and not caster.turret_target:IsNull() then
		--print("aaaaaa")

		local info = {
				EffectName = "particles/base_attacks/ranged_goodguy.vpcf",
				Ability = self,
				iMoveSpeed = 750, --self:GetSpecialValueFor( "magic_missile_speed" ),
				Source = caster,
				Target = caster.turret_target, --self:GetCursorTarget(),
				iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1
			}

		--caster:StartGesture( ACT_DOTA_ATTACK )
		ProjectileManager:CreateTrackingProjectile( info )
		caster:MakeVisibleDueToAttack(caster.turret_target:GetTeamNumber())
		caster:MoveToNPC(caster.turret_target)
		EmitSoundOn( "Creep_Good_Range.Attack", self:GetCaster() )
	end

end







--------------------------------------------------------------------------------

function turret_attack_lua:OnProjectileHit( hTarget, vLocation )
	--print("xx_b")
	if hTarget ~= nil and ( not hTarget:IsInvulnerable() ) and ( not hTarget:TriggerSpellAbsorb( self ) ) and ( not hTarget:IsMagicImmune() ) then
		EmitSoundOn( "Creep_Good_Range.ProjectileImpact", hTarget )

		local tdamage = 1

		local caster = self:GetCaster()

		if caster.turret_damage ~= nil then
			tdamage = caster.turret_damage
		end

		local damage = {
			victim = hTarget,
			attacker = caster,
			damage = tdamage,
			damage_type = DAMAGE_TYPE_PHYSICAL,
			ability = self
		}

		ApplyDamage( damage )

		--hTarget:AddNewModifier( self:GetCaster(), self, "modifier_turret_attack_lua", { duration = "0.5" } )

	end

	return true
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
