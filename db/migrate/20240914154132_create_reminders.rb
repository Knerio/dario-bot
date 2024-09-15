class CreateReminders < ActiveRecord::Migration[7.2]
  def change
    create_table :reminders do |t|
      t.bigint :owner, null: false
      t.text :message, null: false
      t.string :execute_type, null: false
      t.string :cron_expression
      t.datetime :execute_at

      t.timestamps
    end
  end
end
