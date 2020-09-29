return {
    name = "dog",
    aliases = {"dogs", "doggos", "doggo", "bork", "woof"},
    description = "Sends a random dog picture!",
    execute = function(message, args)
        local JSON = require("json")
        local http = require("coro-http")

        local status, err = pcall(function()
            local link = "https://dog.ceo/api/breeds/image/random"
            local response, body = http.request("GET", link)
            local file = JSON.parse(body)
            message.channel:send(file.message);
        end)

        if not status then
            print(err)
            return message.user:send("There was an error.\n".. string.format('`%s`', err))
        end
    end
}
