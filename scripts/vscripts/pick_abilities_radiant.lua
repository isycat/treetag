require("CosmeticLib")
require("hero_util")

-- give treant starting items
function giveitems(hero)
    clearInventory(hero)
    addRadiantItems(hero)
end

function picktree(keys)
    local hero = pickHero(keys.caster:GetPlayerOwnerID(), "npc_dota_hero_treant")
    hero:GetAbilityByIndex(0):ToggleAutoCast()
    hero:GetAbilityByIndex(4):ToggleAutoCast()
    giveitems(hero)
end

function pickriki(keys)
    local hero = pickHero(keys.caster:GetPlayerOwnerID(), "npc_dota_hero_riki")
    CosmeticLib:RemoveAll( hero )
    hero:GetAbilityByIndex(4):ToggleAutoCast()
    giveitems(hero)
end

function pickveno(keys)
    local hero = pickHero(keys.caster:GetPlayerOwnerID(), "npc_dota_hero_venomancer")
    hero:GetAbilityByIndex(4):ToggleAutoCast()
    giveitems(hero)
end

function pickfurion(keys)
    local hero = pickHero(keys.caster:GetPlayerOwnerID(), "npc_dota_hero_furion")
    hero:GetAbilityByIndex(0):ToggleAutoCast()
    hero:GetAbilityByIndex(4):ToggleAutoCast()
    giveitems(hero)
end

function picktechies(keys)
    local hero = pickHero(keys.caster:GetPlayerOwnerID(), "npc_dota_hero_techies")
    CosmeticLib:RemoveAll( hero )
    hero:GetAbilityByIndex(4):ToggleAutoCast()
    giveitems(hero)
end

function addRadiantItems(hero)
    local itemNames = {
        'item_place_mine',
        'item_place_wall',
        'item_place_turret',
        'item_place_well'
    }
    for _, itemName in pairs(itemNames) do
        local item = CreateItem(itemName, hero, hero)
        item:SetPurchaseTime(item:GetPurchaseTime() - 12)
        hero:AddItem(item)
    end
end
