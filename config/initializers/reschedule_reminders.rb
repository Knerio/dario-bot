Rails.application.config.after_initialize do
  while true
    sleep 5
    Reminder.all.each do |reminder|
      Reminders::RemindService.new(reminder).execute
    end
  end
end