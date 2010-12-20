class CreatePayments < ActiveRecord::Migration
  def self.up
    create_table :payments do |t|
      t.decimal :amount, :null => false
      t.integer :invoice_id, :null => false
      t.string  :note

      t.timestamps
    end
  end

  def self.down
    drop_table :payments
  end
end
