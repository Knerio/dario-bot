class CreateJoinRoles < ActiveRecord::Migration[7.2]
  def change
    create_table :join_roles do |t|
      t.bigint :guild_id
      t.bigint :role_ids, array: true, default: []

      t.timestamps
    end
  end
end
