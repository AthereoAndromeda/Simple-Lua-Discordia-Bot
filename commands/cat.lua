return {
    name = "cat",
    description = "Sends a random cat photo!",
    execute = function (message)
        local JSON = require("json")
        local http = require("coro-http")

        local status, err = pcall(function()
            coroutine.wrap(function()
                local link = "https://aws.random.cat/meow?ref=apilist.fun"
                local response, body = http.request("GET", link)
                local file = JSON.parse(body)
                return message.channel:send(file.file)    
            end)()
        end)

        if not status then
            message.channel:send("There was an error.\n".. string.format('`%s`', err))
        end
    end
    
}