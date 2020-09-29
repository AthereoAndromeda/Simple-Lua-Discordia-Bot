return {
    name = "dadjoke",
    aliases = {"jk", "joke"},
    execute = function(message, args)
        local JSON = require("json")
        local http = require("coro-http")

        local status, err = pcall(function()
            local link = "https://icanhazdadjoke.com/"
            local headers = {
                {"Accept", "application/json"}
            }

            local res, body = http.request("GET", link, headers)
            local file = JSON.parse(body)
            --if file.status < 200 or file.status >= 300 then error("Status Code: "..file.status) end
            return message.channel:send(file.joke)
        end)

        if not status then
            message.channel:send("There was an error.\n".. string.format('`%s`', err))
        end

    end
}
