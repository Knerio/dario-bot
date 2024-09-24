Bot.command(:invite_url) do |event|
  event.respond content: Bot.invite_url, ephemeral: true
end
