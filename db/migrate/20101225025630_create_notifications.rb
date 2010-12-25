class CreateNotifications < ActiveRecord::Migration
  def self.up
    create_table :notifications, :force => true do |t|
      t.integer :invoice_id
      t.string  :cause
    end
    add_column :users, :receive_notifications, :boolean, :default => true
  end

  def self.down
    remove_column :users, :receive_notifications
    drop_table :notifications
  end
end
