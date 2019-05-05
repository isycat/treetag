modifier_turret_attack_lua = class({})

--------------------------------------------------------------------------------

function modifier_turret_attack_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_turret_attack_lua:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_turret_attack_lua:OnCreated( kv )
	if IsServer() then
		self:StartIntervalThink( 1.0 )
	end
end

--------------------------------------------------------------------------------

function modifier_turret_attack_lua:OnIntervalThink()
	if IsServer() then
		self:StartIntervalThink( 1.0 )

		local caster = self:GetCaster()
		local ability = caster:FindAbilityByName("turret_attack_lua")
		if ability == nil then
			return nil
		end
		if ability:IsNull() then
			return nil
		end

	    if not ability:GetAutoCastState() then
	        return nil
	    end

        if 
	        caster:IsChanneling()
	        or caster:IsDisarmed()
	        or caster:IsStunned()
	        --or not(caster:IsIdle())
        then
   		else
	        caster:CastAbilityNoTarget(ability, caster:GetPlayerOwnerID())


    	end

	end
end

--------------------------------------------------------------------------------