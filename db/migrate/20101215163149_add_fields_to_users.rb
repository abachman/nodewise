class AddFieldsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :image_url, :string
    add_column :users, :bio, :text
    add_column :users, :rendered_bio, :text
    add_column :users, :links, :text
    add_column :users, :name, :string
  end

  def self.down
    remove_column :users, :name
    remove_column :users, :links
    remove_column :users, :rendered_bio
    remove_column :users, :bio
    remove_column :users, :image_url
  end
end
