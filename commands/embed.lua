return {
    name = "embed",
    execute = function(message, args)
        local thing = {
            embed = {
                title = "Embed Title",
                description = "Here is my fancy description!",
                author = {
                    name = message.author.username,
                    icon_url = message.author.avatarURL
                },
                fields = { -- array of fields
                    {
                        name = "Field 1",
                        value = "This is some information",
                        inline = true
                    },
                    {
                        name = "Field 2",
                        value = "This is some more information",
                        inline = false
                    }
                },
                footer = {
                    text = "Created with Discordia"
                },
                color = 0x000000 -- hex color code
            }
        }
        message:reply(thing)
    end
}