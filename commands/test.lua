return {
    name = "test",
    aliases = {"t"},
    description = "Used for testing",
    usage = nil,
    cooldown = 0,
    guildOnly = false,
    args = false,
    role = nil,
    execute = function(message, args)
        local JSON = require("json")
        local http = require("coro-http")
        local querystring = require("querystring")

        local status, err = pcall(function()
            coroutine.wrap(function()
                local link = "https://jsonplaceholder.typicode.com/posts"
                local options = {
                    headers = {
                        {"Accept", "application/json"},
                        {"Content-type", "application/json"}
                    },
                    body = JSON.stringify({
                        title = "Lol",
                        number = 102,
                        what = true
                    })
                }

                local res, body = http.request("POST", link, options.headers, options.body)
                local file = JSON.parse(body)
                p(file)



            end)()
        end)

        if not status then
            --p(err)
            message.channel:send("There was an error.\n".. string.format('`%s`', err))
        end

    end
}