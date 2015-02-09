class AddDefaultsZerosToBalances < ActiveRecord::Migration
  def change
    change_column :balances, :frozen_points,  :integer, :default => 0
    change_column :balances, :usable_points,  :integer, :default => 0
    change_column :balances, :total_points,   :integer, :default => 0
  end
end
