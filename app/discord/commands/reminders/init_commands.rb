Bot.register_application_command(:reminder, 'The reminder commands') do |cmd|
  cmd.subcommand(:create_once, 'Creates a reminder') do |sub|
    sub.string('date', "The date when the reminder should remind you (12:15, 12:15 15.09, ...)")
    sub.string('message', "The message for the reminder")
  end
  cmd.subcommand(:create_cron, 'Creates a reminder with a cron job') do |sub|
    sub.string('cron-expression', "The date when the reminder should remind you")
    sub.string('message', "The message for the reminder")
  end
  cmd.subcommand(:list, 'Lists all reminders')
  cmd.subcommand(:delete, 'Deletes a reminder') do |sub|
    sub.string('id', "The id of the reminder to delete")
  end
end

