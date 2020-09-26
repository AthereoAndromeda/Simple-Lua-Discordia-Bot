return {
    name = "fox",
    description = "CUTE FOX PICSSSS",
    execute = function (message, args)
        local JSON = require("json")
        local http = require("coro-http")

        local status, err = pcall(function()
            coroutine.wrap(function()
                local link = "https://randomfox.ca/floof/?ref=apilist.fun"
                local response, body = http.request("GET", link)
                local file = JSON.parse(body)
                return message.channel:send(file.image)    
            end)()
        end)

        if not status then
            message.channel:send("There was an error.\n".. string.format('`%s`', err))
        end
    end
}