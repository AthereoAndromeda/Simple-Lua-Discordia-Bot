local Discordia = require('discordia')
local client = Discordia.Client()
local JSON = require('json')
local http = require("coro-http")
local fs = require("fs")
local timer = require("timer")
Discordia.extensions()


local commandFiles = fs.readdirSync("./commands")
client["_commands"] = {}
local commandList = client["_commands"]

for _, file in ipairs(commandFiles) do
    local command = require("./commands/"..file)
    commandList[command.name] = command
end

local configFile = io.open("./config.json")
local config = JSON.parse(configFile:read("*a"))
configFile:close()


client:on('ready', function()
    print('Logged in as '.. client.user.username)
    -- client:getChannel('channel-id'):send("Are ya coding son?")
    -- timer.setInterval(10 *1000, function()
    --     coroutine.wrap(function()
    --         client:getChannel('channel-id'):send("I'm still alive.")
    --     end)()
    -- end)
    -- client.user
    -- local member = message.member
    -- local memeberID = message.member.id
end)

client:on('messageCreate', function(message)
    if not string.startswith(message.content, config.Prefix) or message.author.bot then return end
    -- if message.author.id == client.owner then return message:reply("oof") end

    --* This is just cringe 
    local messageParser = string.split(string.trim(message.content), " ")
    local commandTable = string.split(messageParser[1]:lower()) 
    local commandParser = table.slice(commandTable, #config.Prefix + 1)
    local argsTable = table.slice(messageParser, 2)
    local commandName = string.trim(table.concat(commandParser))
    local args = string.trim(table.concat(argsTable, " "))

    --* empty args dont turn to nil because of parser so i do this. Oof
    if args == "" then args = nil end

    --* I have no idea how else to get commands via their aliases.
    local function findAlias()
        for key, _ in pairs(commandList) do
            if commandList[key].aliases then
                local alias = table.search(commandList[key].aliases, commandName)
                if alias then
                    return commandList[key]
                end
            end
        end
    end 

    local command = commandList[commandName] or findAlias()
    if not command then return message:reply("Not a valid command.") end


    local status, err = pcall(function()
        command.execute(message, args)
    end)

    if not status then
        print(err)
        return message.channel:send("There was an error!\n"..string.format('`%s`', err))
    end

end)

client:run(config.Token)
