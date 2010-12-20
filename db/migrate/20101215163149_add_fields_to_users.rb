class AddFieldsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :image_url,    :string
    add_column :users, :bio,          :text
    add_column :users, :rendered_bio, :text
    add_column :users, :full_name,    :string
    add_column :users, :username,     :string
    add_column :users, :status,       :string
    add_column :users, :roles_mask,   :integer
    add_column :users, :send_dues_notification, :boolean
  end

  def self.down
    remove_column :users, :send_dues_notification
    remove_column :users, :roles_mask
    remove_column :users, :status
    remove_column :users, :username
    remove_column :users, :full_name
    remove_column :users, :rendered_bio
    remove_column :users, :bio
    remove_column :users, :image_url
  end
end
