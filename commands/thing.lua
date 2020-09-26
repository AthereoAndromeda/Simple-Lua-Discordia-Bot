return {
    name = "thing",
    aliases = {"repeat", "chungus"},
    description = "test stuff",
    execute = function(message, args)
        if not args then
            return message:reply("You need to provide arguments!")
        end
        
        if args == "yeet" then
            message:reply("BIG CHUNGUS")
    
        elseif args == 'brah' then
            message.channel:send("yeeet")

        elseif args == 'ping' then
            message.channel:send('Pong!')
        end
        
        message:reply(args)
    end
}
