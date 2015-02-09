class AddDefaultsToBalances < ActiveRecord::Migration
  def change
    change_column :balances, :frozen_points,  :integer, :default => 0
    change_column :balances, :frozen_points,  :integer, :default => 0
    change_column :balances, :frozen_points,  :integer, :default => 0
  end
end
