--require("CosmeticLib")
require("hero_util")

function giveitemsdire(hero)
    clearInventory(hero)
    addDireItems(hero)
end

function picktimber(keys)
    local hero = pickHero(keys.caster:GetPlayerOwnerID(), "npc_dota_hero_shredder")
    giveitemsdire(hero)
end

function pickbatrider(keys)
    local hero = pickHero(keys.caster:GetPlayerOwnerID(), "npc_dota_hero_batrider")
    giveitemsdire(hero)
end

function pickpudge(keys)
    local hero = pickHero(keys.caster:GetPlayerOwnerID(), "npc_dota_hero_pudge")
    giveitemsdire(hero)
end

function addDireItems(hero)
    local itemNames = {
        'item_travel_boots',
        'item_chop_tree',
        'item_haste_0',
        'item_armor_0',
        'item_health_0',
        'item_regen_0'
    }
    for _, itemName in pairs(itemNames) do
        local item = CreateItem(itemName, hero, hero)
        item:SetPurchaseTime(item:GetPurchaseTime() - 12)
        hero:AddItem(item)
    end
end