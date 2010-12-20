class CreateInvoices < ActiveRecord::Migration
  def self.up
    create_table :invoices do |t|
      t.decimal  :amount
      t.string   :reason
      t.datetime :due_by
      t.boolean  :paid
      t.integer  :membership_id, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :invoices
  end
end
