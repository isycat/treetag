
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

function setTurretTarget(keys)
	if isValidTarget(keys.caster,keys.target,600) then
        keys.caster:Interrupt()
        keys.caster:InterruptChannel()
		keys.caster.next_turret_target = keys.target
		keys.caster.turret_target = keys.target
	end
end