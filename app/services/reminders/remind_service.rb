# frozen_string_literal: true

module Reminders
  class RemindService

    attr_reader :reminder

    def initialize(reminder)
      @reminder = reminder
    end

    def execute
      if reminder.once?
        return ServiceResponse.error(payload: reminder) if reminder.execute_at > Time.now
      else
        return ServiceResponse.error(payload: reminder) if reminder.execute_at > Time.now
      end

      user = Bot.user(reminder.owner)
      user.pm.send_embed("#{reminder.message} <@#{reminder.owner}>") do |embed|
        embed.title = ":alarm_clock: A reminder has been triggered"
        embed.color = "00ff32"
        embed.description =
          <<~STR
            :speech_left: `#{reminder.message.to_s}`
            :date: #{reminder.execute_at.to_s}
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