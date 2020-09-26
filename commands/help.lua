return {
    name = "help",
    description = "Gets description of all commands",
    execute = function (message, args)
        local commandList = message.client["_commands"]
        local list = {}

        for key, _ in pairs(commandList) do
            p(commandList[key])
            list[commandList[key].name] = commandList[key].description
        end

        local function alias()
            for key,_ in pairs(commandList) do
                if commandList[key].aliases then
                    local alias = table.search(commandList[key].aliases, args)
                    if alias then
                        return commandList[key]
                    end
                end
            end
        end 

        local function sendAllCommands()
            
        end

        local function sendCommand(cmd)
            message.author:send({
                embed = {
                    title =  ""
                }
            })
        end
    
        local command = commandList[args] or alias()
        if not command then return sendAllCommands() end
    
    
       --TODO convert to string and sned and do embeds
       --? I dunno Stuff
    end
}
