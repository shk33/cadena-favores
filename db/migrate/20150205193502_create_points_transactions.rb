class CreatePointsTransactions < ActiveRecord::Migration
  def change
    create_table :points_transactions do |t|
      t.references :service_arrangement, index: true
      t.integer :sender_id
      t.integer :receiver_id
      t.integer :amount
      t.timestamps
    end
    add_index :points_transactions, :sender_id
    add_index :points_transactions, :receiver_id
  end
end
