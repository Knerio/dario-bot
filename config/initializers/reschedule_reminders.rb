Rails.application.config.after_initialize do
  while true
    break if ENV.fetch("DISCORD_BOT_TOKEN", nil).nil?
    sleep 5
    Reminder.all.each do |reminder|
      Reminders::RemindService.new(reminder).execute
    end
  end
end