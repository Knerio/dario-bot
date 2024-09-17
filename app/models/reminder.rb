class Reminder < ApplicationRecord
  enum :execute_type, { :cron => "cron", :once => "once" }

  validates :cron_expression, presence: true, if: :cron?
  validates :execute_at, presence: true, if: :once?
  validates :owner, presence: true

  validate :valid_execution_time?

  def next_execution
    if once?
      return self.execute_at
    end
    cron = Fugit::Cron.parse(self.cron_expression).change
    cron.next_time
  end
  
  private

  def valid_execution_time?
    if cron? && cron_expression.blank?
      errors.add(:cron_expression, "must be present if execute_type is 'cron'")
    elsif cron? && !valid_cron?(cron_expression)
      errors.add(:cron_expression, "must be valid")
    elsif once? && execute_at.blank?
      errors.add(:execute_at, "must be present if execute_type is 'once'")
    end
  end

  def valid_cron?(cron_expression)
    begin
      cron = Fugit::Cron.parse(cron_expression)
      if cron
        true
      else
        false
      end
    rescue StandardError
      false
    end
  end
end
