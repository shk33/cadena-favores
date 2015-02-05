class CreateBalances < ActiveRecord::Migration
  def change
    create_table :balances do |t|
      t.references :user, index: true
      t.integer :frozen_points
      t.integer :usable_points
      t.integer :total_points

      t.timestamps
    end
  end
end
