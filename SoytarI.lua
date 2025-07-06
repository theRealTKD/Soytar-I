SMODS.Atlas {
	-- Key for code to find it with
	key = "SoytarI",
	-- The name of the file, for the code to pull the atlas from
	path = "SoytarI.png",
	-- Width of each sprite in 1x size
	px = 71,
	-- Height of each sprite in 1x size
	py = 95
}

--Self-portrait
--#region
--prepairing photograph joker for self_portrait
SMODS.Joker:take_ownership('photograph',{
    add_to_deck = function(self, card, from_debuff)
		G.GAME.pool_flags.photograph_bought = true --if a pool flag is not defined it returns false.
	end
    },
    true--when set to true it makes my change silent. so no mod stamp.
)


SMODS.Joker{
    key = 'self_portrait',
    loc_txt = {
        name = 'Self-Portrait',
        text = {
            "Played{C:attention} face cards{} give",
            "{X:mult,C:white}x#1#{} Mult when scored"
            }
    },
    in_pool = function(self, args)
        return G.GAME.pool_flags.photograph_bought -- photograph_bought is not defined until photograph is added to deck so it returns false
    end,
    blueprint_compat = true,
    config = {extra = {xmult = 1.50} },
    rarity = 3,
    atlas = 'SoytarI',
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
--#endregion

-- HUNTER
--#region
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
    config = {extra = {money = 3, chips = 30,mult = 2,invis_rounds = 0, total_rounds = 2}},
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = false,
    atlas = 'SoytarI',
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
                card:set_ability("j_str_master_hunter")
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
        --
        if context.joker_main and G.GAME.last_blind.boss then
			return {
				chips = card.ability.extra.chips,
				mult = card.ability.extra.mult,
			}
		end
        --
    end
}
--#endregion

--MASTER HUNTER
--#region
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
    atlas = 'SoytarI',
    pos = {x = 0, y = 1},
    soul_pos = {x=1,y=1},
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
--#endregion

--Identikit
--#region
SMODS.Joker{
    key = "identikit",
    loc_txt = {
        name = 'Identikit',
        text = {
                "If a {C:attention}discarded hand{} contains",
                "only {C:attention}a single face card{},",
                "{C:mult}destroy{} it and gain {C:mult}+#1# {}Mult.",
                "{C:inactive}Curently{} {C:mult}+#3#{} {C:inactive}Mult{}",
                "{C:inactive}Until nothing remained but a sketch{}"
            }
    },
    config = {extra = {mult = 0, trigger = 5, mult_gain = 3}},
    loc_vars = function(self,info_queue,card)
        return { vars = { card.ability.extra.mult_gain, card.ability.extra.trigger, card.ability.extra.mult}}
    end,
    rarity = 2,
    cost = 5,
    blueprint_compat = true,
    eternal_compat = true,
    atlas = 'SoytarI',
    pos = {x = 2, y = 0},
    calculate = function(self, card, context)
        if context.discard and not context.blueprint and
            context.other_card:is_face() and #context.full_hand == 1 and not context.other_card.debuff then
            card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain;
            card.ability.extra.trigger = card.ability.extra.trigger - 1
            card:juice_up(0.3, 0.4)
            return {
                remove = true,
                message = "GONE"
                
            }
        end
        --
        if context.joker_main then
			return {
			    mult = card.ability.extra.mult,
			}
		end
    end
}
--#endregion

--Old Photo
--#region
SMODS.Joker{
    key = 'old_photo',
    loc_txt = {
        name = 'Old Photo',
        text = {"This Joker gains {X:mult,C:white} X#2# {} Mult",
                    "per {C:attention}consecutive{} hand played",
                    "without repeating the previous",
                    "{C:attention}poker hand",
                    "{C:inactive}(Currently {X:mult,C:white} X#1# {C:inactive} Mult)",
                    "{C:inactive}(Previous hand: #3#)"
                }
    },
    blueprint_compat = true,
    config = {extra = {Xmult = 1, Xmult_gain = 0.1,previous_hand = "none"} },
    rarity = 2,
    atlas = 'SoytarI',
    pos = {x = 3,  y = 0},
    cost = 7,
    loc_vars = function(self,info_queue,card)
        return { vars = { card.ability.extra.Xmult,card.ability.extra.Xmult_gain,card.ability.extra.previous_hand}}
    end,
    calculate = function (self,card,context)
        --
        if context.before and context.main_eval and not context.blueprint then
            if  context.scoring_name == card.ability.extra.previous_hand then
                card.ability.extra.Xmult = 1
                return {
                    message = localize('k_reset')
                }
            else
                card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_gain
                return {
                    message = localize('k_upgrade_ex')
                }
            end
        end
        --
        if context.after and context.main_eval and not context.blueprint then
            card.ability.extra.previous_hand = G.GAME.last_hand_played
        end
        if context.joker_main then
                return {
                    xmult = card.ability.extra.Xmult
                }
        end
    end
}
--#endregion

-- Meddah
--#region
SMODS.Joker {
    key = "meddah",
    loc_txt = {
        name = 'Meddah',
        text = {"Every played {C:attention}card{}",
                "permanently gains",
                "{C:mult}+#1#{} Mult when scored",
                "After every [#6#] such repeats, ",
                "gain {X:mult,C:white}X#3# {} Mult",
                "{C:inactive}(Currently {X:mult,C:white} X#2# {C:inactive} Mult)"}
    },
    blueprint_compat = true,
    rarity = 4,
    cost = 20,
    atlas = 'SoytarI',
    pos = { x = 4, y = 0 },
    soul_pos = {x = 5, y = 0 },
    config = { extra = { mult = 2, xmult= 1, xmult_gain = 1, retrigger_count = 0 ,retrigger = 21, left =21} },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult,card.ability.extra.xmult, card.ability.extra.xmult_gain, card.ability.extra.retrigger_count, card.ability.extra.retrigger, card.ability.extra.left} }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            card.ability.extra.retrigger_count = card.ability.extra.retrigger_count + 1
            context.other_card.ability.perma_mult = context.other_card.ability.perma_mult + card.ability.extra.mult
            card.ability.extra.left = card.ability.extra.retrigger - (card.ability.extra.retrigger_count % card.ability.extra.retrigger)
            --
            if card.ability.extra.retrigger_count %  card.ability.extra.retrigger == 0 then
                card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_gain
            end
            return {
                message = localize('k_upgrade_ex'),
                colour = G.C.MULT
            }
        end
        if context.joker_main then
                return {
                    xmult = card.ability.extra.xmult
                }
        end
    end
}
--#endregion