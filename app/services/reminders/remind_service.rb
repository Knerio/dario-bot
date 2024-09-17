# frozen_string_literal: true

module Reminders
  class RemindService

    attr_reader :reminder

    def initialize(reminder)
      @reminder = reminder
    end

    def execute
      if reminder.once?
        return ServiceResponse.error(payload: reminder) if reminder.next_execution.in_time_zone("Europe/Berlin") > Time.now.in_time_zone("Europe/Berlin")
      else
        return ServiceResponse.error(payload: reminder) if reminder.next_execution.in_time_zone("Europe/Berlin") > Time.now.in_time_zone("Europe/Berlin")
      end

      user = Bot.user(reminder.owner)
      user.pm.send_embed("#{reminder.message} <@#{reminder.owner}>") do |embed|
        embed.title = ":alarm_clock: A reminder has been triggered"
        embed.color = "00ff32"
        embed.description =
          <<~STR
            :speech_left: `#{reminder.message.to_s}`
            :date: #{reminder.next_execution.to_s}
            :id: #{reminder.id.to_s}
          STR
      end

      if reminder.once?
        reminder.delete
      else
        next_execution = reminder.next_execution.to_s
        reminder.update(execute_at: next_execution) 
      end

      ServiceResponse.success(payload: reminder)
    end
  end
end