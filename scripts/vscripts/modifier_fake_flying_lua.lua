modifier_fake_flying_lua = class({})

--------------------------------------------------------------------------------

function modifier_fake_flying_lua:IsPurgable()
    return false
end

--------------------------------------------------------------------------------

function modifier_fake_flying_lua:IsHidden()
    return true
end

--------------------------------------------------------------------------------

function modifier_fake_flying_lua:CheckState()
    local state = {
    [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
    }

    return state
end

--------------------------------------------------------------------------------

function modifier_fake_flying_lua:OnCreated( kv )
    if IsServer() then
        self:StartIntervalThink( 0.5 )
    end
end

--------------------------------------------------------------------------------

function modifier_fake_flying_lua:OnIntervalThink()
    if IsServer() then
        self:StartIntervalThink( 0.01 )

        local unit = self:GetParent()
        local position = unit:GetAbsOrigin()

        local blockedPos = not GridNav:IsTraversable(position) or GridNav:IsBlocked(position)

        if not blockedPos then
            unit.vLastGoodPosition = position
        else
            unit:SetAbsOrigin(unit.vLastGoodPosition)
        end

    end
end

--------------------------------------------------------------------------------