local Discordia = require('discordia')
local client = Discordia.Client()
local JSON = require('json')
local fs = require("fs")
local timer = require("timer")
Discordia.extensions()

--TODO Create API using Numbers trivia api in rakuten. Jekyll and Hyde

-- @FGRibreau - Francois-Guillaume Ribreau
-- @Redsmin - A full-feature client for Redis http://redsmin.com
-- Credits for table.filter function
table.filter = function(t, filterIter)
    local out = {}
    for k, v in ipairs(t) do
        if filterIter(v, k, t) then table.insert(out, v) end
    end
    return out
end

local commandFiles = table.filter(fs.readdirSync("./commands"), function(file)
    return string.endswith(file, ".lua")
end)

client["_commands"] = {}
local commandList = client["_commands"]

for _, file in ipairs(commandFiles) do
    local command = require("./commands/"..file)
    commandList[command.name] = command
end


local configFile = io.open("./config.json") 
local config = process.env or JSON.parse(configFile:read("*a"))
configFile:close()

-- local function code(str)
--     return string.format('`%s`', str)
-- end

-- local function exec(arg, msg)
--     if not arg then return end -- make sure arg exists
--     if msg.author ~= msg.client.owner then return end -- restrict to owner only

--     local fn, syntaxError = load(arg) -- load the code
--     if not fn then return msg:reply(code(syntaxError)) end -- handle syntax errors

--     local success, runtimeError = pcall(fn) -- run the code
--     if not success then return msg:reply(code(runtimeError)) end -- handle runtime errors
-- end


client:on('ready', function()
    print('Logged in as '.. client.user.username)
    -- client:getChannel('uh'):send("Are ya coding son?")
    -- timer.setInterval(10 * 1000, function()
    --     coroutine.wrap(function()
    --         client:getChannel('no'):send("I'm still alive.")
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

    --* I have no idea how else to get commands via their aliases. Change github file
    local function findAlias()
        for cmd, _ in pairs(commandList) do
            if commandList[cmd].aliases then
                local alias = table.search(commandList[cmd].aliases, commandName)
                if alias then
                    return commandList[cmd]
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
