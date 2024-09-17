Bot.application_command(:reminder).subcommand(:list) do |event|

  embed = create_reminder_embed(event.user.id, 1, 5)
  more_reminders = Reminder.where(owner: event.user.id).offset(5).exists?

  event.respond(content: "<@#{event.user.id}>", embeds: [embed]) do |_, view|
    view.row do |r|
      r.button(label: 'Previous', emoji: nil, style: :primary, custom_id: 'previous_page_reminder', disabled: true)
      r.button(label: 'Next', emoji: nil, style: :primary, custom_id: 'next_page_reminder', disabled: !more_reminders)
    end
  end
end

Bot.button(custom_id: 'previous_page_reminder') do |event|
  current_page = event.message.embeds.first.title.match(/Page (\d+)/)[1].to_i
  current_page -= 1

  embed = create_reminder_embed(event.user.id, current_page, 5)
  more_reminders = Reminder.where(owner: event.user.id).offset(current_page * 5).exists?

  event.update_message(content: "<@#{event.user.id}>", embeds: [embed]) do |_, view|
    view.row do |r|
      r.button(label: 'Previous', emoji: nil, style: :primary, custom_id: 'previous_page_reminder', disabled: current_page == 1)
      r.button(label: 'Next', emoji: nil, style: :primary, custom_id: 'next_page_reminder', disabled: !more_reminders)
    end
  end
end

Bot.button(custom_id: 'next_page_reminder') do |event|
  current_page = event.message.embeds.first.title.match(/Page (\d+)/)[1].to_i
  current_page += 1

  embed = create_reminder_embed(event.user.id, current_page, 5)

  more_reminders = Reminder.where(owner: event.user.id).offset(current_page * 5).exists?

  event.update_message(content: "<@#{event.user.id}>", embeds: [embed]) do |_, view|
    view.row do |r|
      r.button(label: 'Previous', emoji: nil, style: :primary, custom_id: 'previous_page_reminder', disabled: current_page == 1)
      r.button(label: 'Next', emoji: nil, style: :primary, custom_id: 'next_page_reminder', disabled: !more_reminders)
    end
  end
end

def create_reminder_embed(user_id, page, reminders_per_page)
  reminders = Reminder.where(owner: user_id).offset((page - 1) * reminders_per_page).limit(reminders_per_page)
  embed = Discordrb::Webhooks::Embed.new(
    title: ":pen_ballpoint: Your Reminders (Page #{page}):",
    color: 0x00ff32
  )

  reminders.each do |reminder|
    embed.add_field(
      name: ":date: #{reminder.next_execution.to_time_zone("Europe/Berlin")}",
      value: [
        ":speech_left: `#{reminder.message}`",
        (":gear: #{reminder.cron_expression}" if reminder.cron?),
        ":id: #{reminder.id}"
      ].compact.join("\n")
    )
  end

  embed
end
