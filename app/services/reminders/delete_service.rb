# frozen_string_literal: true

module Reminders
  class DeleteService

    attr_reader :reminder_id, :owner_id

    def initialize(reminder_id, owner_id)
      @reminder_id = reminder_id
      @owner_id = owner_id
    end

    def execute
      reminder = Reminder.find_by(id: reminder_id, owner: owner_id)
      if reminder.nil?
        return ServiceResponse.error(message: "The reminder doesnt exists or you dont have enough permission to delete that", payload: :forbidden)
      end
      reminder.delete
      if reminder.persisted?
        return ServiceResponse.error(message: "Failed to delete", payload: reminder.errors)
      end
      ServiceResponse.success(payload: reminder)
    end

  end

end