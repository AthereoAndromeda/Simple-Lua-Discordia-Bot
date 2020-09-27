return {
    name = "fact",
    aliases = {"facts", "randomfact", "randomfacts"},
    description = "Sends random useless fact. Type today as args for fact of the day.",
    usage = "<empty or today>",
    cooldown = 0,
    guildOnly = false,
    args = false,
    roles = nil,
    execute = function(message, args)
        local JSON = require("json")
        local http = require("coro-http")

        local status, err = pcall(function()
            coroutine.wrap(function()
                local randomLink = "https://uselessfacts.jsph.pl/random.json?language=en"
                local todayLink = "https://uselessfacts.jsph.pl/today.json?language=en"

                local options = {
                    headers = {
                        {"Accept", "application/json"},
                    }
                }

                if not args then
                    res, body = http.request("GET", randomLink, options.headers)
                elseif args:lower() == "today" then
                    res, body = http.request("GET", todayLink, options.headers)
                end
                local file = JSON.parse(body)
                message:reply(file.text)
            end)()
        end)

        if not status then
            return message:reply("There was an error\n"..string.format('`%s`', err))
        end
    end
}