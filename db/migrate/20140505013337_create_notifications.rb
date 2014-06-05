class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :sendable_id
      t.string :sendable_type
      t.integer :receiver_id
      t.integer :targetable_id
      t.string :targetable_type
      t.string :content

      t.timestamps
    end
    add_index :notifications, [:sendable_id, :sendable_type]
    add_index :notifications, :receiver_id
    add_index :notifications, [:targetable_id, :targetable_type]
  end
end
