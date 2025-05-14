local afk_mode = true

afk_api.register_on_afk({
    period = nil,  -- if provided, the callback will be called every `period` seconds. otherwise, it will just be called
                   -- once when a player is deemed to have gone AFK.
    func = function(player, afk_time)
        if not afk_mode then
            return
        end

        local player_name = player:get_player_name()

        minetest.chat_send_player(player_name, "You have been AFK for " .. afk_time .. " seconds. Teleporting to spawn...")
        
        player:respawn() -- Respawn player
    end,
})

afk_api.register_on_back({
    func = function(player, afk_time)
        if not afk_mode then
            return
        end

        local player_name = player:get_player_name()

        minetest.chat_send_player(player_name, "You are back from being AFK after " .. afk_time .. " seconds.")
    end,
})

-- Chatcommand for toggling AFK teleportation
minetest.register_chatcommand("set_afk_mode", {
    params = "<mode>",
    description = "Set AFK mode (on/off)",
    func = function(name, param)
        if minetest.check_player_privs(name, { server = true }) or minetest.check_player_privs(name, { teacher = true }) then

            local mode = param:lower()

            if mode == "on" then
                afk_mode = true
                minetest.chat_send_player(name, "AFK mode is now ON.")
            elseif mode == "off" then
                afk_mode = false
                minetest.chat_send_player(name, "AFK mode is now OFF.")
            else
                minetest.chat_send_player(name, "Invalid mode. Use 'on' or 'off'.")
            end
        else
            minetest.chat_send_player(name, "You do not have permission to use this command.")
        end
    end,
})