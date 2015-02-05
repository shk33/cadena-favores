class AddClientServerIndexToServiceArrangement < ActiveRecord::Migration
  def change
    add_index :service_arrangements, :client_id
    add_index :service_arrangements, :server_id
    add_index :service_arrangements, [:client_id, :server_id], unique: true
  end
end
