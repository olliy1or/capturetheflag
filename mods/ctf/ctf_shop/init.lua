minetest.register_node("ctf_shop:shop", {
	description = "CTF Shop",
	diggable = false,
	on_punch = function(pos, node, puncher, pointed_thing)
		local team
		for t in ctf_teams.team do
			if ctf_core.pos_inside(pointed_thing.above, ctf_teams.get_team_territory(t)) then
				team = t
			end
		end
		if puncher:is_player() and team ~= ctf_teams.get(puncher:get_player_name()) then
			local meta = minetest.get_meta(pos)
			local hp = meta:get("hp")
			if not hp then
				hp = 150
			end
			hp = tonumber(hp) - 1
			param = {
				pos = pos,
				fade = (hp == 0 and -0.1 or 0.0),
			}
			minetest.sound_play("ctf_shop_hit.ogg", param, true)
			if hp > 0 then
				meta:set_int("hp", hp)
			else
				minetest.set_node(pos, "air")
			end
		end
	end,
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		-- Show shop form
	end,
})
