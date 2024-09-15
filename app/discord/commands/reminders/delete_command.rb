Bot.application_command(:reminder).subcommand(:delete) do |event|
  response = Reminders::DeleteService.new(event.options["id"],event.user.id).execute
  if response.error?
    ErrorResponse.service_response(response).respond event
    next
  end
  event.respond content: "<@#{event.user.id}>", embeds: [
    Discordrb::Webhooks::Embed.new(
      title: "Successfully deleted",
      color: "00ff32",
      description:
        <<~STR
          :speech_left: `#{response.payload.message}`
          :date: #{response.payload.execute_at.to_s}
          :id: #{response.payload.id}
        STR
    )]
end
