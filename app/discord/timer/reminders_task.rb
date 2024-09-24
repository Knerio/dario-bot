class RemindersTask
  def start
    return if ENV.fetch("DISCORD_BOT_TOKEN", nil).nil?
    Reminder.all.each do |reminder|
      Reminders::RemindService.new(reminder).execute
    end
  end
end