Bot.register_application_command(:invite_url, 'The invite url for the bot') do |event|
  event.respond content: Bot.invite_url, ephemeral: true
end
