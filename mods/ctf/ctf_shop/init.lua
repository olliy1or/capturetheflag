local items = {
	{
		give = "default:steel_ingot 25",
		take = "default:sword_steel 1",
	},
	{
		give = "default:steel_ingot 35",
		take = "default:sword_bronze 1",
	},
	{
		give = "default:gold_ingot 7",
		take = "default:sword_bronze 1",
	},
	{
		give = "default:gold_ingot 15",
		take = "default:sword_mese 1",
	},
	{
		give = "default:gold_ingot 25",
		take = "default:sword_diamond 1",
	},
}

local swords_hitpoint = {
	{ sword = "default:sword_stone", hp = 1 },
	{ sword = "default:sword_bronze", hp = 6 },
	{ sword = "default:sword_steel", hp = 4 },
	{ sword = "default:sword_mese", hp = 10 },
	{ sword = "default:sword_diamond" , hp = 12},
}

minetest.register_node("ctf_shop:shop", {
	description = "CTF Shop",
	diggable = false,
	on_punch = function(pos, node, puncher, pointed_thing)
		local team
		for t , _ in pairs(ctf_map.current_map.teams) do
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
			local tool = puncher:get_wielded_item():get_name()
			minetest.chat_send_all(tool)
			local dmg = 0
			for _, sword_hp in pairs(swords_hitpoint) do
				minetest.chat_send_all(sword_hp.sword)
				if sword_hp.sword == tool then
					dmg = sword_hp.hp
				end
			end
			hp = tonumber(hp) - dmg
			local param = {
				pos = pos,
				fade = (hp == 0 and -0.1 or 0.0),
			}
			if dmg > 0 then
				minetest.sound_play("ctf_shop_hit", param, true)
			end
			if hp > 0 then
				meta:set_int("hp", hp)
			else
				minetest.set_node(pos, {name="air"})
			end
		end
	end,
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		local formspec = "size[8,8]"
		local x = 1
		local y = 1
		for _, item in pairs(items) do		
			local fmt = "item_image_button[%d,%d;1,1;%s;give;%d]"
			local item_name, label = string.match(item.give, "(.*) (.*)")
			formspec = formspec .. string.format(fmt, x, y, item_name, label)
			x = x + 1
			formspec = formspec .. string.format("label[%d,%d;=>]", x, y)
			x = x + 1
			local item_name, _ = string.match(item.take, "(.*) (.*)")
			formspec = formspec .. string.format("item_image[%d,%d;1,1;%s]", x, y, item_name)
			x = x + 2
			if x >= 6 then
				y = y + 1
				x = 1
			end
		end
		minetest.show_formspec(clicker:get_player_name(), "ctf_shop:shop", formspec)
	end,
})
