Bot.command(:eval, help_available: false) do |event, *code|
  break unless event.user.id == 639416958923702292

  begin
    eval code.join(' ')
  rescue StandardError => e
    p e
    'An error occurred 😞'
  end
end
