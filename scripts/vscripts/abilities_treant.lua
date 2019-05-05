
ecodebuffer = nil

function getStackItem(creator)
	if ecodebuffer==nil then
		ecodebuffer=CreateItem( "item_apply_eco_debuff", creator, creator )
	end
	return ecodebuffer
end

function fakefly(keys)
	local unit = keys.target

	if unit==nil or unit:IsNull() then
		return nil
	end
	if not unit:IsAlive() then
		return nil
	end
	
  	local origin = unit:GetAbsOrigin()









	if unit:HasModifier("modifier_techies_run_lua") then
		local blockedPosX = not GridNav:IsTraversable(origin) or GridNav:IsBlocked(origin)
		if not blockedPosX then
		    unit.vLastGoodPosition = origin
		end
		return nil
	end







	local position = unit:GetAbsOrigin()


	local treefound = false
    for _,tree in pairs(GridNav:GetAllTreesAroundPoint(position, 60, true) )  do
    	if tree:IsStanding() then
    		--tree:CutDownRegrowAfter(3, unit:GetTeamNumber())
    		treefound = true
    	end
	end





  	local forward = unit:GetForwardVector()
    local targetpos = GetGroundPosition(origin + forward * 30, unit)




	local standingonblockedPos = not GridNav:IsTraversable(position) or GridNav:IsBlocked(position)

	if treefound then
		getStackItem(keys.caster):ApplyDataDrivenModifier(unit, unit, "tt_treespeed", {duration="0.1"})
	elseif standingonblockedPos then
		getStackItem(keys.caster):ApplyDataDrivenModifier(unit, unit, "tt_climbing", {duration="1.1"})
		getStackItem(keys.caster):ApplyDataDrivenModifier(unit, unit, "tt_climbing_med", {duration="3.0"})
		getStackItem(keys.caster):ApplyDataDrivenModifier(unit, unit, "tt_climbing_long", {duration="5.0"})
	end

	--[[
	local blockedPos = not GridNav:IsTraversable(targetpos) or GridNav:IsBlocked(targetpos)



	if treefound then
		blockedPos = false
		standingonblockedPos = false
	end

	if not blockedPos and not standingonblockedPos then
	    unit.vLastGoodPosition = position
	else
	    unit:SetAbsOrigin(unit.vLastGoodPosition)
	end]]
end











function fakeflyORIG(keys)
	local unit = keys.target

	if unit==nil or unit:IsNull() then
		return nil
	end
	if not unit:IsAlive() then
		return nil
	end
	
  	local origin = unit:GetAbsOrigin()

	if unit:HasModifier("modifier_techies_run_lua") then
		local blockedPosX = not GridNav:IsTraversable(origin) or GridNav:IsBlocked(origin)
		if not blockedPosX then
		    unit.vLastGoodPosition = origin
		end
		return nil
	end

	local position = unit:GetAbsOrigin()


	local treefound = false
    for _,tree in pairs(GridNav:GetAllTreesAroundPoint(position, 60, true) )  do
    	if tree:IsStanding() then
    		tree:CutDownRegrowAfter(3, unit:GetTeamNumber())
    		treefound = true
    	end
	end


	if treefound then
		getStackItem(keys.caster):ApplyDataDrivenModifier(unit, unit, "fakeflyingu", {duration="0.7"})
	end


  	local forward = unit:GetForwardVector()
    local targetpos = GetGroundPosition(origin + forward * 20, unit)



	local blockedPos = not GridNav:IsTraversable(targetpos) or GridNav:IsBlocked(targetpos)

	if not blockedPos then
	    unit.vLastGoodPosition = targetpos
	else
	    unit:SetAbsOrigin(unit.vLastGoodPosition)
	    if not treefound and keys.target:HasModifier("fakeflyingu") then
	        keys.target:RemoveModifierByName("fakeflyingu")
	    end
	end
end