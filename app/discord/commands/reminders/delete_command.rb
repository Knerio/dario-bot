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
          :date: #{response.payload.next_execution.in_time_zone("Europe/Berlin").to_s}
          :id: #{response.payload.id}
        STR
    )], ephemeral: event.channel.type != 1
end
