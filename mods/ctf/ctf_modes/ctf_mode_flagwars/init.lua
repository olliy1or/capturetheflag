local rankings = ctf_rankings.init()
local recent_rankings = ctf_modebase.recent_rankings(rankings)
local features = ctf_modebase.features(rankings, recent_rankings)

local old_bounty_reward_func = ctf_modebase.bounties.bounty_reward_func
local old_get_next_bounty = ctf_modebase.bounties.get_next_bounty

ctf_modebase.register_mode("flagwars", {
	treasures = {},
	crafts = {"ctf_ranged:ammo", "ctf_melee:sword_steel", "ctf_melee:sword_mese", "ctf_melee:sword_diamond"},
	physics = {sneak_glitch = true, new_move = false},
	team_chest_items = {"default:cobble 99", "default:wood 99", "default:torch 30", "ctf_teams:door_steel 2"},
	rankings = rankings,
	recent_rankings = recent_rankings,
	summary_ranks = {
		_sort = "score",
		"score",
		"flag_captures", "flag_attempts",
		"kills", "kill_assists", "bounty_kills",
		"deaths",
		"hp_healed"
	},

	stuff_provider = function()
		return {"default:sword_stone", "default:pick_stone", "default:torch 15", "default:stick 5"}
	end,
	on_mode_start = function()
		ctf_modebase.bounties.bounty_reward_func = ctf_modebase.bounty_algo.kd.bounty_reward_func
		ctf_modebase.bounties.get_next_bounty = ctf_modebase.bounty_algo.kd.get_next_bounty
	end,
	on_mode_end = function()
		ctf_modebase.bounties.bounty_reward_func = old_bounty_reward_func
		ctf_modebase.bounties.get_next_bounty = old_get_next_bounty
	end,
	on_new_match = features.on_new_match,
	on_match_end = features.on_match_end,
	team_allocator = features.team_allocator,
	on_allocplayer = features.on_allocplayer,
	on_leaveplayer = features.on_leaveplayer,
	on_dieplayer = function (player)
		local pname = player:get_player_name()
		local pteam = ctf_teams.get(player)

		if ctf_modebase.is_captured(pteam) then
			ctf_teams.allocate_player(pname)
		end
	end,
	on_respawnplayer = features.on_respawnplayer,
	can_take_flag = features.can_take_flag,
	on_flag_take = function (player)
		ctf_modebase.capture_flag(player)
	end,
	on_flag_drop = function() end,
	on_flag_capture = function (player, team)
		return features.on_flag_capture(player, team, function() end)
	end,
	on_flag_rightclick = function() end,
	get_chest_access = features.get_chest_access,
	can_punchplayer = features.can_punchplayer,
	on_punchplayer = features.on_punchplayer,
	on_healplayer = features.on_healplayer,
	calculate_knockback = function()
		return 0
	end,
})