SMODS.Atlas {
	-- Key for code to find it with
	key = "ModdedVanilla",
	-- The name of the file, for the code to pull the atlas from
	path = "ModdedVanilla.png",
	-- Width of each sprite in 1x size
	px = 71,
	-- Height of each sprite in 1x size
	py = 95
}

--prepairing photograph joker for phtotographer
SMODS.Joker:take_ownership('photograph',{
    add_to_deck = function(self, card, from_debuff)
		G.GAME.pool_flags.photograph_bought = true
	end
    },
    true
)

--PHOTOGRAPHER
SMODS.Joker{
    key = 'photographer',
    loc_txt = {
        name = 'Photographer',
        text = {
            "Played{C:attention} face cards{} give {X:mult,C:white}x#1#{} Mult",
            "when scored"
            }
    },
    blueprint_compat = true,
    yes_pool_flag = 'photograph_bought';
    config = {extra = {xmult = 1.25} },
    rarity = 3,
    atlas = 'ModdedVanilla',
    pos = {x = 0,  y = 0},
    cost = 8,
    loc_vars = function(self,info_queue,card)
        return { vars = { card.ability.extra.xmult}}
    end,
    calculate = function (self,card,context)
        if context.cardarea == G.play and context.individual and context.other_card:is_face() then
			return {
				Xmult_mod = card.ability.extra.xmult,
				--card = context.other_card,
                message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.xmult } }
			}
		end
    end
}

-- HUNTER
SMODS.Joker{
    key = 'hunter',
    loc_txt = {
        name = 'Hunter',
        text = {
        "Earn {C:money}$#1#{} after",
        "beating a {C:attention}boss blind{}",
        "{C:chips}+#2#{} chips"
    }
    },
    config = {extra = {money = 6, chips = 30}},
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = false,
    atlas = 'ModdedVanilla',
    pos = {x = 1, y = 0},
    cost = 3,
    loc_vars = function(self,info_queue,card)
        return { vars = { card.ability.extra.money, card.ability.extra.chips}}
    end,
    
    calc_dollar_bonus = function(self, card)
        if G.GAME.last_blind and G.GAME.last_blind.boss then
		local bonus = card.ability.extra.money
		if bonus > 0 then return bonus end
        end
	end,
    calculate = function (self,card,context)
        if context.joker_main then
            SMODS.add_card{key = "j_my_master_hunter"}
			return {
				chip_mod = card.ability.extra.chips,
				message = localize { type = 'variable', key = 'a_chips', vars = { card.ability.extra.chips } }
			}
		end
    end
}

--MASTER HUNTER
SMODS.Joker{
    key = 'master_hunter',
    loc_txt = {
        name = 'Master Hunter',
        text = {
        "Earn {C:money}$#1#{} after",
        "beating a {C:attention}boss blind{}",
        "{C:chips}+#2#{} chips on {C:attention}boss blinds{}"
    }
    },
    config = {extra = {money = 12, chips = 120}},
    rarity = 3,
    blueprint_compat = true,
    atlas = 'ModdedVanilla',
    pos = {x = 2, y = 0},
    cost = 10,
    loc_vars = function(self,info_queue,card)
        return { vars = { card.ability.extra.money, card.ability.extra.chips}}
    end,
    
    calc_dollar_bonus = function(self, card)
        if G.GAME.last_blind and G.GAME.last_blind.boss then
		local bonus = card.ability.extra.money
		if bonus > 0 then return bonus end
        end
	end,
    calculate = function (self,card,context)
        if context.joker_main and G.GAME.last_blind.boss then
			return {
				chip_mod = card.ability.extra.chips,
				message = localize { type = 'variable', key = 'a_chips', vars = { card.ability.extra.chips } }
			}
		end
    end
}
--Propoganda Poster
-- SMODS.Joker{
--     key = 'propoganda_poster',
--     loc_txt = {
--         name = 'Propoganda Poster',
--         text = {
--             "Played{C:attention} face cards{} give {X:mult,C:white}x#1#{} Mult",
--             "when scored"
--             }
--     },
--     config = {extra = {xmult = 1.25} },
--     rarity = 3,
--     atlas = 'ModdedVanilla',
--     pos = {x = 2,  y = 0},
--     cost = 8,
--     loc_vars = function(self,info_queue,card)
--         return { vars = { card.ability.extra.xmult}}
--     end,
--     calculate = function (self,card,context)
--         if context.cardarea == G.play and context.individual then
-- 			if context.other_card:is_face() then
-- 				return {
-- 					message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.xmult } },
-- 					Xmult_mod = card.ability.extra.xmult,
-- 					card = context.other_card
-- 				}
-- 			end
-- 		end
--     end
-- }