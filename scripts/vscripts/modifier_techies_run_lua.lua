modifier_techies_run_lua = class({})

--------------------------------------------------------------------------------

function modifier_techies_run_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_techies_run_lua:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_techies_run_lua:CheckState()
	local state = {
	[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
	}

	return state
end

--------------------------------------------------------------------------------
