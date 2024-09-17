Bot.application_command(:reminder).subcommand(:create_cron) do |event|
  response = Reminders::CreateService.new(event.user.id, event.options["message"], :cron, event.options["cron-expression"]).execute
  if response.error?
    ErrorResponse.service_response(response).respond event
    next
  end
  event.respond content: "<@#{event.user.id}>", embeds: [
    Discordrb::Webhooks::Embed.new(
      title: "Successfully created",
      color: "00ff32",
      description:
        <<~STR
          :speech_left: `#{response.payload.message}`
          :date: #{response.payload.execute_at.to_time_zone("Europe/Berlin").to_s}
          :gear: #{response.payload.cron_expression}
          :id: #{response.payload.id}
        STR
    )]
end
