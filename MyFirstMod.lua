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
		G.GAME.pool_flags.photograph_bought = true --if a pool flag is not defined it returns false. N' said that
	end
    },
    true
)

--PHOTOGRAPHER
SMODS.Joker{
    key = 'self_portrait',
    loc_txt = {
        name = 'Self-Portrait',
        text = {
            "Played{C:attention} face cards{} give {X:mult,C:white}x#1#{} Mult",
            "when scored"
            }
    },
    in_pool = function(self, args)
        return G.GAME.pool_flags.photograph_bought -- photograph_bought is not defined until photograph is added to deck so it returns false
    end,
    blueprint_compat = true,
    config = {extra = {xmult = 1.50} },
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
        "{C:chips}+#2#{} chips and {C:mult}+#3#{} Mult on",
        "{C:attention}boss blinds{}",
        "{C:inactive}({C:attention}#4#{C:inactive}/#5# until mastering)"
    }
    },
    config = {extra = {money = 3, chips = 30,mult = 2,invis_rounds = 0, total_rounds = 3}},
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = false,
    atlas = 'ModdedVanilla',
    pos = {x = 1, y = 0},
    cost = 3,
    loc_vars = function(self,info_queue,card)
        return { vars = { card.ability.extra.money, card.ability.extra.chips,card.ability.extra.mult,card.ability.extra.invis_rounds,card.ability.extra.total_rounds, }}
    end,
    --Getting money after beating boss
    calc_dollar_bonus = function(self, card)
        if G.GAME.last_blind and G.GAME.last_blind.boss then
		local bonus = card.ability.extra.money
		if bonus > 0 then return bonus end
        end
	end,
    --
    calculate = function (self,card,context)
        if context.end_of_round and context.game_over == false and context.main_eval and G.GAME.last_blind.boss and G.GAME.last_blind and not context.blueprint then
            card.ability.extra.invis_rounds = card.ability.extra.invis_rounds + 1
            if (card.ability.extra.invis_rounds >= card.ability.extra.total_rounds) then
                --SMODS.add_card{key = "j_my_master_hunter"}
                --card:start_dissolve()
                
                card:set_ability("j_my_master_hunter")
                return{
                    message = ("Mastered")
                }
                
            end
            return {
                message = (card.ability.extra.invis_rounds < card.ability.extra.total_rounds) and
                    (card.ability.extra.invis_rounds .. '/' .. card.ability.extra.total_rounds) or
                    localize('k_active_ex'),
                colour = G.C.FILTER
            }
            
        end
        if context.joker_main and G.GAME.last_blind.boss then
			return {
				chips = card.ability.extra.chips,
				mult = card.ability.extra.mult,
			}
		end
        --
        
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
        "{C:chips}+#2#{} chips and {X:mult,C:white}x#3#{} Mult on",
        "{C:attention}boss blinds{}"
    }
    },
    config = {extra = {money = 12, chips = 120, xmult = 2}},
    rarity = 3,
    blueprint_compat = true,
    in_pool = function(self, args)
        return false
    end,
    atlas = 'ModdedVanilla',
    pos = {x = 0, y = 1},
    soul_pos = {x=5,y=1},
    cost = 10,
    loc_vars = function(self,info_queue,card)
        return { vars = { card.ability.extra.money, card.ability.extra.chips, card.ability.extra.xmult}}
    end,
    --
    calc_dollar_bonus = function(self, card)
        if G.GAME.last_blind and G.GAME.last_blind.boss then
		local bonus = card.ability.extra.money
		if bonus > 0 then return bonus end
        end
	end,
    calculate = function (self,card,context)
        if context.joker_main and G.GAME.last_blind.boss then
			return {
				chips = card.ability.extra.chips,
				Xmult = card.ability.extra.xmult,
				--message = localize { type = 'variable', key = 'a_chips', vars = { card.ability.extra.chips } }
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