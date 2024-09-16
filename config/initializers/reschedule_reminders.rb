Rails.application.config.after_initialize do
  while true
    sleep 5
    continue if ENV.fetch("DISCORD_BOT_TOKEN", nil).nil?
    Reminder.all.each do |reminder|
      Reminders::RemindService.new(reminder).execute
    end
  end
end