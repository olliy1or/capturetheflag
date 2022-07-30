minetest.register_node("ctf_shop:shop", {
	description = "CTF Shop",
	diggable = false,
	on_punch = function(pos, node, puncher, pointed_thing)
		local team = "red"
		if puncher:is_player() and team ~= ctf_teams.get(puncher:get_player_name()) then
			local meta = minetest.get_meta(pos)
			local hp = meta:get("hp")
			if not hp then
				hp = 150
			end
		end
	end,
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		-- Show shop form
	end,
})
