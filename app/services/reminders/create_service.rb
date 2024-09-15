# frozen_string_literal: true

module Reminders
  class CreateService

    attr_reader :owner, :message, :type, :execution

    def initialize(owner, message, type, execution)
      @owner = owner
      @message = message
      @type = type
      @execution = execution
    end

    def execute
      case type
      when :cron
        reminder = ::Reminder.create(owner: owner, message: message, execute_type: type.to_s, cron_expression: execution, execute_at: Fugit::Cron.parse(execution).next_time.to_time_s)
      when :once
        reminder = ::Reminder.create(owner: owner, message: message, execute_type: "once", execute_at: parse_date(execution))
      else
        return ServiceResponse.error(payload: :not_a_valid_type, message: "#{type.to_s} is not a valid type")
      end
      unless reminder.persisted?
        return ServiceResponse.error(payload: reminder.errors, message: 'Failed to create Reminder')
      end
      ServiceResponse.success(payload: reminder)
    end

    def parse_date(date_str)
      if date_str.strip.length <= 5
        # Case: only time is provided
        date_str = "#{date_str} #{Time.now.strftime('%d.%m.%Y')}"
      elsif date_str.strip.length <= 11
        # Case: day and month are provided, append current year
        date_str = "#{date_str}.#{Time.now.year}"
      end

      DateTime.strptime(date_str, '%H:%M %d.%m.%Y')
    end
  end

end