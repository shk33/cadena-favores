class RemoveServerClienteIndexFromServiceArrangements < ActiveRecord::Migration
  def change
    remove_index :service_arrangements, :name => 'index_service_arrangements_on_client_id_and_server_id'
  end
end
