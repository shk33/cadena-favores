class AddDefaultValueToServiceArrangments < ActiveRecord::Migration
  def change
    change_column :service_arrangements, :completed, :boolean, :default => false
  end
end
