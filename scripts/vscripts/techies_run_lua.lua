techies_run_lua = class({})
LinkLuaModifier( "modifier_techies_run_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function techies_run_lua:OnSpellStart()
	self:GetCaster():AddNewModifier( caster, self, "modifier_techies_run_lua", {duration="6"} )
end

--------------------------------------------------------------------------------