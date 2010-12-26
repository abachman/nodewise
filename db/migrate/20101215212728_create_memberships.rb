class CreateMemberships < ActiveRecord::Migration
  def self.up
    create_table :memberships do |t|
      t.integer  :user_id, :null => false
      t.string   :state, :null => false
      t.decimal  :monthly_fee, :null => false
      t.datetime :member_since

      t.timestamps
    end

    add_index :memberships, :user_id, :unique => true
  end

  def self.down
    drop_table :memberships
  end
end
